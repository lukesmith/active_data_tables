Gem::Specification.new do |s|
  s.name        = 'active_data_tables'
  s.version     = '0.0.4'
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
  s.add_development_dependency 'rspec', '~> 3.3'
  s.add_development_dependency 'activerecord', '~> 4.2', '>= 4.2.4'
  s.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.11'
  s.add_development_dependency 'rake', '~> 10.4', '>= 10.4.2'
  s.add_development_dependency 'coveralls', '~> 0.8.3'
  s.add_development_dependency 'rubocop', '~> 0.34.2'
end
