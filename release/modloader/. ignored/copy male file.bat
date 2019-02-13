set filename=%~n0
set file=%filename:~0,-1%

:: C:\Progra~1\7-Zip\7z.exe x "%file%.zip"
copy "models\%file%.dff" ..\asdf\male.dff
copy "models\%file%.txd" ..\asdf\male.txd

:: pause >nul