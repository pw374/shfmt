@echo off
cd /d %~dp0
build\shfmt_windows_amd64.exe -ns %*
