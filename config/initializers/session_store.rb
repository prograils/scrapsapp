# Be sure to restart your server when you modify this file.

# ScrapsApp::Application.config.session_store :cookie_store, key: '_scrapps_app_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
#ScrapsApp::Application.config.session_store :active_record_store#, :domain => Rails.env.developmen? ? '.scraps-app.dev' : '.scrapsapp.com'
ScrapsApp::Application.config.session_store :cookie_store, key: '_scraps_app_session', domain: :all
