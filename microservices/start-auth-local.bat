@echo off
echo Starting Auth Service in Local Mode (No Database Required)...
cd auth-service
mvn exec:java -Dexec.mainClass="com.revcart.auth.LocalAuthApplication"
pause