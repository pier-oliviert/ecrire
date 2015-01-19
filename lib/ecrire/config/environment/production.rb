Ecrire::Application.configure do
  config.assets.js_compressor = :uglifier
  config.assets.debug = false
  config.serve_static_files = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'
  config.log_level = :info

end
