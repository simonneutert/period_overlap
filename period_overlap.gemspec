# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'period_overlap/version'

Gem::Specification.new do |spec|
  spec.name          = "period_overlap"
  spec.version       = PeriodOverlap::VERSION
  spec.authors       = ["Simon Neutert"]
  spec.email         = ["simon.neutert@gmail.com"]

  spec.summary       = %q{This gem checks if date periods are overlapping.}
  spec.description   = %q{This gem checks if date periods are overlapping.}
  spec.homepage      = "https://github.com/simonneutert/period_overlap"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://github.com/simonneutert/period_overlap'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "rails", ">= 4.0"
end
