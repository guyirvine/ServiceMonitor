dir :name=>"land", :path=>"/tmp/path", :min=>1, :max=>3, :cron=>"* * * * *", :block=>proc { |params|Dir.glob( "#{params[:path]}/*" ).length }
