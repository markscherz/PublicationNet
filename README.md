# PublicationNet
R package for network plotting from lists of publications

PublicationNet is a package designed to automate the process of taking a publication list in .RIS format (.txt ending is fine) and generating a network from it, for instance for inclusion in a CV, or as an overview of connectedness among a list of publications. It depends on a host of other packages for the heavy lifting of RIS import and network generation and plotting. Consequently, the built-in functions need to be used together with commands from some of these other packages.

# Dependencies
```
R (>= 3.1.0)
synthesisr
data.table
reshape2
igraph
tidygraph
ggraph
```
# Install PublicationNet in your R console
`devtools::install_github("markscherz/PublicationNet")`

# Activate PublicationNet
`library(PublicationNet)`

# Usage
See [the vignette](vignettes/Usage.Rmd) for usage of the core function, and plotting.
