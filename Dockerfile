# Environemnt to install flutter and build web
FROM rolplay/flutter AS build-env

# install all needed stuff
RUN apt-get update
RUN apt-get install -y curl git unzip

# define variables
ARG FLUTTER_SDK=/usr/local/flutter
ARG FLUTTER_VERSION=3.10.5

#clone flutter
#RUN git clone https://github.com/flutter/flutter.git $FLUTTER_SDK
# change dir to current flutter folder and make a checkout to the specific version
#RUN cd $FLUTTER_SDK && git fetch && git checkout $FLUTTER_VERSION

# setup the flutter path as an enviromental variable
ENV PATH="$FLUTTER_SDK/bin:$FLUTTER_SDK/bin/cache/dart-sdk/bin:${PATH}"

#RUN mkdir /usr/src/app

WORKDIR /usr/src/app

#COPY . .

# Start to run Flutter commands
# doctor to see if all was installes ok
#RUN flutter doctor -v

# Run build: 1 - clean, 2 - pub get
RUN flutter clean
RUN flutter pub get

# once heare the app will be compiled and ready to deploy
# CMD ["nginx", "-g", "daemon off;"]
ENTRYPOINT ["/bin/sh", "-c", "/bin/bash"]