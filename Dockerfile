# escape=`

# Copyright (C) Emweb bv.
# Based on the native-desktop sample: https://github.com/Microsoft/vs-Dockerfiles
#
# Original license from Microsoft:
# The MIT License (MIT) 
# Copyright (C) Microsoft Corporation. All rights reserved.
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Using a full fat Windows Server so we have all fonts for Graphviz
FROM mcr.microsoft.com/windows/server:ltsc2022

# Reset the shell.
SHELL ["cmd", "/S", "/C"]

# Set up environment to collect install errors.
COPY Install.cmd C:\TEMP\
RUN powershell `
      -NoProfile `
      -ExecutionPolicy Bypass `
      -Command "(New-Object System.Net.WebClient).DownloadFile('https://aka.ms/vscollect.exe', 'C:\TEMP\collect.exe')"

# Download channel for fixed install.
ARG CHANNEL_URL=https://aka.ms/vs/17/release/channel
RUN powershell `
      -NoProfile `
      -ExecutionPolicy Bypass `
      -Command "(New-Object System.Net.WebClient).DownloadFile(\"$env:CHANNEL_URL\", 'C:\TEMP\VisualStudio.chman')"

# Download and install Build Tools for Visual Studio 2022 for native desktop workload,
# including 14.1 (VS 2017) and 14.2 (VS 2019) components
ARG BUILDTOOLS_URL=https://aka.ms/vs/17/release/vs_buildtools.exe
RUN powershell `
    -NoProfile `
    -ExecutionPolicy Bypass `
    -Command "(New-Object System.Net.WebClient).DownloadFile(\"$env:BUILDTOOLS_URL\", 'C:\TEMP\vs_buildtools.exe')"

RUN C:\TEMP\Install.cmd C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --channelUri C:\TEMP\VisualStudio.chman `
    --installChannelUri C:\TEMP\VisualStudio.chman `
    --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended `
    --add Microsoft.VisualStudio.Component.VC.v141.x86.x64 `
    --add Microsoft.VisualStudio.ComponentGroup.VC.Tools.142.x86.x64 `
    --installPath C:\BuildTools

ARG CHOCO_URL=https://chocolatey.org/install.ps1
RUN powershell `
      -NoProfile `
      -ExecutionPolicy Bypass `
      -Command "Invoke-Expression ((New-Object System.Net.WebClient).DownloadString(\"$env:CHOCO_URL\"))"

# aqt: to install qhelpgenerator
# git: to fetch dependencies
# graphviz: to build graphs in the documentation
# nsis: to create the installer EXE
RUN choco install `
      aqt `
      git `
      graphviz `
      nsis `
      -y

# Install everything we need for qhelpgenerator
RUN aqt install-qt windows desktop 6.4.0 win64_msvc2019_64 `
      --outputdir C:\Qt `
      --archives qtbase qttools

# Download Doxygen 1.9.1 (matching the version we have on Ubuntu 22.04)
ARG DOXYGEN_URL=https://www.doxygen.nl/files/doxygen-1.9.1.windows.x64.bin.zip
RUN powershell `
      -NoProfile `
      -ExecutionPolicy Bypass `
      -Command "(New-Object System.Net.WebClient).DownloadFile(\"$env:DOXYGEN_URL\", 'C:\TEMP\doxygen.zip')"
RUN powershell `
      -NoProfile `
      -ExecutionPolicy Bypass `
      -Command "Expand-Archive -Path C:\TEMP\doxygen.zip -DestinationPath C:\Doxygen"
