# libheif-d
D bindings for libheif.

Version 1.12.0 (2021-05-05). C headers available in the c directory.

Show more details. 
https://github.com/strukturag/libheif

---

# libheif

[![Build Status](https://github.com/strukturag/libheif/workflows/build/badge.svg)](https://github.com/strukturag/libheif/actions) [![Build Status](https://ci.appveyor.com/api/projects/status/github/strukturag/libheif?svg=true)](https://ci.appveyor.com/project/strukturag/libheif) [![Coverity Scan Build Status](https://scan.coverity.com/projects/16641/badge.svg)](https://scan.coverity.com/projects/strukturag-libheif)


libheif is an ISO/IEC 23008-12:2017 HEIF and AVIF (AV1 Image File Format) file format decoder and encoder.

HEIF and AVIF are new image file formats employing HEVC (h.265) or AV1 image coding, respectively, for the
best compression ratios currently possible.

libheif makes use of [libde265](https://github.com/strukturag/libde265) for HEIF image decoding and x265 for encoding.
For AVIF, libaom, dav1d, or rav1e are used as codecs.


## Supported features

libheif has support for decoding
* tiled images
* alpha channels
* thumbnails
* reading EXIF and XMP metadata
* reading the depth channel
* multiple images in a file
* image transformations (crop, mirror, rotate)
* overlay images
* plugin interface to add alternative codecs for additional formats (AVC, JPEG)
* decoding of files while downloading (e.g. extract image size before file has been completely downloaded)
* reading color profiles
* heix images (10 and 12 bit, chroma 4:2:2)

The encoder supports:
* lossy compression with adjustable quality
* lossless compression
* alpha channels
* thumbnails
* save multiple images to a file
* save EXIF and XMP metadata
* writing color profiles
* 10 and 12 bit images
* monochrome images
