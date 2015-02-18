Ecrire::Application.configure do
  config.assets.js_compressor = :uglifier
  config.assets.debug = false
  config.assets.compile = true
  config.assets.digest = true
  config.assets.version = '1.0'

  config.serve_static_files = false

  config.log_level = :info

end
