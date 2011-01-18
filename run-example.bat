REM Install in the 'bin' directory
REM http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/percent.mspx?mfr=true

set PATH=%~p0;%PATH%

%~p0\..\lib\Wt\examples\%~n0 --docroot ..\lib\Wt\examples\%~n0 --http-port 8080 --http-addr 0.0.0.0
