Usage of PublicationNet
================

``` r
library(PublicationNet)
#> Loading required package: synthesisr
#> Loading required package: data.table
#> Loading required package: reshape2
#> 
#> Attaching package: 'reshape2'
#> The following objects are masked from 'package:data.table':
#> 
#>     dcast, melt
#> Loading required package: igraph
#> 
#> Attaching package: 'igraph'
#> The following objects are masked from 'package:stats':
#> 
#>     decompose, spectrum
#> The following object is masked from 'package:base':
#> 
#>     union
#> Loading required package: tidygraph
#> 
#> Attaching package: 'tidygraph'
#> The following object is masked from 'package:igraph':
#> 
#>     groups
#> The following object is masked from 'package:stats':
#> 
#>     filter
#> Loading required package: ggraph
#> Loading required package: ggplot2
```

PublicationNet is a package designed to automate the process of taking a
publication list in .RIS format (.txt ending is fine) and generating a
network from it, for instance for inclusion in a CV, or as an overview
of connectedness among a list of publications. It depends on a host of
other packages for the heavy lifting of RIS import and network
generation and plotting. Consequently, the built-in functions need to be
used together with commands from some of these other packages.

First, you must import a reference list.

``` r
refs <- synthesisr::read_refs(
  "path/to/ris.txt",
  tag_naming = "best_guess",
  return_df = FALSE,
  verbose = TRUE
)
```

From this you can generate the network and a tally of occurrences of
each coauthor in the list in a single step

``` r
conet<-coauthor_network(refs)
```

Then you can plot this with ggraph.

``` r
ggraph(conet$network, layout = "fr") + #layout="graphopt" is also okay 
  geom_edge_link(aes(width = weight), alpha = 0.8) + 
  scale_edge_width(range = c(0.05, 2)) +
  geom_node_point(aes(size = conet$coauthored$Occurrences),colour="#af0c28") + 
  scale_color_viridis_d()+
  geom_node_text(aes(label = name,size=10), colour="black",repel = TRUE,show.legend=FALSE) +
  labs(edge_width = "Shared Publications",size = "Number of Publications Coauthored") +
  theme_graph()+  
  theme(text = element_text(family = "Arial"))+
  theme(legend.position="bottom", legend.box = "horizontal")
```

On dense networks, you will lose a lot of author names; to keep all and
allow graphical editing in a vector-editing software, try

``` r
ggraph(conet$network, layout = "nicely") + 
  geom_edge_link(aes(width = weight), alpha = 0.8) + 
  scale_edge_width(range = c(0.05, 2)) +
  geom_node_point(aes(size = conet$coauthored$Occurrences),colour="#af0c28") +
  scale_color_viridis_d()+
  geom_node_text(aes(label = name,size=10), repel = FALSE,show.legend=FALSE) +
  labs(edge_width = "Shared Publications",size = "Number of Publications Coauthored") +
  theme_graph()+
  theme(text = element_text(family = "Arial"))+
  theme(legend.position="bottom", legend.box = "horizontal")
```
