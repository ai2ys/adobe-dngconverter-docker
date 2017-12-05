FROM 32bit/ubuntu:16.04
MAINTAINER jarnoh@komplex.org

COPY ubuntu-wine.list /etc/apt/sources.list.d/ubuntu-wine.list

WORKDIR /work

# TODO libpulse0 is needed, otherwise wine/winetricks does not start, how to set sound=disabled without winetricks?

RUN \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 38AE4F60E356CE050312FA1775CFD31C9E5DB0C8 && \
apt-get update && \
apt-get -y install --no-install-recommends wine-stable winetricks libpulse0 && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/log/*.log /var/log/apt/*.log /var/cache/debconf

ENV WINEPREFIX=/usr/local/dngconverter WINEARCH=win32 WINEDLLOVERRIDES=mscoree,mshtml= DISPLAY=:0.0

RUN winetricks settings win7

COPY dngconverter /usr/local/bin
# download links http://supportdownloads.adobe.com/product.jsp?product=106&platform=Windows
ENV DNGVER=10_0
RUN wget http://download.adobe.com/pub/adobe/dng/win/DNGConverter_${DNGVER}.exe && /usr/local/bin/dngconverter -i DNGConverter_${DNGVER}.exe && rm -f DNGConverter_${DNGVER}.exe

# make wine silent
ENV WINEDEBUG -all

ENTRYPOINT ["/usr/local/bin/dngconverter"]
