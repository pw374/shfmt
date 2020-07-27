cd /d %~dp0

del /s /q build/*
rmdir /s /q build
mkdir build
cd build

go get github.com/mitchellh/gox
gox ../cmd/shfmt/
