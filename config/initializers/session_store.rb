# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_757studio_session',
  :secret      => '5af9e1c7c19eb2c96164bff2ec35be7b3b795a51d1848a762cee54eba92c3369486afe78638a3983ec620ebb87d7abf7917dc703ecfaea731a8ec8d4ce426617'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
