set file=%~n0

:: C:\Progra~1\7-Zip\7z.exe x "%file%.zip"
copy "models\%file%.dff" ..\asdf\female.dff
copy "models\%file%.txd" ..\asdf\female.txd

:: pause >nul