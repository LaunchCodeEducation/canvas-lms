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

1) go to some host that can talk to the education database.
```
ssh ubuntu@$CANVAS_JOBS_IP
```
2) grab the latest canvas backup. The quick way should be something
like
```
aws s3 cp s3://launchcode-backup-staging/canvas/canvas_staging_backup_2017-10-18_20-28-51.sql .
```
prod notes: the bucket name is `launchcode-backup` not `launchcode-backup-staging`, and the filename is slightly different.

3) RECCOMENDED: back up the corrupted db.
```
~/backup-canvasdb.sh
```
4) OPTIONAL: you've gotta drop and recreate the DB
```
/usr/lib/postgresql/9.5/bin/dropdb  -U education  --host=education-db-staging-james.c0e6mwcrdvhd.us-east-1.rds.amazonaws.com canvas_staging
/usr/lib/postgresql/9.5/bin/createdb  -U education  --host=education-db-staging-james.c0e6mwcrdvhd.us-east-1.rds.amazonaws.com canvas_staging
```
If it gives you lip about open connections, you've got to go temporarily halt canvas (`/etc/init.d/canvas_init stop`) and apache (`/etc/init.d/apache2 stop` on $CANVAS_IP).

5) restore the database
```
/usr/lib/postgresql/9.5/bin/psql  -U education -d canvas_staging --host=education-db-staging-james.c0e6mwcrdvhd.us-east-1.rds.amazonaws.com -f ~/canvas_staging_backup_2017-10-18_01-13-01.sql
```
again, all this is staging-specific, you'll have to sub in prod values. I grabbed most of them out of `/var/canvas/config/database.yml`.

6) restore `canvas_init` and `apache2` from step 4, if you need to. 

7) Give the web server a few minutes to recover

8) Go back to sleep
