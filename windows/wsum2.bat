@echo off
set filepath=%1
for %%F in ("%filepath%") do (
    echo %%F
    echo %%~nxF
    certutil -hashfile "%%F" md5    | findstr /r "^[a-zA-Z0-9]*$"
    certutil -hashfile "%%F" sha1   | findstr /r "^[a-zA-Z0-9]*$"
    certutil -hashfile "%%F" sha256 | findstr /r "^[a-zA-Z0-9]*$"
)
