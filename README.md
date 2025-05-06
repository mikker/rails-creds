<h1><img src='https://s3.brnbw.com/logo-2x-SiurkO6hTL.png' alt='' width='220' /></h1>

[![Gem version](https://img.shields.io/gem/v/rails-creds.svg)](https://rubygems.org/gems/rails-creds)

`Creds` is …

1. a shortcut for the dreadfully long `Rails.application.credentials` and …
2. bringing environment scoping back (from when it was called _secrets_)

## Usage

Given encrypted credentials looking like:

```yaml
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
```

You can access those super secret things like:

```ruby
# development, test:
Creds.secret # => 123

# production
Creds.secret # => 456

# staging
Creds.secret # => raises Creds::MissingEnvError

# any
Creds.missing_secret # => raises Creds::MissingKeyError
```

## Installation

```sh
$ bundle add rails-creds
$ bundle install
```

## License

MIT

