@echo off
if "%~x1" == ".random" goto :RANDOM
cr s <"%1" | rpb "%1"
ren "%1" "%1.random"
goto :EOF
:RANDOM
cr us <"%1" | rpb "%1"
ren "%1" "%~n1"
