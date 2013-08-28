Gem::Specification.new do |s|
  s.name        = 'things'
  s.version     = '0.0.0'
  s.date        = '2013-08-28'
  s.summary     = "Connect buttons etc to your Rapsberry Pi"
  s.description = "Connect buttons etc to your Rapsberry Pi"
  s.authors     = ["Andrew Nicolaou"]
  s.email       = 'andrew.nicolaou@bbc.co.uk'
  s.files       = ["lib/things.rb"]
  s.homepage    =
    ''
  s.license       = 'Apache'
  s.add_runtime_dependency "wiringpi", ">= 1.1.0"
end
