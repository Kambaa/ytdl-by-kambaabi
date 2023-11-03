@echo off
setlocal enabledelayedexpansion
REM BURAYA ÇIKARDIĞINIZ KLASÖRÜN YOLUNU YAZINIZ
SET "cwd=Z:\ProgramFiles\ytdl-by-kambaabi"
REM BURAYA VİDEOLARI İNME KLASÖRÜN YOLUNU YAZINIZ
SET "export_dir=%userprofile%\Videos\"

SET filename_ytdlp="%cwd%\yt-dlp.exe"
SET filename_ffmpeg="%cwd%\ffmpeg.exe"
SET filename_ffplay="%cwd%\ffplay.exe"
SET filename_ffprobe="%cwd%\ffprobe.exe"

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
rem /T 3 saniye bekledikten sonra
rem /D 1 ile varsayılan olarak 1'i otomatik seçmesini ayarladım.
choice /c 12 /n /D 1 /T 3 /m "1 ya da 2 Girin: "

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
call  yt-dlp.exe !url! -f "bv*+ba/b" --restrict-filenames -P %export_dir% -o "%%%%(title)s%%%%(resolution)s.%%%%(ext)s" --ffmpeg-location %filename_ffmpeg% --merge-output-format "mp4" --recode-video "mp4" 
goto :endofoperation

:mp3download
echo "MP3 olarak Indiriliyor:" !url!
call yt-dlp.exe !url! -P %export_dir% -o "%%%%(title)s.%%%%(ext)s" --restrict-filenames -f "(bv*+ba/b)" --ffmpeg-location %filename_ffmpeg% --recode-video "mp3"
goto endofoperation


:endofoperation

start !export_dir!

endlocal
pause;
exit 0
