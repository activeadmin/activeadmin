# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_2.3.5_session',
  :secret      => 'e71a145e21b433a2588399bdff845db3162d2c0b0eb6521d570bec0ce67b42f26427fbc996803000b9c6918878c09a837eabc40585e902839a9d44198fa99b52'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
