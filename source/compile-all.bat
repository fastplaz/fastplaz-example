@echo off

cd helloworld
call compile.bat

cd ..\helloworld-with-theme
call compile.bat

cd ..\others\json
call compile.bat

cd ..\mail
call compile.bat

cd ..\recaptcha
call compile.bat

cd ..\redis
call compile.bat

cd ..\..\session\session
call compile.bat

cd ..\..\db\contacts_grid
call compile.bat

cd ..\simple_contacts
call compile.bat


cd ..\..
