# Jenkins agent for NetSuite build environment
# AUTHOR                Alex Manatskyi
# VERSION               1.0

FROM jenkinsci/ssh-slave

# Installing core dependencies
RUN apt-get update && apt-get install -y \
    build-essential checkinstall \
    libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev \
    maven \
    && apt-get clean \
    # TMP to fix java slave issue
    && ln -s "$JAVA_HOME/jre/bin/java" /usr/local/bin/java

# Installing Python 2.7
RUN cd /usr/src && \
    wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz && \
    tar xzf Python-2.7.13.tgz && \
    cd Python-2.7.13 && \
    ./configure && \
    make altinstall

# Installing Node.js
ARG NODE_VERSION=6.x

RUN wget https://deb.nodesource.com/setup_${NODE_VERSION} -O nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install nodejs

# Installing Gulp
RUN npm install -g gulp

# Installing NetSuite SDF CLI
ARG SDFCLI_URL=https://system.netsuite.com/download/ide/update_17_2/plugins/com.netsuite.ide.core_2017.2.0.jar
ARG SDFCLI_SUPL_URL=https://system.netsuite.com/core/media/media.nl?id=87134768&c=NLCORP&h=8e8f2820ee2d719ac411&id=87134768&_xt=.gz&_xd=T&e=T
ARG SDFCLI_INSTALL_FOLDER=/sdfcli/
ARG SDFCLI_TARGET_FOLDER=/usr/bin/

COPY patch_pom.js package.json ${SDFCLI_INSTALL_FOLDER}

RUN cd $SDFCLI_INSTALL_FOLDER && \
    wget ${SDFCLI_URL} && \
    wget -qO- ${SDFCLI_SUPL_URL} | tar xvz  && \
    npm install && \
    node patch_pom.js ./pom.xml && \
    mvn install:install-file \
        -Dfile=com.netsuite.ide.core_2017.2.0.jar \
        -DgroupId=com.netsuite \ 
        -DartifactId=sdfcli \
        -Dversion=2017.2.0 \
        -Dpackaging=jar && \
    mvn clean compile assembly:single && \
    mv ./target/sdf-cli-2017.2.0-jar-with-dependencies.jar ${SDFCLI_TARGET_FOLDER} && \
    rm -rf ${SDFCLI_INSTALL_FOLDER}

COPY sdfcli ${SDFCLI_TARGET_FOLDER}
