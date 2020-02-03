del UniNative.zip /a
del ..\Win32\*.* /a /y
del ..\Win64\*.* /a /y
del *.dll /a

call rsvars.bat
c:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe "..\UniNative.dproj" /t:build /p:config=Release /p:platform=Win32
c:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe "..\UniNative.dproj" /t:build /p:config=Release /p:platform=Win64

copy ..\Win32\Release\UniNative.dll .\UniNative32.dll
copy ..\Win64\Release\UniNative.dll .\UniNative64.dll

call codesigning.cmd .\UniNative32.dll
call codesigning.cmd .\UniNative64.dll

_za a -tzip -mx7 .\UniNative.zip ".\UniNative32.dll" ".\UniNative64.dll" ".\MANIFEST.XML"

del .\*.dll /a