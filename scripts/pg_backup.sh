#!/bin/bash

### Location to place backups.
backup_dir="/backup"
nightly_dir="/backup/latest"
### String to append to the name of the backup files
backup_date=`date +%d-%m-%Y_%H-%m-%S`
### Numbers of days you want to keep copie of your databases
number_of_days=15
# databases=`psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`
databases=`PGPASSWORD=password psql -l -t -h localhost -p 5432 -U postgres | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`
for i in $databases; do  if [ "$i" != "postgres" ] && [ "$i" != "template0" ] && [ "$i" != "template1" ] && [ "$i" != "template_postgis" ]; then
    echo "Dumping ${i} to ${backup_dir}/${i}_${backup_date}.sql"
    # pg_dump ${i} > ${backup_dir}/${backup_date}_${i}.sql
    PGPASSWORD=password pg_dump -h localhost -p 5432 -U postgres ${i} > ${backup_dir}/${backup_date}_${i}.sql
    tar cvfz ${backup_dir}/${backup_date}_${i}.sql.tar.gz --remove-files ${backup_dir}/${backup_date}_${i}.sql
    ln -fs ${backup_dir}/${backup_date}_${i}.sql.tar.gz ${nightly_dir}/nightly-${i}.sql.tar.gz
  fi
done
PGPASSWORD=password pg_dumpall -h localhost -p 5432 -U postgres --clean --file=${backup_dir}/${backup_date}_full.dump
gzip ${backup_dir}/${backup_date}_full.dump
find ${backup_dir} -type f -prune -mtime +${number_of_days} -exec rm -f {} \;

### To restore use: pg_restore -h localhost -p 5432 -U postgres -d old_db -v /backup/backup_full.dump

### Single db restore: 
# createdb -h 192.168.1.70 -p 42007 -U crawler -W cian_sandbox
# psql -h 192.168.1.70 -p 42007 -U crawler -d cian_sandbox -f cian_sandbox.sql
###
 
exit 0
