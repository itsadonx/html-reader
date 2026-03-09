@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%"=="" @echo off

set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.
set DIRNAME=%DIRNAME:~0,-1%
set PROJECT_DIR=%DIRNAME%

set WRAPPER_JAR=%PROJECT_DIR%\gradle\wrapper\gradle-wrapper.jar
set WRAPPER_LAUNCHER=org.gradle.wrapper.GradleWrapperMain

if not exist "%WRAPPER_JAR%" (
    echo Gradle wrapper JAR not found. Run build-apk.ps1 to create it, or install Android Studio.
    exit /b 1
)

set CLASSPATH=%WRAPPER_JAR%

set JAVA_EXE=java
set JAVA_OPTS=-Dfile.encoding=UTF-8

"%JAVA_EXE%" %JAVA_OPTS% -classpath "%CLASSPATH%" %WRAPPER_LAUNCHER% %*
