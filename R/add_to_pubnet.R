#' Function to add a new matrix of coauthorship to an existing matrix
#' 
#' This functions integrates a matrix of coauthorship from a new publication into an existing matrix. 
#' 
#' @param newpub matrix of coauthorships to be integrated into the existing matrix. 
#' @param data the existing matrix of coauthors<hip.
#' @param shape specify whether the matrix being imported is "symmetric" or "lower" triangle. Default is "symmetric".
#' @return a new matrix that combines the original data matrix with the new publication matrix.
#' @export

add_to_pubnet <- function(newpub,data,shape=c("symmetric","lower")) {
  shape <- match.arg(shape)
  #function to add a publication to an existing data matrix
  #MAY NEED TO ADD METHOD TO ALLOW FOR UPPER TRIANGLE. 
  #preparing environment
  makeSymm <- function(m) { #from https://stackoverflow.com/questions/33026183/r-make-symmetric-matrix-from-lower-diagonal
    #stopifnot("input is already symmetric" = m == t(m))
    m[upper.tri(m)] <- t(m)[upper.tri(m)]
    return(m)
  }
  #require(data.table) # apparently not allowed to do this in R functions
  
  #quality controls
  stopifnot("data is not a data.frame"=is.data.frame(data))
  stopifnot("new publication data is not a data frame"=is.data.frame(data))
  stopifnot("ID column missing from data"=colnames(data)[1]=="ID")
  stopifnot("ID column missing from new publication data frame"=colnames(newpub)[1]=="ID")
  
  if(shape=="symmetric") {
    #print("adding symmetrical matrices") #no transformation of data necessary
    stopifnot("data must be symmetric"= data[,-1] == t(data[,-1]))
    stopifnot("new publication data must be symmetric"= newpub[,-1] == t(newpub[,-1]))
  } else if(shape=="lower") {
    #warning(paste0("Converting lower triangle to symmetrical matrix. Note: output will be symmetrical.")) #data must be transformed to symmetrical first
    data<-cbind(data[,1],makeSymm(data[,-1])) #these are not truly symmetrical because of the NAs, but it is enough to work.
    colnames(data)[1]<-"ID"
    newpub<-cbind(newpub[,1],makeSymm(newpub[,-1])) #these are not truly symmetrical because of the NAs, but it is enough to work.
    colnames(newpub)[1]<-"ID"
    #stopifnot("conversion to symmetric failed on data"= data[,-1] == t(data[,-1])) #error does not work because of NAs on diagonal
    #stopifnot("conversion to symmetric failed on new pub"= newpub[,-1] == t(newpub[,-1])) #error doe snot work because of NAs on diagonal
  } else stop("upper triangle or asymmetrical input data currently not supported")
  
  q <- rbindlist(list(data, newpub),fill=TRUE)[, lapply(.SD, sum, na.rm = TRUE), by = ID] #this is where the magic happens. Source: https://stackoverflow.com/questions/47054901/merge-and-sum-two-different-data-tables
  return(q)
}