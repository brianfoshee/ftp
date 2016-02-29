#!/bin/sh

vsftpd /etc/vsftpd.conf

go test -v
