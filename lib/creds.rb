require "rails"

require "creds/version"
require "creds/errors"

# The main module of rails-creds
class Creds
  include Singleton

  # Credentials that are always nil
  class NullCredentials
    def respond_to_missing?(_name)
      true
    end

    def method_missing(*_args)
      nil
    end

    def nil?
      true
    end
  end

  def self.respond_to_missing?(_name)
    true
  end

  def self.method_missing(name, *_args)
    instance.credentials.fetch(name)
  rescue KeyError
    raise MissingKeyError.new(name, Rails.env)
  end

  def self.to_h
    instance.credentials
  end

  def credentials
    return @credentials if @credentials

    if dummy?
      @credentials = NullCredentials.new
      return @credentials
    end

    unless encrypted_credentials_exist?
      Rails.logger.warn(MissingCredentialsWarning)
      @credentials = NullCredentials.new
      return @credentials
    end

    raise MissingMasterKeyError unless master_key_present?

    @credentials = fetch_credentials_for_current_env
  end

  private

  def fetch_credentials_for_current_env
    base = Rails.application.credentials.config
    scoped = base.fetch(Rails.env.to_sym)
    base.delete(Rails.env.to_sym)
    base.merge(scoped)
  rescue KeyError
    raise MissingEnvError, Rails.env
  end

  def encrypted_credentials_exist?
    File.exist?(Rails.root.join("config", "credentials.yml.enc"))
  end

  def master_key_present?
    return true unless Rails.application.config.require_master_key
    return true if ENV["RAILS_MASTER_KEY"]
    return true if File.exist?(Rails.root.join("config", "master.key"))

    false
  end

  def dummy?
    ENV.fetch("SECRET_KEY_BASE_DUMMY", nil) == "1"
  end
end
