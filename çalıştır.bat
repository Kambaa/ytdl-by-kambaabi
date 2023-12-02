@echo off
setlocal enabledelayedexpansion

REM cwd bilgisi olarak klasörün bulunduğu yolu yazın
SET "cwd=%~dp0"
REM export_dir bilgisi olarak indirilen videoların nereye kaydedileceğini yazın
SET "export_dir=%userprofile%\Videos\"
REM browsername bilgisi olarak oturum açılması gerekecek siteler için (ör. instagram) oturum açılan tarayıcı adını yazın. 
REM brave, chrome, chromium, edge, firefox, opera, safari, vivaldifirefox gibi
SET "browsername=firefox"

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
rem  goto mp3download
) else if errorlevel 1 (
 set "format=mp4"
rem  goto mp4download
) else (
   echo "varsayilan secildi"
   set "format=mp4"
rem   goto mp4download
)

echo "Oturum Acilmasi Gereken Yerler Icin"
echo "Firefox Cerezlerini(cookies) Kullan:"
echo "y(EVET) n(HAYIR)"
choice /c yn /n /D n /T 2 /m "y(evet) ya da n(hayir) girin: "
if errorlevel 2 (
  echo "Cerezleri(cookie) kullanmayacak!"
  set "cookieArg="
) else (
  echo "Cerezleri(cookie) kullanacak"
  set "cookieArg=--cookies-from-browser %browsername%"
)

goto %format%download

goto endofoperation

:mp4download
echo "MP4 olarak Indiriliyor:" !url!
call  yt-dlp.exe !url! -f "bv*+ba/b" %cookieArg%  --restrict-filenames -P %export_dir% -o "%%%%(title)s%%%%(resolution)s.%%%%(ext)s" --ffmpeg-location %filename_ffmpeg% --merge-output-format "mp4" --recode-video "mp4" 
goto :endofoperation

:mp3download
echo "MP3 olarak Indiriliyor:" !url!
call yt-dlp.exe !url! %cookieArg% -P %export_dir% -o "%%%%(title)s.%%%%(ext)s" --restrict-filenames -f "(bv*+ba/b)" --ffmpeg-location %filename_ffmpeg% --recode-video "mp3"
goto endofoperation


:endofoperation

start !export_dir!

endlocal
pause;
exit 0
