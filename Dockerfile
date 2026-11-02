# s2i-ubi8-php74-pdooci-libreoffice
# Base: defyma/s2i-ubi8-php74-pdooci (UBI8 PHP 7.4 + OCI8/PDO_OCI) + LibreOffice (headless convert).
# Pengganti defyma/s2i-fedora34-php74-pdooci-libreoffice (Fedora 34, EOL).
# App memanggil binary `libreoffice7.3`, jadi dibuat symlink kompatibel ke soffice versi baru.

ARG BASE_TAG=1792860909
FROM defyma/s2i-ubi8-php74-pdooci:${BASE_TAG}

ARG LO_VER=25.8.7
# Tarball di-vendor di bahan/ (download mirror sering putus di tengah build).
# Sumber: https://download.documentfoundation.org/libreoffice/stable/${LO_VER}/rpm/x86_64/
# Versi 26.x butuh glibc >= 2.34, UBI8 cuma 2.28 -> pakai 25.8.x.

LABEL maintainer="defyma85@gmail.com" \
      io.k8s.display-name="Apache 2.4 with PHP 7.4 + OCI8/PDO_OCI + LibreOffice (UBI8)" \
      io.openshift.tags="builder,php,php74,oci8,pdo_oci,libreoffice"

USER 0

COPY bahan/fonts/montserrat/ /usr/share/fonts/montserrat/
COPY bahan/LibreOffice_${LO_VER}_Linux_x86-64_rpm.tar.gz /tmp/lo.tar.gz

RUN dnf -y install --setopt=tsflags=nodocs \
      cups-libs libXinerama libSM libICE libXext libXrender libX11-xcb libxcb nss dbus-glib dbus-libs fontconfig cairo freetype \
      dejavu-sans-fonts dejavu-serif-fonts dejavu-sans-mono-fonts \
 && cd /tmp \
 && tar -xzf lo.tar.gz \
 && dnf -y install LibreOffice_${LO_VER}*_Linux_x86-64_rpm/RPMS/*.rpm \
 && dnf clean all \
 && rm -rf /tmp/lo.tar.gz /tmp/LibreOffice_* /var/cache/dnf \
 && LO_DIR=$(ls -d /opt/libreoffice* | head -1) \
 && ln -sf ${LO_DIR}/program/soffice /usr/bin/soffice \
 && ln -sf ${LO_DIR}/program/soffice /usr/bin/libreoffice7.3 \
 && fc-cache -f \
 && soffice --version

USER 1001
