POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-1.5
psql -d postgres -c "UPDATE pg_database SET datistemplate='false' WHERE datname='template_postgis';"
psql -d postgres -c "UPDATE pg_database SET datallowconn='true' WHERE datname='template_postgis';"

dropdb template_postgis
