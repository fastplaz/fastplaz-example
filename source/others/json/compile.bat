@echo off

cd C:\lazarus-1.2.6\fpc\2.6.4\bin\i386-win32
mkdir lib
c:fpc json.lpr @extra.cfg

timeout /t 2
