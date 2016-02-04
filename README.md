# libksba build

This repository allows you to build and package libksba

## Dependencies

```
apt-get install build-essential libgmp-dev libunbound-dev m4
```

# Building and Packaging
```
git clone https://github.com/charlesportwoodii/libksba-build
cd libksba-build

sudo make VERSION=<version>
# deb packages can be built with
# sudo make package VERSION=<version>
```
