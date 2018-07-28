# docker-charity-commission
Docker container to load UK Charity Commission data into a MySQL database

## Example setup

```
docker build -t charity-commission-importer .

docker network create charity-net

docker run -d --name db \
  -e MYSQL_ALLOW_EMPTY_PASSWORD=true \
  -e MYSQL_ROOT_HOST=% \
  -e MYSQL_ROOT_PASSWORD='' \
  --net=charity-net \
  mysql/mysql-server:5.7

docker run --rm --net=charity-net \
  -e datasource='http://apps.charitycommission.gov.uk/data/201804/extract1/RegPlusExtract_April_2018.zip' \
  -e database=target_database \
  charity-commission-importer 
```

There are still many warnings expected with the default options.  These are largely due to extra whitespace being truncated, and empty strings used for 0 throughout the dataset.

