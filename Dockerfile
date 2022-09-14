# Great stuff taken from: https://github.com/rastasheep/ubuntu-sshd

FROM docker:22.06.0-beta.0-cli-alpine3.16
RUN apk add --no-cache \
		openssh-server

RUN mkdir /var/run/sshd
RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN mkdir /root/.ssh

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]
