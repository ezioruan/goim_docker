FROM ubuntu:14.04
MAINTAINER Ezio Ruan <qiaoqinqie2@gmail.com>
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get install -y  \ 
    openjdk-7-jdk \
    mercurial \
    git \
    wget \
    lsof \
    curl \
    vim
RUN mkdir -p /data/programfiles /data/apps/go /data/logs/goim  && cd /data/programfiles
RUN wget http://apache.fayea.com/kafka/0.9.0.0/kafka_2.11-0.9.0.0.tgz
RUN tar -xzf kafka_2.11-0.9.0.0.tgz && cd kafka_2.11-0.9.0.0
RUN cd /data/programfiles
RUN wget https://storage.googleapis.com/golang/go1.6.1.linux-amd64.tar.gz
RUN tar -xvf go1.6.1.linux-amd64.tar.gz -C /usr/local
RUN echo "export GOROOT=/usr/local/go" >> /etc/profile.d/golang.sh
RUN echo "export PATH=$PATH:$GOROOT/bin" >> /etc/profile.d/golang.sh
RUN echo "export GOPATH=/data/apps/go" >> /etc/profile.d/golang.sh
RUN source /etc/profile
RUN go get -u github.com/Terry-Mao/goim
RUN mv $GOPATH/src/github.com/Terry-Mao/goim $GOPATH/src/goim
RUN cd $GOPATH/src/goim
RUN go get -v ./...
RUN cd $GOPATH/src/goim/router
RUN go install
RUN cp router-example.conf $GOPATH/bin/router.conf
RUN cp router-log.xml $GOPATH/bin/
RUN cd ../logic/
RUN go install
RUN cp logic-example.conf $GOPATH/bin/logic.conf
RUN cp logic-log.xml $GOPATH/bin/
RUN cd ../comet/
RUN go install
RUN cp comet-example.conf $GOPATH/bin/comet.conf
RUN cp comet-log.xml $GOPATH/bin/
RUN cd ../logic/job/
RUN go install
RUN cp job-example.conf $GOPATH/bin/job.conf
RUN cp job-log.xml $GOPATH/bin/
RUN cd $GOPATH/bin/
RUN echo "nohup $GOPATH/bin/router -c $GOPATH/bin/router.conf 2>&1 > /data/logs/goim/panic-router.log &" > router_start.sh
RUN echo "nohup $GOPATH/bin/logic -c $GOPATH/bin/logic.conf 2>&1 > /data/logs/goim/panic-logic.log &" > logic_start.sh 
RUN echo "nohup $GOPATH/bin/comet -c $GOPATH/bin/comet.conf 2>&1 > /data/logs/goim/panic-comet.log &" > comet_start.sh
RUN echo "nohup $GOPATH/bin/job -c $GOPATH/bin/job.conf 2>&1 > /data/logs/goim/panic-job.log &" > job_start.sh
RUN chmox +x *.sh

