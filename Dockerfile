# Great stuff taken from: https://github.com/rastasheep/ubuntu-sshd

FROM 22.06.0-beta.0-cli-alpine3.16
RUN apk add --no-cache \
		openssh-server

RUN mkdir /var/run/sshd

RUN useradd --user-group --create-home --system mogenius

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

EXPOSE 22

# PLEASE CHANGE THAT AFTER FIRST LOGIN
RUN echo 'mogenius:mogenius' | chpasswd

CMD ["/usr/sbin/sshd", "-D", "-e"]
