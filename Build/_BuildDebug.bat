call rsvars.bat
c:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe "..\UniNative.dproj" /t:build /p:config=Debug /p:platform=Win32
c:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe "..\UniNative.dproj" /t:build /p:config=Debug /p:platform=Win64

copy ..\Win32\Release\UniNative.dll .\UniNative32.dll
copy ..\Win64\Release\UniNative.dll .\UniNative64.dll

_za a -tzip -mx7 .\UniNative.zip ".\UniNative32.dll" ".\UniNative64.dll" ".\MANIFEST.XML"

del .\*.dll /a