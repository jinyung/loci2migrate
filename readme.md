# loci2migrate

[![Travis-CI Build Status](https://travis-ci.org/jinyung/loci2migrate.svg?branch=master)](https://travis-ci.org/jinyung/loci2migrate)
[![DOI](https://zenodo.org/badge/173910292.svg)](https://zenodo.org/badge/latestdoi/173910292)

## Download
Install the package and use:
```R
devtools::install_github("jinyung/loci2migrate")
```

Or just source the function:
```R
source('https://raw.githubusercontent.com/jinyung/loci2migrate/master/R/loci2migrate.R')
```

## Usage:

```R
loci2migrate(locipath, poppath, filename)
```

Where,

|  |  |
| ----------- | ----------------------------------------------- |
| `locipath`  | (char) path to `.loci` to be converted          |
| `poppath`   | (char) path to file contains population info \* |
| `filename`  | (char) path for output file                     |

\* This should be a tab delimited file with the first column as individuals' 
labels and the second column as the population label. E.g.

```
Ind1  Pop1
Ind2  Pop1
Ind3  Pop1
Ind4  Pop2
Ind5  Pop2
Ind6  Pop2
Ind7  Pop3
Ind8  Pop3
Ind9  Pop3
```
 