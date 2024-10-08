% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_coauthor_dataframe.R
\name{get_coauthor_dataframe}
\alias{get_coauthor_dataframe}
\title{Function to generate a dataframe of coauthorship}
\usage{
get_coauthor_dataframe(reflist, shape = c("symmetric", "lower"))
}
\arguments{
\item{reflist}{reference list to break down, imported via synthesisr::read_refs.}

\item{shape}{specify whether the matrix to output should be "symmetric" or "lower" triangle. Default is "symmetric".}
}
\value{
a symmetric data.frame of coauthorships among authors.
}
\description{
Generates a data.frame of coauthorship from a reference list imported via synthesisr::read_refs.
The function flags any publications that are single-authorships, and removes these from the dataset.
}
