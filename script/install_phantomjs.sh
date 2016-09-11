VERSION=2.1.1
BASENAME=phantomjs-$VERSION-linux-x86_64
FULLNAME=$BASENAME.tar.bz2
DOWNLOAD_BASE_URI=https://github.com/Medium/phantomjs
DOWNLOAD_URI=$DOWNLOAD_BASE_URI/releases/download/v$VERSION/$FULLNAME

export PATH=$PWD/.phantomjs/$BASENAME/bin:$PATH
mkdir -p .phantomjs
wget --quiet $DOWNLOAD_URI -O .phantomjs/$FULLNAME
tar -xvf .phantomjs/$FULLNAME -C .phantomjs $BASENAME/bin/phantomjs
