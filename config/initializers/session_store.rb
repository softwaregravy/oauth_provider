# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_oauth_provider_session',
  :secret      => '62e28412f7dc74d4bd0217b00cfb83354a22cf8766c20639c51757283886506fa4a0b0eb7f8172480c3b69291cd0e222ac687064bc15c3af4589cd5f4d1d1e5f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
