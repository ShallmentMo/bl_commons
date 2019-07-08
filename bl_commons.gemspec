$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'bl_commons/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'bl_commons'
  spec.version     = BlCommons::VERSION
  spec.authors     = ['ShallmentMo']
  spec.email       = ['ShallmentMo@gmail.com']
  spec.summary     = 'BL Commons'
  spec.description = 'BL Commons'
  spec.license     = 'MIT'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'httparty'
  spec.add_dependency 'persistent_httparty'
  spec.add_dependency 'rails', '>= 5.1'
end
