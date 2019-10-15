Rails.application.config.assets.precompile += %w(manifest.js)

Rails.application.config.assets.precompile += %w(
  application.js
  application.css
  print.css
)

Rails.application.config.assets.version = "1.0"
