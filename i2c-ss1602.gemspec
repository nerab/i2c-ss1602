# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'i2c/drivers/ss1602/version'

Gem::Specification.new do |spec|
  spec.name          = 'i2c-ss1602'
  spec.version       = I2C::Drivers::SS1602::VERSION
  spec.authors       = ['Nicholas E. Rabenau']
  spec.email         = ['nerab@gmx.at']
  spec.description   = %q{Ruby driver for the SainSmart 1602 LCD display with I2C adapter}
  spec.summary       = %q{Driver for the SainSmart 1602 LCD display}
  spec.homepage      = 'https://github.com/nerab/i2c-ss1602'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'i2c'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-minitest'
  spec.add_development_dependency 'fakefs'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pry-byebug'
end
