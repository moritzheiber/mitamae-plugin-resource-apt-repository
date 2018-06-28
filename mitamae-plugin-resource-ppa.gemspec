# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "mitamae-plugin-resource-ppa"
  spec.version       = "0.0.1"
  spec.authors       = ["Moritz Heiber"]
  spec.email         = ["github@heiber.im"]

  spec.summary       = %q{mitamae plugin resource ppa}
  spec.description   = %q{mitamae plugin resource ppa}
  spec.license       = "MIT"
  spec.homepage      = "https://github.com/moritzheiber/mitamae-plugin-resource-ppa"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mitamae", "~> 1.2"
  spec.add_development_dependency "bundler", "~> 1.10"
end
