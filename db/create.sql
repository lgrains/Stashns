drop database if exists qstash_dev;
create database qstash_dev;
drop database if exists qstash_test;
create database qstash_test;
drop database if exists qstash_prod;
create database qstash_prod;
GRANT ALL PRIVILEGES ON  qstash_dev.* to 'e168'@'localhost'
	IDENTIFIED BY 'e168' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON  qstash_test.* to 'e168'@'localhost'
	IDENTIFIED BY 'e168' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON  qstash_prod.* to 'e168'@'localhost'
	IDENTIFIED BY 'e168' WITH GRANT OPTION;
