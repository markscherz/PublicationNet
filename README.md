# PublicationNet
R package for network plotting from lists of publications

![PublicationNetwork_2022-09-15](https://github.com/user-attachments/assets/6df8ee78-aebb-4572-9237-b966ce1b933f)

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
See [the vignette](vignettes/Usage.md) for usage of the core function, and plotting. Note: the network above uses a separately hand-coded list of countries of affiliation per author; you can do this by hand once you have generated the network, and use it as an aesthetic in the `ggraph` call.
