
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jabr

<!-- badges: start -->

<!-- badges: end -->

The goal of jabr is to browse, list, and fetch dataset from Open Data
Jawa Barat right from R.

## Installation

You can install the released version of jabr from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("jabr")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("aswansyahputra/jabr")
```

## Examples

This is a basic example which shows you how to solve a common problem:

### Fetch single dataset

``` r
library(jabr)

(x <- jabr_list_dataset())
#> # A tibble: 1,516 x 5
#>    id     title                provider    last_modified url                    
#>    <chr>  <chr>                <chr>       <date>        <chr>                  
#>  1 d3c36… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  2 f9957… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  3 db602… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  4 cfd19… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  5 f90fb… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  6 ff53e… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  7 be7af… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  8 4c272… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  9 df7f3… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#> 10 67920… Angka Harapan Lama … Badan Pusa… 2019-09-25    https://data.jabarprov…
#> # … with 1,506 more rows

# suppose that we want to get dataset about "Jumlah Desa Siaga Di Provinsi Jawa Barat 2018".
# Id of this data is "88ef59c5".

jabr_fetch("88ef59c5")
#> # A tibble: 107 x 7
#>    title provinsi kode_kota_kabup… nama_kota_kabup… jenis_desa_kelu… jumlah
#>    <chr> <chr>               <int> <chr>            <chr>             <int>
#>  1 Juml… JAWA BA…             3204 KAB. BANDUNG     PRATAMA              28
#>  2 Juml… JAWA BA…             3204 KAB. BANDUNG     MADYA               114
#>  3 Juml… JAWA BA…             3204 KAB. BANDUNG     PURNAMA             117
#>  4 Juml… JAWA BA…             3204 KAB. BANDUNG     MANDIRI              21
#>  5 Juml… JAWA BA…             3217 KAB. BANDUNG BA… PRATAMA              15
#>  6 Juml… JAWA BA…             3217 KAB. BANDUNG BA… MADYA                98
#>  7 Juml… JAWA BA…             3217 KAB. BANDUNG BA… PURNAMA              36
#>  8 Juml… JAWA BA…             3217 KAB. BANDUNG BA… MANDIRI              15
#>  9 Juml… JAWA BA…             3216 KAB. BEKASI      PRATAMA             158
#> 10 Juml… JAWA BA…             3216 KAB. BEKASI      MADYA                26
#> # … with 97 more rows, and 1 more variable: satuan <chr>

