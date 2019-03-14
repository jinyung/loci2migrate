\name{loci2migrate}
\alias{loci2migrate}
\title{From Loci to Migrate}
\description{Convert ipyrad's output file (*.loci) into migrate-n's input file}
\usage{
loci2migrate(locipath, poppath, filename)
}
\arguments{
  \item{locipath}{(char) path to *.loci to be converted}
  \item{poppath}{(char) path to file contains population info, which the first 
    column is the individuals' labels and the second column is the population 
    label. The file should be tab delimited.}
  \item{filename}{(char) path for output file}
}
\value{
a converted file
}
\details{
if any locus is not found in all the populations, it will be determined as
"missing locus" and removed. You can find which locus are removed in the 
metadata header of the converted file.
}
 