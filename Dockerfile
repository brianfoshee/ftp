FROM golang:1.6.0

RUN mkdir --mode 0777 -p /var/ftp/incoming
RUN mkdir -p /var/run/vsftpd/empty
RUN mkdir -p $GOPATH/src/github.com/jlaffaye/ftp

WORKDIR $GOPATH/src/github.com/jlaffaye/ftp

RUN go get github.com/axw/gocov/gocov
RUN go get github.com/mattn/goveralls

RUN apt-get update && apt-get install -y --no-install-recommends vsftpd && apt-get clean

RUN echo "local_enable=YES" >> /etc/vsftpd.conf
RUN echo "anon_root=/var/ftp" >> /etc/vsftpd.conf
RUN echo "anon_upload_enable=YES" >> /etc/vsftpd.conf
RUN echo "anonymous_enable=YES" >> /etc/vsftpd.conf
RUN echo "dirmessage_enable=YES" >> /etc/vsftpd.conf
RUN echo "anon_umask=022" >> /etc/vsftpd.conf
RUN echo "anon_mkdir_write_enable=YES" >> /etc/vsftpd.conf
RUN echo "anon_other_write_enable=YES" >> /etc/vsftpd.conf
RUN echo "secure_chroot_dir=/var/run/vsftpd/empty" >> /etc/vsftpd.conf
RUN echo "listen_ipv6=YES" >> /etc/vsftpd.conf
RUN echo "chroot_local_user=YES" >> /etc/vsftpd.conf
RUN echo "allow_writeable_chroot=YES" >> /etc/vsftpd.conf
RUN echo "write_enable=YES" >> /etc/vsftpd.conf
RUN echo "background=YES" >> /etc/vsftpd.conf
RUN echo "local_umask=022" >> /etc/vsftpd.conf

EXPOSE 21

COPY ./ .

CMD ["./test.sh"]
