FROM ubuntu
MAINTAINER venantvr

##########################################
# Install desktop and VNC server.
##########################################
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y ubuntu-desktop tightvncserver && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get -y -f install
RUN apt-get -y install gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal

##########################################
# Define working directory.
##########################################
WORKDIR /data

##########################################
# Prérequis
##########################################
RUN apt-get -y -f install
RUN apt-get -y install apt-utils
RUN apt-get -y install nano
RUN apt-get -y install wget

##########################################
# Requis pour visual studio code
##########################################
RUN apt-get -y -f install
RUN apt-get -y install libnotify4
RUN wget http://mirrors.kernel.org/ubuntu/pool/main/i/icu/libicu52_52.1-3ubuntu0.4_amd64.deb
RUN dpkg -i libicu52_52.1-3ubuntu0.4_amd64.deb

##########################################
# Installation de dotnetcore
##########################################
RUN apt-get -y -f install
RUN sh -c 'echo "deb [arch=amd64] http://apt-mo.trafficmanager.net/repos/dotnet-release/ trusty main" > /etc/apt/sources.list.d/dotnetdev.list'
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893
RUN apt-get update && apt-get purge dotnet-host dotnet-hostfxr-1.0.1 dotnet-sharedframework-microsoft.netcore.app-1.0.0
RUN wget https://download.microsoft.com/download/1/4/1/141760B3-805B-4583-B17C-8C5BC5A876AB/Installers/dotnet-sdk-ubuntu.16.04-x64.1.0.0-preview2-1-003177.deb
RUN apt-get -y install dotnet-sharedframework-microsoft.netcore.app-1.1.0
RUN dpkg -i dotnet-sdk-ubuntu.16.04-x64.1.0.0-preview2-1-003177.deb

##########################################
# Installation de visual studio code
##########################################
RUN apt-get -y -f install
RUN wget https://az764295.vo.msecnd.net/stable/ee428b0eead68bf0fb99ab5fdc4439be227b6281/code_1.8.1-1482158209_amd64.deb
RUN dpkg -i code_1.8.1-1482158209_amd64.deb
# Source : http://stackoverflow.com/questions/33984906/cant-launch-visual-studio-code-on-ubuntu
RUN sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /usr/lib/x86_64-linux-gnu/libxcb.so.1

##########################################
# Installation des extensions
##########################################
RUN code --user-data-dir=/vscode.extensions --install-extension ms-vscode.csharp
RUN code --user-data-dir=/vscode.extensions --install-extension chiehyu.vscode-astyle
RUN code --user-data-dir=/vscode.extensions --install-extension Leopotam.csharpfixformat

##########################################
# Finalisation
# Set user for VNC server
# Set default password
# Copy VNC script that handles restarts
##########################################
RUN apt-get -y -f install
ENV USER root
COPY password.txt .
RUN cat password.txt password.txt | vncpasswd && rm password.txt
COPY start-vnc.sh /opt/
RUN chmod +x /opt/start-vnc.sh

##########################################
# Define default command.
##########################################
CMD [ "/bin/sh", "/opt/start-vnc.sh" ]
COPY xstartup /root/.vnc/
RUN chmod 777 /root/.vnc/xstartup

##########################################
# Ménage
##########################################
RUN apt-get -y clean

##########################################
# Expose ports.
##########################################
EXPOSE 5901

