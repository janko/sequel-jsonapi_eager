Gem::Specification.new do |spec|
  spec.name         = "sequel-jsonapi_eager"
  spec.version      = "0.0.2"
  spec.authors      = ["Janko Marohnić"]
  spec.email        = ["janko.marohnic@gmail.com"]

  spec.summary      = "A Sequel plugin for eager loading associations in JSON-API specification."
  spec.description  = spec.description
  spec.homepage     = "https://github.com/janko-m/sequel-jsonapi_eager"
  spec.license      = "MIT"

  spec.files        = Dir["README.md", "LICENSE.txt", "lib/**/*"]
  spec.require_path = "lib"

  spec.add_dependency "sequel", ">= 4"

  spec.add_development_dependency "minitest", "~> 5.6"
  spec.add_development_dependency "minitest-hooks", "~> 1.0"
  spec.add_development_dependency "sqlite3"
end