## optionally, you can also remove the 'title' column
desa_siaga <- jabr_fetch("88ef59c5", keep_title = FALSE)
desa_siaga
#> # A tibble: 107 x 6
#>    provinsi  kode_kota_kabupa… nama_kota_kabupa… jenis_desa_kelu… jumlah satuan 
#>    <chr>                 <int> <chr>             <chr>             <int> <chr>  
#>  1 JAWA BAR…              3204 KAB. BANDUNG      PRATAMA              28 DESA/K…
#>  2 JAWA BAR…              3204 KAB. BANDUNG      MADYA               114 DESA/K…
#>  3 JAWA BAR…              3204 KAB. BANDUNG      PURNAMA             117 DESA/K…
#>  4 JAWA BAR…              3204 KAB. BANDUNG      MANDIRI              21 DESA/K…
#>  5 JAWA BAR…              3217 KAB. BANDUNG BAR… PRATAMA              15 DESA/K…
#>  6 JAWA BAR…              3217 KAB. BANDUNG BAR… MADYA                98 DESA/K…
#>  7 JAWA BAR…              3217 KAB. BANDUNG BAR… PURNAMA              36 DESA/K…
#>  8 JAWA BAR…              3217 KAB. BANDUNG BAR… MANDIRI              15 DESA/K…
#>  9 JAWA BAR…              3216 KAB. BEKASI       PRATAMA             158 DESA/K…
#> 10 JAWA BAR…              3216 KAB. BEKASI       MADYA                26 DESA/K…
#> # … with 97 more rows
```

### Fetch multiple datasets

``` r
library(jabr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(stringr)
library(tidyr)

(x <- jabr_list_dataset())
#> # A tibble: 1,516 x 5
#>    id     title                provider    last_modified url                    
#>    <chr>  <chr>                <chr>       <date>        <chr>                  
#>  1 d3c36… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  2 f9957… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  3 db602… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  4 cfd19… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  5 f90fb… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  6 ff53e… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  7 be7af… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  8 4c272… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#>  9 df7f3… Angka Harapan Hidup… Badan Pusa… 2019-09-25    https://data.jabarprov…
#> 10 67920… Angka Harapan Lama … Badan Pusa… 2019-09-25    https://data.jabarprov…
#> # … with 1,506 more rows


# suppose that we want to get the datasets about "Angka Harapan Hidup".
# There are several datasets available in the list (one dataset per observation year).

## Step 1. List the ids of datasets that fall within same category.
## We can check and write the ids manualy, or using filtering technique.
ids <- 
  x %>%
  dplyr::filter(stringr::str_detect(title, "Angka Harapan Hidup")) %>% 
  dplyr::pull(id)
ids
#> [1] "d3c36780" "f9957463" "db602753" "cfd19fb1" "f90fb4d1" "ff53ea3c" "be7afefd"
#> [8] "4c272d3d" "df7f3aaf"

## Step 2. Fetch the datasets using the ids.
ahh_jabar_raw <- 
  jabr_fetch(id = ids)
ahh_jabar_raw
#> # A tibble: 9 x 2
#>   title                                                     dataset          
#>   <chr>                                                     <list>           
#> 1 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2010 <df[,5] [27 × 5]>
#> 2 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2011 <df[,5] [27 × 5]>
#> 3 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2012 <df[,5] [27 × 5]>
#> 4 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2013 <df[,5] [27 × 5]>
#> 5 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2014 <df[,5] [27 × 5]>
#> 6 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2015 <df[,5] [27 × 5]>
#> 7 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2016 <df[,5] [27 × 5]>
#> 8 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2017 <df[,5] [27 × 5]>
#> 9 Angka Harapan Hidup Berdasarkan Kota Kabupaten Tahun 2018 <df[,5] [27 × 5]>

## Step 3. Expand/unnest the datasets.
ahh_jabar <- 
  ahh_jabar_raw %>% 
  tidyr::unnest(dataset)
ahh_jabar
#> # A tibble: 243 x 6
#>    title      provinsi kode_kota_kabup… nama_kota_kabup… angka_harapan_h… satuan
#>    <chr>      <chr>               <int> <chr>                       <dbl> <chr> 
#>  1 Angka Har… JAWA BA…             3204 KAB. BANDUNG                 72.9 TAHUN 
#>  2 Angka Har… JAWA BA…             3217 KAB. BANDUNG BA…             71.5 TAHUN 
#>  3 Angka Har… JAWA BA…             3216 KAB. BEKASI                  72.9 TAHUN 
#>  4 Angka Har… JAWA BA…             3201 KAB. BOGOR                   70.3 TAHUN 
#>  5 Angka Har… JAWA BA…             3207 KAB. CIAMIS                  70.0 TAHUN 
#>  6 Angka Har… JAWA BA…             3203 KAB. CIANJUR                 68.8 TAHUN 
#>  7 Angka Har… JAWA BA…             3209 KAB. CIREBON                 71.1 TAHUN 
#>  8 Angka Har… JAWA BA…             3205 KAB. GARUT                   70.3 TAHUN 
#>  9 Angka Har… JAWA BA…             3212 KAB. INDRAMAYU               70.0 TAHUN 
#> 10 Angka Har… JAWA BA…             3215 KAB. KARAWANG                71.3 TAHUN 
#> # … with 233 more rows

## Step 4. (optional) Perform some data cleaning.
ahh_jabar <- 
  ahh_jabar %>% 
  tidyr::extract(title, "tahun", "(\\d{4})", convert = TRUE)
ahh_jabar
#> # A tibble: 243 x 6
#>    tahun provinsi  kode_kota_kabupat… nama_kota_kabupa… angka_harapan_hi… satuan
#>    <int> <chr>                  <int> <chr>                         <dbl> <chr> 
#>  1  2010 JAWA BAR…               3204 KAB. BANDUNG                   72.9 TAHUN 
#>  2  2010 JAWA BAR…               3217 KAB. BANDUNG BAR…              71.5 TAHUN 
#>  3  2010 JAWA BAR…               3216 KAB. BEKASI                    72.9 TAHUN 
#>  4  2010 JAWA BAR…               3201 KAB. BOGOR                     70.3 TAHUN 
#>  5  2010 JAWA BAR…               3207 KAB. CIAMIS                    70.0 TAHUN 
#>  6  2010 JAWA BAR…               3203 KAB. CIANJUR                   68.8 TAHUN 
#>  7  2010 JAWA BAR…               3209 KAB. CIREBON                   71.1 TAHUN 
#>  8  2010 JAWA BAR…               3205 KAB. GARUT                     70.3 TAHUN 
#>  9  2010 JAWA BAR…               3212 KAB. INDRAMAYU                 70.0 TAHUN 
#> 10  2010 JAWA BAR…               3215 KAB. KARAWANG                  71.3 TAHUN 
#> # … with 233 more rows
```
