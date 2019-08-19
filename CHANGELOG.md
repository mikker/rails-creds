# 0.2.3 (2019-08-19)

Fixed:

  - Require strip_heredoc extension before use

# 0.2.1

Changed:

  - Credentials are now memoized after successful read.

# 0.2.0

Changed:

  - Creds will now warn about missing credentials when the encrypted file isn't
    found. It will afterwards be a Null Object and return `nil` on every key.
  - When encrypted credentials are found but the master key file AND env
    variable is missing, Creds will return a special error with explanation.

# 0.1.0

Initial version
