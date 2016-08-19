SHELL := /bin/bash

# Dependency Versions
VERSION?=1.3.4
RELEASEVER?=1

# Bash data
SCRIPTPATH=$(shell pwd -P)
CORES=$(shell grep -c ^processor /proc/cpuinfo)
RELEASE=$(shell lsb_release --codename | cut -f2)

major=$(shell echo $(VERSION) | cut -d. -f1)
minor=$(shell echo $(VERSION) | cut -d. -f2)
micro=$(shell echo $(VERSION) | cut -d. -f3)

build: clean libksba

clean:
	rm -rf /tmp/libksba-$(VERSION)
	rm -rf /tmp/libksba-$(VERSION).tar.bz2

libksba:
	cd /tmp && \
	wget ftp://ftp.gnupg.org/gcrypt/libksba/libksba-$(VERSION).tar.bz2 && \
	tar -xf libksba-$(VERSION).tar.bz2 && \
	cd libksba-$(VERSION) && \
	mkdir -p /usr/share/man/libksba/$(VERSION) && \
	./configure \
	    --prefix=/usr/local \
	    --mandir=/usr/share/man/libksba/$(VERSION) \
	    --infodir=/usr/share/info/libksba/$(VERSION) \
	    --docdir=/usr/share/doc/libksba/$(VERSION) && \
	make -j$(CORES) && \
	make install


fpm_debian:
	echo "Packaging libksba for Debian"

	cd /tmp/libksba-$(VERSION) && make install DESTDIR=/tmp/libksba-$(VERSION)-install

	fpm -s dir \
		-t deb \
		-n libksba \
		-v $(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2) \
		-C /tmp/libksba-$(VERSION)-install \
		-p libksba_$(VERSION)-$(RELEASEVER)~$(shell lsb_release --codename | cut -f2)_$(shell arch).deb \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/libksba-build \
		--description "libksba" \
		--deb-systemd-restart-after-upgrade

fpm_rpm:
	echo "Packaging libksba for RPM"

	cd /tmp/libksba-$(VERSION) && make install DESTDIR=/tmp/libksba-$(VERSION)-install

	fpm -s dir \
		-t rpm \
		-n libksba \
		-v $(VERSION)_$(RELEASEVER) \
		-C /tmp/libksba-$(VERSION)-install \
		-p libksba_$(VERSION)-$(RELEASEVER)_$(shell arch).rpm \
		-m "charlesportwoodii@erianna.com" \
		--license "GPLv3" \
		--url https://github.com/charlesportwoodii/libksba-build \
		--description "libksba" \
		--vendor "Charles R. Portwood II" \
		--rpm-digest sha384 \
		--rpm-compression gzip