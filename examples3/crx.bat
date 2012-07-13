@echo off
if "%~x1" == ".random" goto :RANDOM
cr <"%1" | rpb "%1"
ren "%1" "%1.random"
goto :EOF
:RANDOM
cr u <"%1" | rpb "%1"
ren "%1" "%~n1"
