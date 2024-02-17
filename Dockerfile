FROM cruizba/ubuntu-dind


RUN apt-get update \
  && apt-get install -qq -y init systemd \
  && apt-get install -qq -y build-essential \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
  && apt-get install -qq -y vim \
  && apt-get install -qq -y curl \
  && apt-get install -qq -y sudo \
  && apt-get install -qq -y ufw \
  && apt-get install -qq -y openssh-server\
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN adduser -u 10000 sbling
RUN usermod -aG sudo sbling
RUN chsh -s /bin/bash sbling
RUN usermod --password root root
RUN echo 'sbling:sbling' | chpasswd
RUN echo 'root:root' | chpasswd
RUN echo 'sbling ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

COPY .bashrc /home/sbling/.bashrc
RUN chmod 777 /home/sbling/.bashrc

COPY .profile /home/sbling/.profile
RUN chmod 777 /home/sbling/.profile

COPY .ssh /home/sbling/.ssh
RUN chmod -R 555 /home/sbling/.ssh
RUN touch /home/sbling/.ssh/authorized_keys
RUN chmod 600 /home/sbling/.ssh/authorized_keys

COPY .vimrc /home/sbling/.vimrc 
RUN chmod 777 /home/sbling/.vimrc

COPY init.sh /home/sbling/init.sh
RUN chmod 700 /home/sbling/init.sh

RUN chown -R sbling /home/sbling




WORKDIR /home/sbling
USER sbling

EXPOSE 22 80 443 5432

ENTRYPOINT ["bash","./init.sh"]
