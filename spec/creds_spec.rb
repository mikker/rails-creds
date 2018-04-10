# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'action_controller/railtie'

RSpec.describe Creds do
  before do
    class RailsTestApp < Rails::Application
      config.secret_key_base = '__secret_key_base'
      config.logger = Logger.new(nil)
      config.eager_load = false
      config.require_master_key = true
    end

    RailsTestApp.initialize!

    write_config({})
  end

  after do
    %i[RailsTestApp].each do |const|
      Object.send(:remove_const, const)
    end

    Rails.application = nil
  end

  it 'returns Rails credentials scoped to env' do
    write_config(test: { super_secret: 'shh!' })
    expect(Creds.super_secret).to eq('shh!')
  end

  it 'raises MissingKeyError on missing keys' do
    write_config(test: { super_secret: 'shh!' })
    expect { Creds.non_existing_key }.to raise_error(Creds::MissingKeyError)
  end

  it 'raises MissingEnvError on missing env' do
    write_config(development: {})
    expect { Creds.any_key }.to raise_error(Creds::MissingEnvError)
  end

  it 'converts to hash' do
    write_config(test: { super_secret: 'shh!' })
    expect(Creds.to_h).to eq(super_secret: 'shh!')
  end

  def write_config(conf)
    Rails.application.credentials.change do |path|
      File.open(path, 'w') { |f| f.write(conf.to_yaml) }
    end
  end
end
