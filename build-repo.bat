if "%MERGE_TYPE%"=="ff" set MERGE_ARGS=ff
if "%MERGE_TYPE%"=="no-ff"  set MERGE_ARGS=--no-ff
if "%MERGE_TYPE%"=="squash" set MERGE_ARGS=--squash
if "%MERGE_ARGS%"=="" goto END
if "%MERGE_ARGS%"=="ff" set MERGE_ARGS=

# create release 0.1
echo > m & git add . & git commit -m "m"
git push
git tag -a 0.1 -m "Hello world!"
git push origin 0.1

# create develop branch
git checkout -b develop master
echo > d1 & git add . & git commit -m "d1"
echo > d2 & git add . & git commit -m "d2"
echo > d3 & git add . & git commit -m "d3"
git push -u origin develop
git tag f1-and-f2-base

# create new feature branch and push to origin
git checkout -b feature/F001 develop
echo > f1-1 & git add . & git commit -m "f1-1"
git push -u origin feature/F001

git checkout develop
echo > d4 & git add . & git commit -m "d4"
git push

git checkout -b feature/F002 f1-and-f2-base
echo > f2-1 & git add . & git commit -m "f2-1"
git push -u origin feature/F002

git checkout feature/F001
echo > f1-2 & git add . & git commit -m "f1-2"
git push

git checkout feature/F002
echo > f2-2 & git add . & git commit -m "f2-2"
git push

git checkout develop
echo > d5 & git add . & git commit -m "d5"
git push

# create new hotfix branch and push to origin
git checkout -b hotfix/0.2 master
echo > h1-0.2 & git add . & git commit -a -m "Bumped version number to 0.2"
git push -u origin hotfix/0.2

# merge to master, tag with new version
git checkout master
git merge %MERGE_ARGS% hotfix/0.2
git commit --no-edit
git push
git tag -a 0.2 -m "It's a beautiful day"
git push origin 0.2

# merge to develop, delete local branch
git checkout develop
git merge %MERGE_ARGS% hotfix/0.2
git commit --no-edit
git push
git branch -d hotfix/0.2

git checkout feature/F002
echo > f2-3 & git add . & git commit -m "f2-3"
git push
git tag F002

# merge to develop and delete local branch
git checkout develop
git merge %MERGE_ARGS% feature/F002
git commit --no-edit
git push
git branch -d feature/F002

# create new release branch
git checkout -b release/1.0 develop
echo > r1-1.0 & git add . & git commit -a -m "Bumped version number to 1.0"
echo > r2-1.0 & git add . & git commit -m "r2-1.0"
git push -u origin release/1.0

# merge release back into develop (may be done continuously)
git checkout develop
git merge %MERGE_ARGS% release/1.0
git commit --no-edit
git push

git checkout release/1.0
echo > r3-1.0 & git add . & git commit -m "r3-1.0"
git push

git checkout feature/F001
echo > f1-3 & git add . & git commit -m "f1-3"
git push

git checkout -b feature/F003 develop
echo > f3-1 & git add . & git commit -m "f3-1"
echo > f3-2 & git add . & git commit -m "f3-2"
git push -u origin feature/F003

git checkout release/1.0
echo > r4-1.0 & git add . & git commit -m "r4-1.0"
git push

git checkout develop
git merge %MERGE_ARGS% release/1.0
git commit --no-edit
git push

git checkout feature/F003
echo > f3-3 & git add . & git commit -m "f3-3"
git push
git tag F003

# release 1.0, tag, delete local branch
git checkout master
git merge %MERGE_ARGS% release/1.0
git commit --no-edit
git push
git tag -a 1.0 -m "A new dawn"
git push origin 1.0
git branch -d release/1.0

git checkout feature/F001
echo > f1-4 & git add . & git commit -m "f1-4"
git push
git tag F001

# merge F001 and F003 (octopus merge)
git checkout develop
git merge %MERGE_ARGS% feature/F001 feature/F003
git commit --no-edit
git push
git branch -d feature/F001 feature/F003

# release 2.0
git checkout -b release/2.0 develop
echo > r1-2.0 & git add . & git commit -a -m "Bumped version number to 2.0"
git push -u origin release/2.0

git checkout develop
git merge %MERGE_ARGS% release/2.0
git commit --no-edit
git push

# release, tag, delete local branch
git checkout master
git merge %MERGE_ARGS% release/2.0
git commit --no-edit
git push
git tag -a 2.0 -m "A new day"
git push origin 2.0
git branch -d release/2.0

:END
