@echo off
if exist trk2iso.rar del trk2iso.rar
del *.vpi >nul 2>nul
del *.obj >nul 2>nul
del *.lnk >nul 2>nul
del *.lib >nul 2>nul
copy *.exe os2
del *.exe
rar a -r trk2iso
