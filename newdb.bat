mysql -h localhost -u root -p --no-beep < db\create.sql
call rake db:migrate
call rake db:fixtures:load