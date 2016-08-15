require 'rake/testtask'
ENV['TESTING'] = 'true'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

Rake::TestTask.new(name=:e2e) do |e|
  e.libs << 'e2e'
end

task :build do
  `gem build servicemonitor.gemspec`
end

task :install do
  Rake::Task['build'].invoke
  cmd = "sudo gem install ./#{Dir.glob('servicemonitor*.gem').sort.pop}"
  p "cmd: #{cmd}"
  `#{cmd}`
  p "gem push ./#{Dir.glob('servicemonitor*.gem').sort.pop}"
end

desc 'Run tests'
task :default => :test
