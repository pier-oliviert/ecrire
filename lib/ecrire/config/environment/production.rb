Ecrire::Application.configure do
  config.assets.js_compressor = :uglifier
  config.assets.debug = false
  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'

  config.serve_static_files = false

  config.log_level = :info

end
