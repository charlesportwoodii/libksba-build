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
	mkdir -p /usr/share/man/libksba-$(VERSION) && \
	./configure \
	    --prefix=/usr/local \
	    --mandir=/usr/share/man/libksba-$(VERSION) \
	    --infodir=/usr/share/info/libksba-$(VERSION) \
	    --docdir=/usr/share/doc/libksba-$(VERSION) && \
	make -j$(CORES) && \
	make install

package:
	cd /tmp/libksba-$(VERSION) && \
	checkinstall \
	    -D \
	    --fstrans \
	    -pkgrelease "$(RELEASEVER)"-"$(RELEASE)" \
	    -pkgrelease "$(RELEASEVER)"~"$(RELEASE)" \
	    -pkgname "libksba" \
	    -pkglicense GPLv3 \
	    -pkggroup GPG \
	    -maintainer charlesportwoodii@ethreal.net \
	    -provides "libksba-$(VERSION)" \
	    -pakdir /tmp \
	    -y
