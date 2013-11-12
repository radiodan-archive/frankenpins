Gem::Specification.new do |s|
  s.name        = 'frankenpins'
  s.version     = '0.2.0'
  s.date        = '2013-08-28'
  s.summary     = "Connect buttons etc to your Rapsberry Pi"
  s.description = "Connect buttons etc to your Rapsberry Pi"
  s.authors     = ["Andrew Nicolaou"]
  s.email       = 'andrew.nicolaou@bbc.co.uk'
  s.files       = `git ls-files`.split($/)
  s.homepage    = 'https://github.com/radiodan/frankenpins'
  s.license       = 'Apache 2'

  s.add_runtime_dependency "wiringpi2"   , "~> 2.0.0"
  s.add_runtime_dependency "unobservable", "~> 0.11.0"
end
