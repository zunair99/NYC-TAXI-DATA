import pandas as pd
import pyarrow #using pyarrow to smoothen df creation from parquet file
from sqlalchemy import create_engine #importing to connect to Postgres
import argparse
import os


def main(params):

    user = params.user
    password = params.password
    host = params.host
    port = params.port
    db_name = params.db_name
    table_name = params.table_name
    url = params.url
    file_name = 'data.parquet'
    #download parquet
    os.system(f"wget {url} -O {file_name}")

    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db_name}')

    df = pd.read_parquet(f'{file_name}', engine='pyarrow')

    df.to_sql(name=table_name, con=engine,if_exists='replace',chunksize=150000)
    

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Ingest Parquet Data to Postgres')

    #user, password, host, port, database name, table name, url of parquet

    parser.add_argument('--user', help='user name for Postgres')
    parser.add_argument('--password', help='password for Postgres')
    parser.add_argument('--host', help='host for Postgres')
    parser.add_argument('--port', help='port for Postgres')
    parser.add_argument('--db_name', help='database name for Postgres')
    parser.add_argument('--table_name', help='table name for Postgres')
    parser.add_argument('--url', help='url of the Parquet file for Postgres')

    args = parser.parse_args()

    main(args)
