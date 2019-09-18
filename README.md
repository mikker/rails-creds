<h1><img src='https://s3.brnbw.com/logo-2x-SiurkO6hTL.png' alt='' width='220' /></h1>

[![Build Status](https://travis-ci.org/mikker/rails-creds.svg?branch=master)](https://travis-ci.org/mikker/rails-creds) [![Gem version](https://img.shields.io/gem/v/rails-creds.svg)](https://rubygems.org/gems/rails-creds)

`Creds` is both **a)** a shortcut for the dreadfully long `Rails.application.credentials` and **b)** bringing environment scoping back (from when it was called _secrets_).

## Usage

Given encrypted credentials looking like:

```yaml
---
super_secret: 'shared between environments'

production:
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



