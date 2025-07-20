## Installation

Follow the instructions at https://www.postgresql.org/download/.

## Work as the super user

### Connect to postgresql server

Connect to PostgreSQL as the super user to start postgres console. 
```sh
sudo -u postgres psql
```
After the connection is establish, the postgresql console starts with `postgres=#`. From here all commands are standard SQL command or PostgreSQL specific command.

Postgresql-specific commands (different from Sqlite and duckdb):
```sql
\du -- list all users
\l  -- list all databases
\dt -- list all tables in current databases
\d table_1 -- show schema of table_1
\q -- quit the console
```

Create a new user from the console, which start with postgres=#
```sql
postgres=# CREATE USER testuser WITH PASSWORD 'testpassword';
```


### Create a database and population tables from a sql file

File `postgresql_sample.aql` contains SQL command to create a new database, create new tables for the database, and populate the tables with a few rows. 
```sh
# the database is owned by super user postgres
sudo -u postgres psql -f postgresql_sample.sql
```

### SQL query with a database

Connect to database postgresql_sample
```sh
sudo -u postgres psql -d postgresql_sample
```

List tables
```sql
postgres_sample=# \dt
```

Table schema
```sql
postgres_sample=# \d customers
```

Query database
```sql
postgres_sample=# SELECT * FROM customers;
```

## Add a new user to the database

Create a new user sample_user and grand it access to database postgres_sample.
```sh
sudo -u postgres psql -c "CREATE USER sample_user WITH PASSWORD 'securepassword123'; GRANT CONNECT ON DATABASE postgresql_sample TO sample_user; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sample_user; GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sample_user;"
```

Connect to the database from user `sample_user`.  The local host of the PostgreSQL server in local computer is 127.0.0.1 and default port is 5432.
```sh
psql -U sample_user -d postgresql_sample -h 127.0.0.1 -p 5432
```

Type in the password for sample_user to enter the postgresql console, which is `postgresql_sample=>` and then run SQL commands.


## Remote connection

Question:
```text
I have a postgresql server and database postgresql_sample owned by postgres in desktop computer with IP 192.168.1.20, which was created under linux user gl. How do I use this database from my laptop, which has ssh access to the desktop and installed with postgresql? Both are using Debian linux.
```

Step 1: on the desktop computer, configure PostgreSQL to allow connections
```sh
sudo -u postgres psql -c "ALTER SYSTEM SET listen_addresses = 'localhost,192.168.1.20';"
```

Step 2: on the desktop computer, edit `pg_hba.conf` at `/etc/postgresql/17/main/` to add line
```
host postgresql_sample all [laptop-ip]/32 md5
```
This line specifically allows connection to database postgresql_sample from laptop computer with ip of laptop-ip. It is very specific.

Step 3: On the desktop computer, restart Postgresql
```sh
sudo systemctl restart postgresql
```

Step 4: On the laptop, run (user in desktop does not matter)
```sh
psql -h 192.168.1.20 -U sample_user -d postgresql_sample
```

test with query `SELECT * FROM orders`. If it has permission issue, rerun the following command on the desktop to grand permission,
```sh
sudo -u postgres psql -d postgresql_sample -c "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sample_user; GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sample_user;"
```