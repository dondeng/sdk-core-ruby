# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = "mastercard-core-sdk"
  gem.authors       = ["MasterCard"]
  gem.email         = ["naman.aggarwal@mastercard.com"]
  gem.summary       = %q{MasterCard core SDK}
  gem.description   = %q{MasterCard core SDK}
  gem.homepage      = "https://developer.mastercard.com"
  gem.version       = "1.0.0"
  gem.license       = "MasterCard SDK License"

  gem.files         = Dir["{bin,spec,lib}/**/*"]+ Dir["data/*"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
