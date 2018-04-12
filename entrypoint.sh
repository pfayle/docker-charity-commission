#!/bin/bash -e
repo_address=${repo_address:-'https://github.com/pfayle/charity-commission-extract'}
datasource=${datasource:-'http://apps.charitycommission.gov.uk/data/201804/extract1/RegPlusExtract_April_2018.zip'}
host=${host:-'db'}
port=${port:-'3306'}
user=${user:-'root'}
database=${database:-'charity'}
mysql_opts="-u ${user} -h ${host} -P ${port}"

git clone "${repo_address}" repo_clone
cd repo_clone
wget -O datafile.zip "${datasource}"
python3 import.py datafile.zip
mysqladmin $mysql_opts drop -f "${database}" || true
mysqladmin $mysql_opts create "${database}"
# Clear SQL_MODE to allow zero-dates
mysql $mysql_opts -e 'SET GLOBAL SQL_MODE='\'\'
mysql $mysql_opts "${database}" < table-definition.sql
for file in extract_*.csv; do
  mysql $mysql_opts "${database}" -e "
    LOAD DATA LOCAL INFILE '$file'
    INTO TABLE \`${file%%.csv}\`
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '\"'
    IGNORE 1 LINES
    ;

    SHOW WARNINGS;
  "
done
