ENV["RAILS_ENV"] = "test"

require "action_controller/railtie"

RSpec.describe Creds do
  before do
    class RailsTestApp < Rails::Application
      config.secret_key_base = "__secret_key_base"
      config.logger = Logger.new(STDOUT)
      config.eager_load = false
      config.require_master_key = true
    end

    RailsTestApp.initialize!

    # reset cache
    Creds.instance.instance_variable_set(:@credentials, nil)

    write_config({})
  end

  after do
    %i[RailsTestApp].each do |const|
      Object.send(:remove_const, const)
    end

    Rails.application = nil

    # For Rails 7, which freezes these in an initializer.
    # Can't start a new instance of the application when these are frozen.
    ActiveSupport::Dependencies.autoload_paths = []
    ActiveSupport::Dependencies.autoload_once_paths = []
  end

  it "returns Rails credentials scoped to env" do
    write_config(test: {super_secret: "shh!"})
    expect(Creds.super_secret).to(eq("shh!"))
  end

  it "nulls out everything when SECRET_KEY_BASE_DUMMY=1" do
    ENV["SECRET_KEY_BASE_DUMMY"] = "1"
    write_config(test: {super_secret: "shh!"})
    expect(Creds.other_secret).to(be_nil)
  ensure
    ENV["SECRET_KEY_BASE_DUMMY"] = nil
  end

  it "merges top-level credentials" do
    write_config(super_secret: "shh!", test: {other_secret: "SHH!"})
    expect(Creds.super_secret).to(eq("shh!"))
  end

  it "raises MissingKeyError on missing keys" do
    write_config(test: {super_secret: "shh!"})
    expect { Creds.non_existing_key }.to(raise_error(Creds::MissingKeyError))
  end

  it "raises MissingEnvError on missing env" do
    write_config(development: {})
    expect { Creds.any_key }.to(raise_error(Creds::MissingEnvError))
  end

  it "converts to hash" do
    write_config(test: {super_secret: "shh!"})
    expect(Creds.to_h).to(eq(super_secret: "shh!"))
  end

  it "logs and returns null creds when no encrypted credentials" do
    allow(File).to(
      receive(:exist?).with(Rails.root.join("config/credentials.yml.enc")) { false }
    )
    expect(Rails.logger).to(
      receive(:warn).with(Creds::MissingCredentialsWarning)
    )

    result = Creds.some_key

    expect(result).to(be(nil))
  end

  it "raises with special error when credentials exist but key is missing" do
    allow(File).to(
      receive(:exist?).with(Rails.root.join("config/credentials.yml.enc")) { true }
    )
    allow(File).to(
      receive(:exist?).with(Rails.root.join("config/master.key")) { false }
    )

    expect { Creds.some_key }.to(raise_error(Creds::MissingMasterKeyError))
  end

  def write_config(conf)
    Rails.application.credentials.change do |path|
      File.open(path, "w") { |f| f.write(conf.to_yaml) }
    end
  end
end
