#' Function to produce a network from a reflist
#' 
#' @description
#' Core function to produce a network and a coauthorship list from a network of coauthorships.
#' The function internally calls [get_coauthor_dataframe()], which flags any publications that are
#' single-authorships, and removes these from the dataset; and [coauthor_list()], which gives the
#' total number of occurrences of each author in the reference list.
#' 
#' @param reflist reference list to break down, imported via synthesisr::read_refs.
#' @returns A list comprising two elements: `network`, a tidygraph tbl_graph that can be used for plotting purposes; 
#' and `coauthored`, a tibble of author occurence in reflist.
#' @export

coauthor_network <- function(reflist) {
  coauthor.df<-get_coauthor_dataframe(reflist=reflist,shape="symmetric")
  output <- list()
  stopifnot("input data.frame must be symmetrical"=isSymmetric(as.matrix(coauthor.df)) == "TRUE")

  #make the network
  m <- as.matrix(coauthor.df)
  diag(m) <- 0
  g <- igraph::graph_from_adjacency_matrix(m, mode="undirected", weighted=T)
  m_tidy <- tidygraph::as_tbl_graph(g)
  output[["network"]] <- m_tidy
  
  #also return the coauthor list, which is useful for setting aesthetics when plotting.
  coauthorlist <- coauthor_list(reflist,sort="default")
  output[["coauthored"]] <- as_tibble(coauthorlist)
  
  message("success! Drinks all around!")
  
  return(output)
}