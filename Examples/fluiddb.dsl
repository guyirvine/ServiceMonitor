fluiddb :name=>"bcs", :uri=>"pgsql://girvine:coffee11@localhost/bcs", :sql=>"SELECT now()::DATE - MAX(recordedat)::DATE FROM bcs_tbl", :min=>1, :max=>150, :cron=>"* * * * *"

