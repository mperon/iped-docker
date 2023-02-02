FROM arm64v8/ubuntu:22.04

ENV TZ=Brazil/East
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV SAL_USE_VCLPLUGIN='gtk'
ENV JAVA_HOME=/usr/lib/jvm/bellsoft-java11-full-aarch64
ENV LD_LIBRARY_PATH=/usr/local/lib/python3.9/dist-packages/jep/
ENV IPED_VERSION=4.0.7

WORKDIR /root/pkgs
RUN apt-get update && apt-get install -y wget gnupg apt-utils software-properties-common apt-transport-https \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && wget -q -O - https://download.bell-sw.com/pki/GPG-KEY-bellsoft | gpg --dearmor > /etc/apt/trusted.gpg.d/bellsoft.gpg \
    && echo "deb [signed-by=/etc/apt/trusted.gpg.d/bellsoft.gpg] https://apt.bell-sw.com/ stable main" > /etc/apt/sources.list.d/bellsoft.list \
    && apt-get update \
    && apt-get install -y \
      git \
      build-essential \
      libafflib-dev zlib1g-dev libewf-dev unzip patch \
      autoconf automake autopoint libtool pkg-config yasm gettext wget \
      libaa1-dev libasound2-dev libcaca-dev libcdparanoia-dev libdca-dev \
      libdirectfb-dev libenca-dev libfontconfig1-dev libfreetype6-dev \
      libfribidi-dev libgif-dev libgl1-mesa-dev libjack-jackd2-dev libopenal1 libpulse-dev \
      libsdl1.2-dev libvdpau-dev libxinerama-dev libxv-dev libxvmc-dev libxxf86dga-dev \
      libxxf86vm-dev librtmp-dev libsctp-dev libass-dev libfaac-dev libsmbclient-dev libtheora-dev \
      libogg-dev libxvidcore-dev libspeex-dev libvpx-dev libdv4-dev \
      libopencore-amrnb-dev libopencore-amrwb-dev libmp3lame-dev libtwolame-dev \
      libmad0-dev libgsm1-dev libbs2b-dev liblzo2-dev ladspa-sdk libfaad-dev \
      libmpg123-dev libopus-dev libbluray-dev libaacs-dev \
      libjpeg-dev \
      libtiff-dev \
      libpng-dev \
      libwmf-dev \
      libgif-dev \
      libheif-dev \
      libwebp-dev \
      librsvg2-dev \
      libopenexr-dev \
      libatomic1 \
      vim \
      bellsoft-java11-full \
      less\
      libparse-win32registry-perl \
      tesseract-ocr tesseract-ocr-osd tesseract-ocr-por tesseract-ocr-eng tesseract-ocr-deu tesseract-ocr-frk tesseract-ocr-ita \
      graphviz \
      mplayer \
      rifiuti2 \
      libvmdk-dev libvhdi-dev \
      python3.9 python3.9-distutils python3-pip python3.9-dev \
    && apt-get download ant && chown -Rv _apt:root *.deb && chmod -Rv 700 *.deb \
    && ls *.deb | awk '{system("dpkg-deb -x "$1" /")}' && apt-get install -y ant-optional \
    && echo "#####################################" \
    && echo " Installing LIBSSL v1.1 to be used with sleuthkit IPED patch" \
    && echo "#####################################" \
    && echo "deb http://ports.ubuntu.com/ubuntu-ports/ focal-security main" | tee /etc/apt/sources.list.d/focal-security.list \
    && apt-get update \
    && apt-get install -y libssl-dev=1.1.1f-1ubuntu2.16 \
    && rm /etc/apt/sources.list.d/focal-security.list && apt-get update \
    && echo "#####################################################" \
    && echo " Installing Sleuthkit with IPED patch with libssl" \
    && echo "#####################################################" \
    && cd /opt \
    && git clone -b release-4.11.1_iped_patch https://github.com/sepinf-inc/sleuthkit \
    && cd /opt/sleuthkit/ \
    && ./bootstrap \
    && ./configure --prefix=/usr/ \
    && make && make install \
    && rm -rf /opt/sleuthkit/ \
    && echo "#####################################" \
    && echo "The libagdb only have branch master" \
    && echo "#####################################" \
    && cd /opt \
    && git clone https://github.com/libyal/libagdb.git \
    && cd /opt/libagdb \
    && ./synclibs.sh \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/libagdb \
    && echo "#####################################" \
    && echo "install libevtx - master is th only working branch" \
    && echo "#####################################" \
    && cd /opt \
    && git clone https://github.com/libyal/libevtx \
    && cd /opt/libevtx \
    && ./synclibs.sh \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/libevtx \
    && echo "#####################################" \
    && echo "Install libevt - master is th only working branch" \
    && echo "#####################################" \
    && cd /opt \
    && git clone https://github.com/libyal/libevt \
    && cd /opt/libevt \
    && ./synclibs.sh \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/libevt \
    && echo "#####################################" \
    && echo "Install libscca" \
    && echo "#####################################" \
    && cd /opt \
    && git clone --branch="20210419" https://github.com/libyal/libscca \
    && cd /opt/libscca \
    && ./synclibs.sh \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/libscca \
    && echo "#####################################" \
    && echo "Install libesedb" \
    && echo "#####################################" \
    && cd /opt \
    && git clone --branch="20210424" https://github.com/libyal/libesedb \
    && cd /opt/libesedb \
    && ./synclibs.sh \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/libesedb \
    && echo "#####################################" \
    && echo "Install libpff without branch also, because latest release got problems" \
    && echo "#####################################" \
    && cd /opt \
    && git clone https://github.com/libyal/libpff \
    && cd /opt/libpff \
    && ./synclibs.sh \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/libpff \
    && echo "#####################################" \
    && echo "Install libmsiecf" \
    && echo "#####################################" \
    && cd /opt \
    && git clone --branch="20210420" https://github.com/libyal/libmsiecf \
    && cd /opt/libmsiecf \
    && ./synclibs.sh \
    && ./autogen.sh \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/libmsiecf \
    && echo "#####################################" \
    && echo "rifiuti2 - rifiuti2 was be installed from packages due to gettext incompatibility" \
    && echo "Just creating rifiuti link" \
    && echo "#####################################" \
    #&& cd /opt \
    #&& git clone --branch="0.7.0" https://github.com/abelcheung/rifiuti2 \
    #&& cd /opt/rifiuti2 \
    #&& autoreconf -f -i -v \
    #&& ./configure --prefix=/usr \
    #&& make all install \
    #&& rm -rf /opt/rifiuti2
    && update-alternatives --install /usr/bin/rifiuti rifiuti /usr/bin/rifiuti2 1 \
    && echo "#####################################" \
    && echo "Instal ImageMagik" \
    && echo "#####################################" \
    && cd /opt \
    && git clone --branch "7.0.10-61" https://github.com/ImageMagick/ImageMagick \
    && cd /opt/ImageMagick \
    && ./configure --prefix=/usr \
    && make all install \
    && rm -rf /opt/ImageMagick \
    && echo "#####################################" \
    && echo "Creating mplayer config" \
    && echo "#####################################" \
    && mplayer \
    && echo "#####################################" \
    && echo "Installing IPED" \
    && echo "#####################################" \
    && mkdir -p /root/IPED/ && cd /root/IPED/ \
    && wget --progress=bar:force https://github.com/sepinf-inc/IPED/releases/download/$IPED_VERSION/IPED-${IPED_VERSION}_and_plugins.zip -O iped.zip \
    && unzip iped.zip && rm iped.zip && ln -s iped-$IPED_VERSION iped \
    && echo "#####################################" \
    && echo "Configuring Local config with our default values" \
    && echo "#####################################" \
    && echo "If you need to change the IPED LocalConfig, use the environment variables available on /entrypoint.sh" \
    && echo "#####################################" \
    && sed -i -e "s/locale =.*/locale = pt-BR/" /root/IPED/iped/LocalConfig.txt \
    && sed -i -e "s/indexTemp =.*/indexTemp = \/mnt\/ipedtmp/" /root/IPED/iped/LocalConfig.txt \
    && sed -i -e "s/indexTempOnSSD =.*/indexTempOnSSD = true/" /root/IPED/iped/LocalConfig.txt \
    && sed -i -e "s/outputOnSSD =.*/outputOnSSD = false/" /root/IPED/iped/LocalConfig.txt \
    && sed -i -e "s/numThreads =.*/numThreads = 8/" /root/IPED/iped/LocalConfig.txt \
    && sed -i -e "s/#hashesDB =.*/hashesDB = \/mnt\/hashesdb\/iped-hashes.db/" /root/IPED/iped/LocalConfig.txt \
    && sed -i -e "s/#tskJarPath =.*/tskJarPath = \/usr\/share\/java\/sleuthkit-4.11.1.jar/" /root/IPED/iped/LocalConfig.txt \
    && sed -i -e "s/mplayerPath =.*/mplayerPath = \/usr\/bin\/mplayer/" /root/IPED/iped/LocalConfig.txt \
    && echo "#####################################" \
    && echo "Configuring GraphConfig with our default values:BR" \
    && echo "#####################################" \
    && sed -i -e "s/\"phone-region\":.*/\"phone-region\":\"BR\",/" /root/IPED/iped/conf/GraphConfig.json \
    && echo "#####################################" \
    && echo "Creating custom Profiles" \
    && echo "#####################################" \
    && echo "FastRobust: Disable IndexUnknownFiles and enable excludeKffIgnorable, externalParsers and robustImageReading" \
    && echo "General analysis cases where processing errors are occurring" \
    && echo "#####################################" \
    && cp -r /root/IPED/iped/profiles/forensic /root/IPED/iped/profiles/fastrobust \
    && echo "parseUnknown = false" >> /root/IPED/iped/profiles/fastrobust/conf/ParsingTaskConfig.txt \
    && echo "excludeKnown = true" >> /root/IPED/iped/profiles/fastrobust/conf/HashDBLookupConfig.txt \
    && echo "robustImageReading = true" >> /root/IPED/iped/profiles/fastrobust/conf/FileSystemConfig.txt \
    && echo "enableExternalParsing = true" >> /root/IPED/iped/profiles/fastrobust/conf/ParsingTaskConfig.txt \
    && echo "#####################################" \
    && echo "PedoRobust: enable excludeKffIgnorable, externalParsers and robustImageReading" \
    && echo "For child abuse cases where processing errors are occurring" \
    && echo "#####################################" \
    && cp -r /root/IPED/iped/profiles/pedo /root/IPED/iped/profiles/pedorobust \
    && echo "excludeKnown = true" >> /root/IPED/iped/profiles/pedorobust/conf/HashDBLookupConfig.txt \
    && echo "robustImageReading = true" >> /root/IPED/iped/profiles/pedorobust/conf/FileSystemConfig.txt \
    && echo "enableExternalParsing = true" >> /root/IPED/iped/profiles/pedorobust/conf/ParsingTaskConfig.txt \
    && echo "#####################################" \
    && echo "Installing PYTHON IPED Dependencies" \
    && echo "#####################################" \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.9 1 \
    && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 \
    && python -m pip install pip --upgrade \
    && python -m pip install cmake \
    && python -m pip install numpy \
    && python -m pip install jep==4.0.3 \
                          keras \
                          tensorflow \
                          pillow \
                          bs4 \
                          face_recognition \
                          huggingsound \
    && echo "#####################################" \
    && echo "Cleaning UP the container " \
    && echo "#####################################" \
    && apt-get remove -y ant ant-optional python3-pip build-essential \
                       autoconf automake autopoint libtool pkg-config yasm gettext \
    && apt-get autoremove -y \
    && rm -rf /root/.cache/pip && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /root/IPED/iped
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]
