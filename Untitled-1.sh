docker run -it \
   -e POSTGRES_USER="root"\
   -e POSTGRES_PASSWORD="root" \
   -e POSTGRES_DB="ny_taxi" \
   -v C:/Users/chief/Documents/Python/2022/nyc_taxi_data/nyc_taxi_pg_data:/var/lib/postgresql/data \
   -p 5432:5432 \
   --network=pg-network \
   --name pg-database \
postgres:13

pgcli -h localhost -p 5432 -u root -d ny_taxi

docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    --network=pg-network \
   --name pgadmin \
    dpage/pgadmin4

URL="https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2022-01.parquet"

python upload_data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db_name=ny_taxi \
    --table_name=yellow_taxi_data \
    --url=${URL}


docker build -t taxi_upload:v001 .

docker run -it \
    --network=pg-network \
    taxi_upload:v001 \
        --user=root \
        --password=root \
        --host=pg-database \
        --port=5432 \
        --db_name=ny_taxi \
        --table_name=yellow_taxi_data \
        --url=${URL}