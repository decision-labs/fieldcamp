POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-1.5
createdb -E UTF8 -T template0 template_postgis
createlang -d template_postgis plpgsql
psql -d template_postgis -f $POSTGIS_SQL_PATH/postgis.sql
psql -d template_postgis -f $POSTGIS_SQL_PATH/spatial_ref_sys.sql
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
psql -d template_postgis -c "VACUUM FULL;"
psql -d template_postgis -c "VACUUM FREEZE;"
psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"
psql -d postgres -c "UPDATE pg_database SET datallowconn='true' WHERE datname='template_postgis';"
