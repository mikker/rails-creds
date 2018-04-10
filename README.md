<h1><img src='https://s3.brnbw.com/logo-2x-SiurkO6hTL.png' alt='' width='220' /></h1>

`Creds` is both **a)** a shortcut for the dreadfully long `Rails.application.credentials` and **b)** bringing environment scoping back (from when it was called _secrets_).

## Usage

Given encrypted credentials looking like:

```yaml
---
default: &default
  super_secret: 'shared between environments'

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
  super_secret: 'you can override defaults for individual environments'
```

You can access those super secret things like:

```ruby
Creds.super_secret # => "shared between environments"
  # or, of course, the other when in production
```

## Installation

```ruby
gem 'rails-creds'
```

That's it.

## License

MIT



