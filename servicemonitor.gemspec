Gem::Specification.new do |s|
  s.name        = 'servicemonitor'
  s.version     = '0.0.18'
  s.date        = '2013-12-30'
  s.summary     = "ServiceMonitor"
  s.description = "The fastest way to reliably monitor your system."
  s.authors     = ["Guy Irvine"]
  s.email       = 'guy@guyirvine.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.homepage    = 'http://rubygems.org/gems/servicemonitor'
#s.add_dependency( "parse-cron" )
#s.add_dependency( "beanstalk-client" )
#s.add_dependency( "fluiddb" )
  s.executables << 'servicemonitor'
end

