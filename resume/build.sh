#!/bin/sh
# Builds both resume PDFs from resume/resume.html.
#   public/Nate_Arnold_resume.pdf         no phone number, linked from the site
#   resume/Nate_Arnold_resume_private.pdf  with the phone number from resume/.phone
# Both resume/.phone and the private PDF are gitignored, so the number never
# reaches the public repo.
set -e
cd "$(dirname "$0")/.."

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
SRC="file://$PWD/resume/resume.html"

print() {
  "$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="$1" "$2" 2>/dev/null
  echo "wrote $1"
}

print public/Nate_Arnold_resume.pdf "$SRC"

if [ -f resume/.phone ]; then
  PHONE=$(python3 -c 'import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read().strip()))' < resume/.phone)
  print resume/Nate_Arnold_resume_private.pdf "$SRC?phone=$PHONE"
else
  echo "skipped the private copy: add your phone number to resume/.phone"
fi
