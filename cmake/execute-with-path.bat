SET PATH=%1;%PATH%
shift

set args=%1
shift
:start
if [%1] == [] goto done
set args=%args% %1
shift
goto start

:done
%args%
