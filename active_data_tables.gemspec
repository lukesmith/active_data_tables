Gem::Specification.new do |s|
  s.name        = 'active_data_tables'
  s.version     = '0.0.1'
  s.date        = '2015-10-27'
  s.summary     = "Server side processing for datatables.net"
  s.description = "Server side processing for datatables.net"
  s.authors     = ["Luke Smith"]
  s.email       = 'me@lukesmith.net'
  s.files       = ["lib/active_data_tables.rb", "lib/active_data_tables/active_data_tables.rb"]
  s.homepage    =
    'http://rubygems.org/gems/active_data_tables'
  s.license       = 'MIT'
  s.add_runtime_dependency 'jbuilder', '~> 2.3'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'activerecord'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
end
