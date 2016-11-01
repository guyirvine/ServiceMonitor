Gem::Specification.new do |s|
  s.name        = 'servicemonitor'
  s.version     = '0.2.7'
  s.license     = 'LGPL-3.0'
  s.date        = '2016-11-02'
  s.summary     = 'ServiceMonitor'
  s.description = 'The fastest way to reliably monitor your system.'
  s.authors     = ['Guy Irvine']
  s.email       = 'guy@guyirvine.com'
  s.files       = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.homepage    = 'https://github.com/guyirvine/ServiceMonitor'
  s.add_dependency('parse-cron')
  s.executables << 'servicemonitor'
end
