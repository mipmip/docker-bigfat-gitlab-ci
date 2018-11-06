FROM ruby:2.4

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Set timezone
RUN echo "EU/Amsterdam" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update -y && \
  apt-get install -y unzip xvfb \
  qt5-default libqt5webkit5-dev \
  gstreamer1.0-plugins-base \
  gstreamer1.0-tools gstreamer1.0-x \
  freetds-dev \
  libnss3 libxi6 libgconf-2-4

# Install Rsync/git
RUN apt-get update && apt-get install -y rsync git

# Install deps + add Chrome Stable + purge all the things
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    --no-install-recommends \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# install chromedriver and place it in path
RUN wget https://chromedriver.storage.googleapis.com/2.36/chromedriver_linux64.zip && \
	unzip chromedriver_linux64.zip && \
	mv chromedriver /usr/local/bin/

# Install nodejs & stuff
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs

# Install Bower & Grunt
RUN npm install -g bower gulp gulp-autoprefixer gulp-cache child_process gulp-imagemin gulp-sass imagemin-pngquant browser-sync grunt-cli && \
    echo '{ "allow_root": true }' > /root/.bowerrc
