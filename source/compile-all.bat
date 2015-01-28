compile@echo off

cd helloworld
call compile

cd ..\helloworld-with-theme
call compile

cd ..\others\json
call compile

cd ..\mail
call compile

cd ..\recaptcha
call compile

cd ..\redis
call compile

cd ..\..\session\session
call compile

cd ..\..\db\contacts_grid
call compile

cd ..\simple_contacts
call compile


cd ..\..
