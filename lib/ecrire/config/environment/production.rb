Ecrire::Application.configure do
  config.serve_static_assets = true
  config.assets.debug = false

  # Generate digests for assets URLs.
  config.assets.digest = true

  # Version of your assets, change this if you want to expire all your assets.
  config.assets.version = '1.0'

end
