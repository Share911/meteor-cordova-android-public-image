# Using cordova 10
FROM beevelop/cordova:v2021.04.1

# RUN apt-get update -qq
# Adding install ca-certificates here because of expired nodesource issue
# https://github.com/nodesource/distributions/issues/1266#issuecomment-931550203
RUN apt-get update ; apt-get install ca-certificates \
    && apt-get update \
    && apt-get install -y
RUN apt-get install -y apt-transport-https ca-certificates software-properties-common

# Add bzip2 and curl to unpack meteor installer
RUN apt-get install -y bzip2 curl tar

# Add git for pulling the app source from a git repo
RUN apt-get install -y git

# Add java8 repository
RUN apt-get install -y openjdk-8-jdk

# Add these to build native npm modules
RUN apt-get install -y --no-install-recommends python2.7 make g++ build-essential
ENV PYTHON=/usr/bin/python2.7

# Install latest Meteor as root
RUN curl -v https://install.meteor.com -o /tmp/install_meteor.sh
RUN sed -i.bak "s/tar -xzf.*/tar -xf \"\$TARBALL_FILE\" -C \"\$INSTALL_TMPDIR\"/g" /tmp/install_meteor.sh
RUN sh /tmp/install_meteor.sh

# Accept android studio licenses
RUN yes | ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager --licenses

# Update and install Android SDKs using sdkmanager
RUN ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "tools" "platform-tools" --sdk_root=${ANDROID_SDK_ROOT} && \
    ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "build-tools;29.0.3" --sdk_root=${ANDROID_SDK_ROOT} && \
    ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "platforms;android-29" --sdk_root=${ANDROID_SDK_ROOT} && \
    ${ANDROID_SDK_ROOT}/tools/bin/sdkmanager "extras;android;m2repository" "extras;google;m2repository" --sdk_root=${ANDROID_SDK_ROOT}
