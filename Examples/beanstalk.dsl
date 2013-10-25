#beanstalk "audit", "audit", :max=>1, :cron=>"* * * * *"
beanstalk :name=>"error", :queue=>"error", :max=>1, :cron=>"* * * * *"
