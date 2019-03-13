@echo off
del /s *~
del /s *.or
del /s *.bak
del /s *.exe
del /s *.bin
del /s *.ppu
del /s *.o
del /s *.compiled

rmdir /s /q helloworld\lib
rmdir /s /q helloworld-with-theme\lib
rmdir /s /q others\json\lib
rmdir /s /q others\mail\lib
rmdir /s /q others\recaptcha\lib
rmdir /s /q others\redis\lib


timeout /t 3
