REM Install in the 'bin' directory
REM http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/percent.mspx?mfr=true

set PATH=%~p0;%PATH%

%~p0\\..\\lib\\Wt\\examples\\@EXAMPLESUBDIR@\\@EXAMPLENAME@.wt  --docroot ..\\lib\\Wt\\examples\\@EXAMPLESUBDIR@ --http-port 8080 --http-addr 0.0.0.0
