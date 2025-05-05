ENV["RAILS_ENV"] = "test"

require "action_controller/railtie"

RSpec.describe Creds do
  before do
    class RailsTestApp < Rails::Application
      config.secret_key_base = "__secret_key_base"
      config.logger = Logger.new(STDOUT)
      config.eager_load = false
      config.require_master_key = true

      # Silence warning
      config.active_support.to_time_preserves_timezone = :zone
    end

    RailsTestApp.initialize!

    # reset cache
    Creds.instance_variable_set(:@cache, nil)

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
    write_config(
      <<-YAML
      test:
        super_secret: "shh!"
      YAML
    )
    expect(Creds.super_secret).to(eq("shh!"))
  end

  it "raises MissingKeyError on missing keys" do
    write_config(
      <<-YAML
      test:
        super_secret: "shh!"
      YAML
    )
    expect { Creds.non_existing_key }.to(raise_error(Creds::MissingKeyError))
  end

  it "raises MissingEnvError on missing env" do
    write_config(
      <<-YAML
        development:
          super_secret: "shh!"
      YAML
    )
    expect { Creds.super_secret }.to(raise_error(Creds::MissingEnvError))
  end

  def write_config(yaml)
    Rails.application.credentials.change do |path|
      File.open(path, "w") { |f| f.write(yaml) }
    end
  end
end
