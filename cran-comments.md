## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub fedora-clang-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)

## R CMD check results
❯ On windows-x86_64-devel (r-devel), ubuntu-gcc-release (r-release)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: 'Muhammad Aswan Syahputra <muhammadaswansyahputra@gmail.com>'
  
  New submission
  
  Possibly mis-spelled words in DESCRIPTION:
    Barat (2:23, 10:5)
    Jawa (2:18, 9:58)
  
  Package has a VignetteBuilder field but no prebuilt vignette index.

❯ On fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ...NB: need Internet access to use CRAN incoming checks
   NOTE
  Maintainer: ‘Muhammad Aswan Syahputra <muhammadaswansyahputra@gmail.com>’
  
  Possibly mis-spelled words in DESCRIPTION:
    Barat (2:23, 10:5)
    Jawa (2:18, 9:58)
  
  Package has a VignetteBuilder field but no prebuilt vignette index.

0 errors ✔ | 0 warnings ✔ | 2 notes ✖

* This is a new release.
* There is a warning about mis-spelled words in DESCRIPTION. These words are spelled correctly.
