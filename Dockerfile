FROM golang:1.6.0

RUN mkdir --mode 0777 -p /var/ftp/incoming
RUN mkdir -p /var/run/vsftpd/empty
RUN mkdir -p $GOPATH/src/github.com/jlaffaye/ftp

WORKDIR $GOPATH/src/github.com/jlaffaye/ftp

RUN go get github.com/axw/gocov/gocov
RUN go get github.com/mattn/goveralls

RUN apt-get update && apt-get install -y --no-install-recommends vsftpd && apt-get clean

RUN { \
  echo "local_enable=YES" ; \
  echo "anon_root=/var/ftp"; \
  echo "anon_upload_enable=YES"; \
  echo "anonymous_enable=YES"; \
  echo "dirmessage_enable=YES"; \
  echo "anon_umask=022"; \
  echo "anon_mkdir_write_enable=YES"; \
  echo "anon_other_write_enable=YES"; \
  echo "secure_chroot_dir=/var/run/vsftpd/empty"; \
  echo "listen_ipv6=YES"; \
  echo "chroot_local_user=YES"; \
  echo "allow_writeable_chroot=YES"; \
  echo "write_enable=YES"; \
  echo "background=YES"; \
  echo "local_umask=022"; \
} > /etc/vsftpd.conf

RUN { \
  echo "#!/bin/sh"; \
  echo "vsftpd /etc/vsftpd.conf"; \
  echo "goveralls"; \
} > test.sh

RUN chmod +x test.sh

EXPOSE 21

COPY ./ .

CMD ["./test.sh"]
