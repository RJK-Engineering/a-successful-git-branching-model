@echo off
set USER=RJK-Engineering

set MERGE_TYPE=
if "%1"=="ff"     set MERGE_TYPE=ff
if "%1"=="no-ff"  set MERGE_TYPE=no-ff
if "%1"=="squash" set MERGE_TYPE=squash
if "%MERGE_TYPE%"=="" goto END

set REPO=a-successful-git-branching-model-%1
echo %REPO%
if exist %REPO% goto END

git clone https://github.com/%USER%/%REPO%.git
copy . %REPO%
cd %REPO%
git config credential.helper store

@echo on
call ..\build-repo.bat
@echo off

:END
set MERGE_TYPE=
echo USAGE:
echo %0 ff
echo %0 no-ff
echo %0 squash
