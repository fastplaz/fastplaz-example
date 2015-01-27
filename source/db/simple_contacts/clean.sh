rm -rf *.or
rm -rf *.bak
rm -rf *.exe
rm -rf *.ppu
rm -rf *.o
rm -rf *.compiled
rm -rf lib/*
rm -rf backup/
rm -rf src/backup/
rm -rf src/app/wordpress/backup/
rm -rf src/app/wordpress/model/backup/
rm -rf src/app/wordpress/plugins/backup/

find ./ -type f -name *.~ -delete
find ./ -type f -name *.o -delete
find ./ -type f -name *.oe -delete
find ./ -type f -name *.rst -delete
find ./ -type f -name *.bak -delete
find ./ -type f -name *.ppu -delete
find ./ -type f -name *.compiled -delete
find ./ -type d -name backup -delete

rm -rf lib
mkdir lib

