
call "E:\Program Files\IntelSWTools\compilers_and_libraries_2017.4.210\windows\bin\ipsxe-comp-vars.bat" ia32 vs2015

SET COMPCODE=INW
SET CROPENMP=TRUE
set WXNUM=31
set WXVC=vc140
set WXMINOR=0
SET WXWIN=e:\wx31
SET WXLIB=%WXWIN%\lib\%WXVC%_dll
set PATH=%WXLIB%;%PATH%

SETLOCAL ENABLEEXTENSIONS
setlocal EnableExtensions EnableDelayedExpansion
