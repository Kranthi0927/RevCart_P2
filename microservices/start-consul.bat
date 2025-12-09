@echo off
echo Starting Consul...
consul agent -dev -ui -client=0.0.0.0
pause