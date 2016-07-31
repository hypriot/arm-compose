#!/bin/bash
set -ex
sed -i '/su -c "$VENV\/bin\/pyinstaller docker-compose.spec" user/d' compose/script/build/linux-entrypoint
sed -i '/pip install/d' compose/script/build/linux-entrypoint
sed -i '/\/script\/build\/write-git-sha/a \su -c "source $VENV\/bin\/activate && $VENV\/lib\/python2.7\/site-packages\/PyInstaller\/pyinstaller.py docker-compose.spec" user' compose/script/build/linux-entrypoint
