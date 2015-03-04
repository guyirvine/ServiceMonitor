Gem::Specification.new do |s|
  s.name        = 'servicemonitor'
  s.version     = '0.1.3'
  s.date        = '2014-08-14'
  s.summary     = "ServiceMonitor"
  s.description = "The fastest way to reliably monitor your system."
  s.authors     = ["Guy Irvine"]
  s.email       = 'guy@guyirvine.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.homepage    = 'http://rubygems.org/gems/servicemonitor'
  s.add_dependency( "parse-cron" )
  s.add_dependency( "beanstalk-client" )
  s.add_dependency( "fluiddb" )
  s.add_dependency( "rest-client" )
  s.executables << 'servicemonitor'
end
