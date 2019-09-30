
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jabr

<!-- badges: start -->

<!-- badges: end -->

The goal of jabr is to browse, list, and fetch dataset from Open Data
Jawa Barat right from R.

## Installation

You can install the released version of jabr from
[GitHub](https://github.com/aswansyahputra/jabr) with:

``` r
# install.packages("remotes")
remotes::install_github("aswansyahputra/jabr")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(jabr)

(x <- jabr_list_dataset())
#> # A tibble: 1,565 x 4
#>    title              provider           last_updated url                  
#>    <chr>              <chr>              <date>       <chr>                
#>  1 PDRB ADHK di Prov… BADAN PUSAT STATI… 2019-09-25   https://data.jabarpr…
#>  2 PDRB ADHK di Prov… BADAN PUSAT STATI… 2019-09-25   https://data.jabarpr…
#>  3 PDRB ADHK di Prov… BADAN PUSAT STATI… 2019-09-25   https://data.jabarpr…
#>  4 PDRB ADHK di Prov… BADAN PUSAT STATI… 2019-09-25   https://data.jabarpr…
#>  5 PDRB ADHK di Prov… BADAN PUSAT STATI… 2019-09-25   https://data.jabarpr…
#>  6 Koperasi Aktif Be… DINAS KOPERASI DA… 2019-09-25   https://data.jabarpr…
#>  7 Luas Penanaman Po… DINAS KEHUTANAN    2019-09-25   https://data.jabarpr…
#>  8 Luas Penanaman Po… DINAS KEHUTANAN    2019-09-25   https://data.jabarpr…
#>  9 Luas Penanaman Po… DINAS KEHUTANAN    2019-09-25   https://data.jabarpr…
#> 10 Luas Penanaman Po… DINAS KEHUTANAN    2019-09-25   https://data.jabarpr…
#> # … with 1,555 more rows

pdrb_adhk <- 
  x %>% 
  dplyr::slice(1:5) %>% 
  jabr_fetch()

pdrb_adhk
#> # A tibble: 5 x 2
#>   title                                       dataset          
#>   <chr>                                       <list>           
#> 1 PDRB ADHK di Provinsi Jawa Barat Tahun 2013 <df[,5] [27 × 5]>
#> 2 PDRB ADHK di Provinsi Jawa Barat Tahun 2014 <df[,5] [27 × 5]>
#> 3 PDRB ADHK di Provinsi Jawa Barat Tahun 2015 <df[,5] [27 × 5]>
#> 4 PDRB ADHK di Provinsi Jawa Barat Tahun 2016 <df[,5] [27 × 5]>
#> 5 PDRB ADHK di Provinsi Jawa Barat Tahun 2017 <df[,5] [27 × 5]>

# You can then run `tidyr::unnest()` to expand the dataset
pdrb_adhk %>% 
  tidyr::unnest(dataset)
#> # A tibble: 135 x 6
#>    title       provinsi  kode_kota_kabup… nama_kota_kabup… pdrb_adhk satuan
#>    <chr>       <fct>                <int> <fct>                <int> <fct> 
#>  1 PDRB ADHK … JAWA BAR…             3204 KAB. BANDUNG         57691 MILIA…
#>  2 PDRB ADHK … JAWA BAR…             3217 KAB. BANDUNG BA…     22937 MILIA…
#>  3 PDRB ADHK … JAWA BAR…             3216 KAB. BEKASI         186207 MILIA…
#>  4 PDRB ADHK … JAWA BAR…             3201 KAB. BOGOR          110665 MILIA…
#>  5 PDRB ADHK … JAWA BAR…             3207 KAB. CIAMIS          16027 MILIA…
#>  6 PDRB ADHK … JAWA BAR…             3203 KAB. CIANJUR         22883 MILIA…
#>  7 PDRB ADHK … JAWA BAR…             3209 KAB. CIREBON         25042 MILIA…
#>  8 PDRB ADHK … JAWA BAR…             3205 KAB. GARUT           29138 MILIA…
#>  9 PDRB ADHK … JAWA BAR…             3212 KAB. INDRAMAYU       52859 MILIA…
#> 10 PDRB ADHK … JAWA BAR…             3215 KAB. KARAWANG       120295 MILIA…
#> # … with 125 more rows
```
