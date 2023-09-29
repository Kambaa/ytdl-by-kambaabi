@echo off
setlocal enabledelayedexpansion

SET filename_ytdlp="yt-dlp.exe"
SET filename_ffmpeg="ffmpeg.exe"
SET filename_ffplay="ffplay.exe"
SET filename_ffprobe="ffprobe.exe"

set start_checks_fail="false"

IF NOT  EXIST %filename_ytdlp% (
   echo "yt-dlp.exe eksik!"
   echo "Lutfen asagidaki adresten temin ediverin:"
   echo "https://github.com/yt-dlp/yt-dlp/releases"
   set start_checks_fail="true"
)

IF NOT EXIST %filename_ffmpeg% (
   set start_checks_fail="true"
   echo "ffmpeg.exe eksik"
   echo "Lutfen asagidaki adresten temin ediverin:"
   echo "https://www.gyan.dev/ffmpeg/builds/"
)

IF NOT EXIST %filename_ffplay% (
   set start_checks_fail="true"
   echo "ffplay.exe eksik"
   echo "Lutfen asagidaki adresten temin ediverin:"
   echo "https://www.gyan.dev/ffmpeg/builds/"
)

IF NOT EXIST %filename_ffprobe% (
   set start_checks_fail="true"
   echo "ffprobe.exe eksik
   echo "Lutfen asagidaki adresten temin ediverin:"
   echo "https://www.gyan.dev/ffmpeg/builds/"
)

if !start_checks_fail! == "true" (
   timeout /t 10 /nobreak
   exit 1
)

echo "Adresi Girin:"
set /p "url="

echo Donusturulecek formati secin:
echo 1. mp4 (varsayilan)
echo 2. mp3
rem /T 1 ile 1 saniye bekledikten sonra
rem /D 1 ile varsayılan olarak 1'i otomatik seçmesini ayarladım.
choice /c 12 /n /D 1 /T 1 /m "1 ya da 2 Girin: "

if errorlevel 2 (
  set "format=mp3"
  goto mp3download
) else if errorlevel 1 (
  set "format=mp4"
  goto mp4download
) else (
   echo "varsayilan secildi"
   goto mp4download
)

goto endofoperation

:mp4download
echo "MP4 olarak Indiriliyor:" !url!
call  yt-dlp.exe !url! -f "bv*+ba/b" -o "%userprofile%\Videos\%%%%(title)s%%%%(resolution)s.%%%%(ext)s" --ffmpeg-location ".\ffmpeg.exe" --merge-output-format "mp4" --recode-video "mp4"
goto :endofoperation

:mp3download
echo "MP3 olarak Indiriliyor:" !url!
call yt-dlp.exe !url! -o "%userprofile%/Videos/%%%%(title)s.%%%%(ext)s" -f "(bv*+ba/b)" --ffmpeg-location ".\ffmpeg.exe" --recode-video "mp3"
goto endofoperation



:endofoperation
endlocal
start %userprofile%\Videos
pause;
exit 0
