#' Function to generate a dataframe of coauthorship
#' 
#' Generates a data.frame of coauthorship from a reference list imported via synthesisr::read_refs. 
#' The function flags any publications that are single-authorships, and removes these from the dataset.
#' 
#' @param reflist reference list to break down, imported via synthesisr::read_refs. 
#' @param shape specify whether the matrix to output should be "symmetric" or "lower" triangle. Default is "symmetric".
#' @return a symmetric data.frame of coauthorships among authors.
#' @export

get_coauthor_dataframe <- function(reflist,shape=c("symmetric","lower")) {
  shape<-match.arg(shape)
  #loop for getting all coauthorship matrices from a reflist. 
  author.dfs <- list()
  for (i in 1:length(reflist)) {
    authors <- reflist[[i]]$author
    if(length(authors) == 1) {warning(paste0("Ignoring single-author publication, number ",i))} else {
      for (j in 1:length(authors)) { #This truncates author names to 'Surname, F.'
        space <- unlist(gregexpr(" ",authors[j]))
        authors[j] <- paste0(substr(authors[j],start = 1,stop=space+1),".",sep="")
      }
      n.authors <- length(authors)
      #create author correlation matrix for this publication
      author.matrix<-matrix(1,nrow=n.authors,ncol=n.authors) 
      diag(author.matrix)<-NA
      author.matrix[upper.tri(author.matrix)]<-NA # in principle this is unnecessary, can just work with symmetrical matrices. But downstream stuff was designed on lower triangle matrices.
      #convert to numeric data.frame
      author.df <- data.frame(cbind(authors,author.matrix))
      colnames(author.df)<- c("ID",authors)
      author.df[,c(2:(n.authors+1))]<-apply(author.df[,c(2:(n.authors+1))],2,function(x) as.numeric(as.character(x)))
      #store in list
      author.dfs[[i]] <- author.df
    }
  }
  
  #construct the final coauthorship matrix from the reflist
  for (i in 1:length(author.dfs)) {
    if(i == 1) {authornet <- as.data.frame(author.dfs[[1]])} else 
      if(is.null(author.dfs[[i]])) {warning(paste0("Null matrix detected for reference ",i,". It is probably a single-authorship and has been skipped",sep="")) } else {
        authornet<-add.to.pubnet(author.dfs[[i]],authornet,shape="lower") }
  }
  authornet<-as.data.frame(authornet)
  # isSymmetric(as.matrix(authornet[,c(2:length(authornet))]))
  # m<-as.matrix(authornet[,c(2:length(authornet))])
  # asymm_index = function(m) {
  #   which(m != t(m), arr.ind = TRUE)
  # }
  # asymm_index(m)
  row.names(authornet) <- authornet[,1]
  authornet<-authornet[,-1]
  authornet[diag(as.matrix(authornet))]
  if (shape == "symmetric") {return(authornet)} else if (shape == "lower") {
    authornet[upper.tri(authornet)]<-NA
    return(authornet)
  }
}