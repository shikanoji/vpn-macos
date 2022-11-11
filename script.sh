#!/usr/bin/env bash

//config create-dmg script ở đây
if [[ -e ../../create-dmg ]]; then
  # We're running from the repo
  CREATE_DMG= create-dmg
else
  # We're running from an installation under a prefix
  CREATE_DMG= create-dmg
fi

//config các thuộc tính để gen file dmg
create-dmg --volname "demo" --window-pos 200 120   --window-size 800 400  --icon-size 100   --icon "demo.app" 200 220  --app-drop-link 600 220 "demo.dmg" $1


