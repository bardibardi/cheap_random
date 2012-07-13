@echo off
cr ms <"%1" >NUL
del the.seed
ren new.seed the.seed
