fluiddb "bcs", "pgsql://girvine:coffee11@localhost/bcs", "SELECT now()::DATE - MAX(recordedat)::DATE FROM bcs_tbl", :min=>1, :max=>150, :cron=>"* * * * *"

