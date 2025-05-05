require "rails"
require "active_support/core_ext/string/strip"

require "creds/version"
require "creds/railtie"

# The main module of rails-creds
module Creds
  EXAMPLE_CONFIG = <<-YAML
  ---
  secret_key_base: "abc123"

  shared: &shared
    secret: 123

  test:
    <<: *shared

  development:
    <<: *shared

  production:
    <<: *shared
    secret: 456
  YAML
    .strip_heredoc
    .freeze

  class MissingKeyError < StandardError
    MESSAGE = "Key :%<key>s missing from credentials in \"%<env>s\" env".freeze

    def initialize(key, env)
      super(format(MESSAGE, key: key, env: env))
    end
  end

  class MissingEnvError < StandardError
    MESSAGE = <<-MSG
      It seems you are missing a scope for the environment "%<env>s".

      Here's an example of how your credentials could look:

#{Creds::EXAMPLE_CONFIG.gsub(/^([^\n]+)$/m, "        \\1")}
    MSG
      .strip_heredoc
      .freeze

    def initialize(env)
      super(format(MESSAGE, env: env))
    end
  end

  def self.method_missing(mth, *args, &block)
    @cache ||= Rails.application.credentials[Rails.env].tap do |scoped|
      raise MissingEnvError.new(Rails.env) unless scoped.is_a?(Hash)
      raise MissingKeyError.new(mth, Rails.env) unless scoped.key?(mth.to_sym)

      scoped
    end

    @cache.fetch(mth.to_sym)
  end
end
