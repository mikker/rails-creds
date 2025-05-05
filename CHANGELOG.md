# Changelog

## 0.5.0

**NB:** Probably breaking change.

We now rely on YAML for merging credentials. See `bin/rails creds:example` for an example configuration.

- New: Missing keys always raise.
- Added example task.

## 0.4.0 (2023-07-08)

### Added

- Return `nil` and don't read credentials nor complain when SECRET_KEY_BASE_DUMMY=1

## 0.3.0 (2019-09-19)

### Breaking changes

- _(Possibly breaking)_ Scoped creds are now merged with top level creds ([#23](https://github.com/mikker/rails-creds/pull/23))

## 0.2.3 (2019-08-19)

### Fixed:

- Require strip_heredoc extension before use

## 0.2.1

## Changed:

- Credentials are now memoized after successful read.

## 0.2.0

### Changed:

- Creds will now warn about missing credentials when the encrypted file isn't
  found. It will afterwards be a Null Object and return `nil` on every key.
- When encrypted credentials are found but the master key file AND env
  variable is missing, Creds will return a special error with explanation.

## 0.1.0

Initial version
