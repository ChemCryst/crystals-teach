@goto %COMPCODE%
@
:WXS
@if "%CRDEBUG%" == "TRUE"     set LIBS=/LIBPATH:c:\wxWidgets-2.8.11\lib\vc_lib  wxbase28d.lib wxmsw28d_core.lib wxzlibd.lib wxjpegd.lib wxtiffd.lib wxpngd.lib wxmsw28d_gl.lib wxmsw28d_aui.lib user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@if not "%CRDEBUG%" == "TRUE" set LIBS=/LIBPATH:c:\wxWidgets-2.8.11\lib\vc_lib  wxbase28.lib  wxmsw28_core.lib  wxzlib.lib  wxjpeg.lib  wxtiff.lib  wxpng.lib  wxmsw28_gl.lib  wxmsw28_aui.lib  user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@set LIBS=%LIBS% rc.o
@rem @set LIBS=/LIBPATH:c:\wxWidgets-2.8.11\lib\vc_lib msvcrtd.lib libcmtd.lib wxbase28d.lib wxmsw28d_core.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib  user32.lib ole32.lib /NODEFAULTLIB:MSVCRT.lib
@set CDEF=/D"__WXMSW__" /D"_DIGITALF77_"
@set FDEF=/define:_%COMPCODE%_ /define:_DIGITALF77_
goto ALLDVF
@
:INW
@if "%CRDEBUG%" == "TRUE"     set LIBS=/LIBPATH:c:\wxWidgets2.9\lib\vc_dll\ /LIBPATH:d:\RDKit_2011_09_1\build\lib\Debug wxbase29ud.lib GraphMol.lib RDGeneral.lib RDGeometryLib.lib SmilesParse.lib  wxmsw29ud_core.lib wxmsw29ud_aui.lib wxzlibd.lib  wxjpegd.lib  wxtiffd.lib  wxpngd.lib  wxmsw29ud_gl.lib  user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@if not "%CRDEBUG%" == "TRUE" set LIBS=/LIBPATH:c:\wxWidgets2.9\lib\vc_dll\ /LIBPATH:d:\RDKit_2011_09_1\build\lib\Release GraphMol.lib RDGeneral.lib RDGeometryLib.lib SmilesParse.lib wxbase29u.lib  wxmsw29u_core.lib wxmsw29u_aui.lib wxzlib.lib  wxjpeg.lib  wxtiff.lib  wxpng.lib  wxmsw29u_gl.lib  user32.lib shell32.lib ole32.lib comctl32.lib rpcrt4.lib winmm.lib advapi32.lib wsock32.lib Comdlg32.lib Oleaut32.lib Winspool.lib
@set LIBS=%LIBS% rc.res
@if "%CRDEBUG%" == "TRUE"     @set CDEF=/D"__WXINT__" /D"_GNUF77_" /Ic:\wxWidgets2.9\include /Ic:\wxWidgets2.9\lib\vc_dll\mswud /Id:\RDKit_2011_09_1\Code /Ic:\boost\include\boost-1_47 /D"WXUSINGDLL"
@if not "%CRDEBUG%" == "TRUE" @set CDEF=/D"__WXINT__" /D"_GNUF77_" /Ic:\wxWidgets2.9\include /Ic:\wxWidgets2.9\Lib\vc_dll\mswu /Id:\RDKit_2011_09_1\Code /Ic:\boost\include\boost-1_47 /D"WXUSINGDLL"
@set FDEF=/define:_%COMPCODE%_ /define:_INTELF77_
@set LD=xilink
@set OUT=/OUT:
@set OPT=/OPT:REF
@set LIBS=%LIBS% opengl32.lib glu32.lib
@set LDEBUG=/DEBUG /debugtype:cv /pdb:none /incremental:no
@set LDCFLAGS=/SUBSYSTEM:console
@
@set CC=cl
@set CDEF=%CDEF% /D"WIN32" /D"_WINDOWS" /D"_UNICODE"  /D__WXMSW__ 
@set COPTS=/EHs  /W3 /nologo /c /TP /I..\gui /O2 /D"NDEBUG" /MD
@set CDEBUG=/EHs /W3 /nologo /c /TP /I..\gui /Od /D"DEBUG" /RTC1 /MDd /Z7  
@set COUT=/Foobj\
@
@set F77=ifort
@set FDEF=%FDEF%
@set FOPTS=/fpp /I..\crystals /MD /O2 /nolink
@set FNOOPT=/fpp /I..\crystals /MD /O0 /nolink
@set FWIN=/winapp
@set FOUT=/object:obj\
@set FDEBUG=/fpp /I..\crystals /MDd /debug /check:bounds /check:format /check:overflow /check:pointers /check:uninit  /warn:argument_checking /warn:nofileopt /nolink /traceback /Qtrapuv
@if "%CRDEBUG%" == "TRUE" set FOUT=/object:dobj\
@if "%CRDEBUG%" == "TRUE" set COUT=/Fodobj\
@goto exit
@
:GID
@set LIBS=script1.res
@set CDEF=/D"__CR_WIN__"  /D"_AFXDLL" /D"_DIGITALF77_"
@set FDEF=/define:_%COMPCODE%_ /define:_DIGITALF77_
@
:ALLDVF
@set LD=link
@set OUT=/OUT:
@set OPT=/OPT:REF
@set LDFLAGS=/SUBSYSTEM:WINDOWS
@set LDCFLAGS=/SUBSYSTEM:console
@set LIBS=%LIBS% opengl32.lib glu32.lib
@set LDEBUG=/DEBUG /debugtype:cv /pdb:none /incremental:no

