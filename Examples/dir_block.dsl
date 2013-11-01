p1 = proc do |params|
 puts "A superfluous output line, to show multiple lines"
 Dir.glob( "#{params[:path]}/*" ).length
end

dir :name=>"land", :path=>"/tmp/path", :min=>1, :max=>3, :cron=>"* * * * *", :block=>p1
