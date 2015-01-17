### Windows requirements install instructions

1. Download and install Microsoft Visual Studio Express 2012 for Windows Desktop:
http://www.microsoft.com/en-us/download/details.aspx?id=34673

2. Add path to .NET framework by executing the following in command prompt:
```
SET PATH=%PATH%;C:\Windows\Microsoft.NET\Framework\v4.0.30319
```

3. Download and install boost binaries boost_1_57_0-msvc-11.0-64.exe from http://sourceforge.net/projects/boost/files/boost-binaries into c:\local\boost_1_57_0
http://sourceforge.net/projects/boost/files/boost-binaries/1.57.0/boost_1_57_0-msvc-11.0-64.exe/download

4. Set environmental variables for boost by executing the following in command prompt:
```
SET BOOST_ROOT=C:\local\boost_1_57_0
SET BOOST_LIBRARYDIR=C:\local\boost_1_57_0\lib64-msvc-11.0
```

5. Install the latest version of Cmake (http://www.cmake.org):
http://www.cmake.org/files/v3.1/cmake-3.1.0-win32-x86.exe

6. Install Python 2.7 (http://python.org):
https://www.python.org/ftp/python/2.7.9/python-2.7.9.amd64.msi