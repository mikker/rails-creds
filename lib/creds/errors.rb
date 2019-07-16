class Creds
  class MissingCredentialsWarning
    MESSAGE =
      <<-MSG
      You have no encrypted credentials at config/credentials.yml.enc.
      Creds will return nil for any key.
      Run this to generate your credentials file:
        $ bin/rails credentials:edit
      MSG.freeze
  end

  # @api private
  class MissingKeyError < StandardError
    MESSAGE = 'Key :%<key>s missing from credentials in "%<env>s" env'.freeze

    def initialize(key, env)
      super format(MESSAGE, key: key, env: env)
    end
  end

  # @api private
  class MissingEnvError < StandardError
    # rubocop:disable Layout/TrailingWhitespace
    MESSAGE =
      <<-MSG
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
      MSG.freeze
    # rubocop:enable Layout/TrailingWhitespace

    def initialize(env)
      super format(MESSAGE, env: env)
    end
  end

  # @api private
  class MissingMasterKeyError < StandardError
    MESSAGE =
      <<-MSG
        You have encrypted credentials but no master key.

        Either get or recover the file config/master.key
        or set the environment variable RAILS_MASTER_KEY
      MSG.freeze

    def initalize
      super(MESSAGE)
    end
  end
end
