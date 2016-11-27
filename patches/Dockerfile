FROM hypriot/arm-pyinstaller

ADD . /code/
RUN chown -R user /code/

ENV VENV /code/.tox/py27
RUN mkdir -p dist
RUN chmod 777 dist
RUN $VENV/bin/pip install -q -r requirements-build.txt
RUN ./script/build/write-git-sha
RUN su -c "source $VENV\/bin\/activate && $VENV\/lib\/python2.7\/site-packages\/PyInstaller\/pyinstaller.py docker-compose.spec" user
RUN ls -l dist
