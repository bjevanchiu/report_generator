# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'report_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "report_generator"
  spec.version       = ReportGenerator::VERSION
  spec.authors       = ["Evan Chiu"]
  spec.email         = ["bjevanchiu@gmail.com"]
  spec.description   = %q{A simple Ruby Internal DSL for creating Count Report which save data from MySQL to MySQL.}
  spec.summary       = %q{A simple Ruby Internal DSL for creating Count Report which save data from MySQL to MySQL.}
  spec.homepage      = "https://github.com/bjevanchiu/report_generator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
