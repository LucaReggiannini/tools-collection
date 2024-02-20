@echo off
set filepath=%1
For /f "delims=" %%F in ("%filepath%") do (
    set filename=%%~nxF
)
echo %filename%
certutil -hashfile %filepath% md5    | findstr /r "^[a-zA-Z0-9]*$"
certutil -hashfile %filepath% sha1   | findstr /r "^[a-zA-Z0-9]*$"
certutil -hashfile %filepath% sha256 | findstr /r "^[a-zA-Z0-9]*$"
