# frozen_string_literal: true

require 'creds/version'
require 'ostruct'
require 'singleton'

require 'rails'

# The main module
class Creds
  class MissingKeyError < StandardError
    MESSAGE = 'Key :%<key>s missing from credentials in "%<env>s" env'.freeze
  end

  class MissingEnvError < StandardError
    # rubocop:disable Layout/TrailingWhitespace
    MESSAGE = <<-MSG
  Creds scopes credentials to the current Rails environment.
  It seems you are missing a scope for the environment "%<env>s".

  Here's an example of how your credentials could look:

  ---
  default: &default
    aws_key: 'shared between environments'

  development:
    <<: *default

  test:
    <<: *default

  production:
    <<: *default
    aws_key: 'you can override defaults for individual environments'
  MSG
              .strip_heredoc.freeze
    # rubocop:enable Layout/TrailingWhitespace
  end

  include Singleton

  # rubocop:disable Style/MethodMissing
  def self.method_missing(name, *_args)
    instance.credentials.fetch(name)
  rescue KeyError
    raise(
      MissingKeyError,
      format(MissingKeyError::MESSAGE, key: name, env: Rails.env)
    )
  end
  # rubocop:enable Style/MethodMissing

  def self.to_h
    instance.credentials
  end

  def credentials
    Rails.application.credentials.fetch(Rails.env.to_sym)
  rescue KeyError
    raise(
      MissingEnvError,
      format(MissingEnvError::MESSAGE, env: Rails.env)
    )
  end
end
