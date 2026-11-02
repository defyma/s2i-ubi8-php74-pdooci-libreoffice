PHP 7.4 UBI8 s2i image + OCI8/PDO_OCI + LibreOffice
===================================================

Built on top of [`defyma/s2i-ubi8-php74-pdooci`](../s2i-ubi8-php74-pdooci) (RHEL 8.10, PHP 7.4.33, oci8, pdo_oci),
with LibreOffice installed for headless document conversion (`--headless --convert-to pdf`).

Replaces `defyma/s2i-fedora34-php74-pdooci-libreoffice`. That image is based on Fedora 34, which is EOL.

- `libreoffice7.3` is a compatibility symlink to the new `soffice`, so existing app code keeps working.
- Fonts: DejaVu (sans/serif/mono) + Montserrat (copied from the old image).

Docker Hub: `defyma/s2i-ubi8-php74-pdooci-libreoffice` (linux/amd64)

| Tag          | Base `s2i-ubi8-php74-pdooci` | LibreOffice |
|--------------|------------------------------|-------------|
| `1792860909` | `1792860909`                 | 25.8.7      |
| `latest`     | latest build                 |             |

Build & Push
------------
```
./build.sh                          # base 1792860909, LibreOffice 25.8.7
./build.sh <base-tag> <lo-version>  # rebuild after base / LibreOffice patch
NO_PUSH=1 ./build.sh                # build + check only
```

Notes
-----
- LibreOffice tarball is vendored in `bahan/` (gitignored, ~233 MB). Download it before building:
  `curl -fLO --output-dir bahan https://download.documentfoundation.org/libreoffice/stable/25.8.7/rpm/x86_64/LibreOffice_25.8.7_Linux_x86-64_rpm.tar.gz`
- LibreOffice 26.x needs glibc >= 2.34. UBI8 ships 2.28, so stay on 25.8.x.
