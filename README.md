# LaunchCode Canvas LMS
======

LaunchCode forked Canvas to deploy it for our educational programs.

======

## Emergency Database Restore

It's 4am. You've been awakened by a a call from Lin. Canvas is down
and classes start tomorrow. Scruffling the sleep from your eyes, you
fire up your terminal and hack into bastion. It's your worst fears:
the database is has been replaced by images of LoLcats. It's time to
restore the database from backup. you vaguely recall we have
backups. HOW DO YOU DO IT?

Note: this guide is for staging. You'll need to make some substitutions for production, on dbname and so forth

### go to some host that can talk to the education database.
```
ssh ubuntu@$CANVAS_JOBS_IP
```
### grab the latest canvas backup. The quick way should be something
like
```
aws s3 cp s3://launchcode-backup-staging/canvas/canvas_staging_backup_2017-10-18_20-28-51.sql .
```
prod notes: the bucket name is `launchcode-backup` not `launchcode-backup-staging`, and the filename is slightly different.

### RECCOMENDED: back up the corrupted db.
```
~/backup-canvasdb.sh
```
### OPTIONAL: you've gotta drop and recreate the DB
```
/usr/lib/postgresql/9.5/bin/dropdb  -U education  --host=education-db-staging-james.c0e6mwcrdvhd.us-east-1.rds.amazonaws.com canvas_staging
/usr/lib/postgresql/9.5/bin/createdb  -U education  --host=education-db-staging-james.c0e6mwcrdvhd.us-east-1.rds.amazonaws.com canvas_staging
```
If it gives you lip about open connections, you've got to go temporarily halt canvas (`/etc/init.d/canvas_init stop`) and apache (`/etc/init.d/apache2 stop` on $CANVAS_IP).

### restore the database
```
gunzip ~/canvas_staging_backup_2017-10-18_01-13-01.sql.gz
/usr/lib/postgresql/9.5/bin/psql  -U education -d canvas_staging --host=education-db-staging-james.c0e6mwcrdvhd.us-east-1.rds.amazonaws.com -f ~/canvas_staging_backup_2017-10-18_01-13-01.sql
```

again, all this is staging-specific, you'll have to sub in prod values. I grabbed most of them out of `/var/canvas/config/database.yml`.

### restore `canvas_init` and `apache2` from step 4, if you need to. 

### Give the web server a few minutes to recover

### Go back to sleep

## Notes on Moving prod db to staging db

I (Dave) tried this and couldn't get it going. I had to give up to pursue other priorities. When I quit, it looked like the problem had something to do with running the rake task:
```
bundle exec rake db:reset_encryption_key_hash
```
Looks like I was reading this post: https://groups.google.com/forum/#!topic/canvas-lms-users/EXSR9f6H-NY

When I ran the rake task, it errored complaining about a nil. Maybe it took a parameter that I didn't specify?
