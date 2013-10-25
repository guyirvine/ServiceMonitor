Gem::Specification.new do |s|
  s.name        = 'servicemonitor'
  s.version     = '0.0.3'
  s.date        = '2013-10-25'
  s.summary     = "ServiceMonitor"
  s.description = "Monitor various parts of the system"
  s.authors     = ["Guy Irvine"]
  s.email       = 'guy@guyirvine.com'
  s.files       = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.homepage    = 'http://rubygems.org/gems/servicemonitor'
  s.executables << 'servicemonitor'
end

#s.add_dependency( "parse-cron" )
#s.add_dependency( "beanstalk-client" )
#s.add_dependency( "fluiddb" )