@set CC=CL
@set CDEF=%CDEF% /D"WIN32" /D"_WINDOWS" /D"_MBCS"
@set COPTS=/EHs /W3 /nologo /c /TP /I..\gui /O2 /D"NDEBUG" /MD
@set CDEBUG=/EHs /W3 /nologo /c /Od /RTC1 /MDd /Z7 /TP /I..\gui
@set COUT=/Foobj\

@set F77=DF
@set FDEF=%FDEF%
@set FOPTS=/fpp /I..\crystals /MD /optimize:4  /nolink 
@set FNOOPT=/fpp /I..\crystals /MD /optimize:0 /nolink
@set FWIN=/winapp
@set FOUT=/object:obj\
@set FDEBUG=/fpp /I..\crystals /MDd /debug /Zt /check:bounds /check:format /check:overflow /check:underflow /warn:argument_checking /warn:nofileopt /nolink /pdbfile:temp.pdb
@if "%CRDEBUG%" == "TRUE" set FOUT=/object:dobj\
@if "%CRDEBUG%" == "TRUE" set COUT=/Fodobj\
@goto exit

:DVF
set LD=link
set OUT=/OUT:
set OPT=/OPT:REF
set LDFLAGS=/SUBSYSTEM:console
set LDCFLAGS=/SUBSYSTEM:console
set LIBS=
set LDEBUG=/DEBUG /debugtype:cv /pdb:none /incremental:no
set CC=rem
set CDEF=
set COPTS=
set CDEBUG=
set COUT=
set F77=DF
set FDEF=/define:_%COMPCODE%_ /define:_DIGITALF77_
set FOPTS=/fpp /I..\crystals /ML /optimize:4 /winapp /nolink
set FNOOPT=/fpp /I..\crystals /ML /optimize:0 /winapp /nolink
set FOUT=/object:obj\
set FDEBUG=/fpp /I..\crystals /MLd /debug /Zt /check:bounds /check:format /check:overflow /check:underflow /warn:argument_checking /warn:nofileopt /nolink
@if "%CRDEBUG%" == "TRUE" set FOUT=/object:dobj\
goto exit

:DOS
:F95
set LD=slink
set OUT=-OUT:
set OPT=
set LDFLAGS=
set LDCFLAGS=
set LIBS=
set LDEBUG=-DEBUG:FULL
set CC=rem
set CDEF=
set COPTS=
set CDEBUG=
set COUT=
set F77=ftn77
set FDEF=/define:_%COMPCODE%_
set FOPTS=/cfpp /I..\crystals  /no_warn73 /zero
set FNOOPT=/fpp /I..\crystals  /no_warn73 /zero 
set FOUT=/binary obj\
set FDEBUG=/debug
@if "%CRDEBUG%" == "TRUE" set FOUT=/binary obj\

:exit

