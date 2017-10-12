# Jenkins agent for NetSuite build environment
# AUTHOR                Alex Manatskyi
# VERSION               1.0

FROM jenkinsci/ssh-slave

ARG NODE_VERSION=6.x
#ARG PYTHON_VERSION=2.7.1
ARG SDFCLI_URL=https://system.netsuite.com/download/ide/update_17_2/plugins/com.netsuite.ide.core_2017.2.0.jar
ARG SDFCLI_SUPL_URL=https://system.netsuite.com/core/media/media.nl?id=87134768&c=NLCORP&h=8e8f2820ee2d719ac411&id=87134768&_xt=.gz&_xd=T&e=T
ARG SDFCLI_FOLDER=/webdev/sdf/cli

# Installing Maven and Python????
RUN apt-get update && apt-get install -y \
    maven \
    && apt-get clean

# Installing Node.js
RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install nodejs

# TMP to fix java slave issue
RUN ln -s "$JAVA_HOME/jre/bin/java" /usr/local/bin/java

# Installing Gulp
RUN npm install gulp -g

# Installing NetSuite SDF CLI
ENV PATH $PATH:$SDFCLI_FOLDER

RUN mkdir -p $SDFCLI_FOLDER && \
    cd $SDFCLI_FOLDER && \
    wget $SDFCLI_URL && \
    wget -qO- $SDFCLI_SUPL_URL | tar xvz && \
    mvn exec:java -Dexec.args= && \
    chmod +x sdfcli && \
    #removing Windows based CR char causing issues in UNIX based systems
    sed -i -e 's/\r$//' sdfcli

# TMP to fix SDFCLI slave issue
RUN ln -s "$SDFCLI_FOLDER/sdfcli" /usr/bin/sdfcli

