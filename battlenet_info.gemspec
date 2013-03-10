Gem::Specification.new do |s|
  s.name        = 'battlenet_info'
  s.version     = '0.2.0'
  s.date        = '2013-03-10'
  s.summary     = "Battle.Net info"
  s.description = "A simple Battle.Net info parser gem"
  s.authors     = ["Vitaly Tatarintsev"]
  s.email       = "Kalastiuz@gmail.com"
  s.files       = ["lib/battlenet_info.rb", "lib/exceptions.rb"]
  s.homepage    = "https://github.com/ck3g/battlenet_info"
  s.add_dependency "nokogiri", "~> 1.5.6"
end
