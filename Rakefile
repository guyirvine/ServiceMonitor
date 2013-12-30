require 'rake/testtask'
ENV["TESTING"]="true"

Rake::TestTask.new do |t|
  t.libs << 'test'
end

Rake::TestTask.new(name=:e2e) do |e|
  e.libs << 'e2e'
end


task :e2e2 do
	puts "Bob"
end


desc "Run tests"
task :default => :test
