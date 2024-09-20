#' Function to get a coauthor list from a reference list
#' 
#' Gets a list of all coauthors and the number of occurrences, from a bibliography imported via the 
#' "synthesisr" package. 
#' 
#' @param reflist reference list to break down, imported via synthesisr::read_refs. 
#' @param sort how to sort the data.frame. Options: "default" to sort by the reflist authors (required for network analysis), 
#' "author" to sort by surname, or "pubnumber" to sort by the number of occurrences. 
#' @return a data.frame of authors and the number of occurrences in 'reflist'.
#' @export

coauthor_list <- function(reflist,sort=c("default","author","pubnumber")) {
  sort<-match.arg(sort)
  #Currently it is done with a matrix. It would be much much nicer to use lists.
  authorlist <- matrix(nrow = 1,ncol = 2)
  colnames(authorlist) <- c("Author","Occurrences")
  for (i in 1:length(reflist)) {
    for (j in 1:length(reflist[[i]]$author)) {
      truncauthor <- paste0(substr(reflist[[i]]$author[j],start = 1,stop=unlist(gregexpr(",",reflist[[i]]$author[j]))+2),".",sep="") #truncates the author name to Surname, F.
      if(truncauthor %in% authorlist[,1] == FALSE) {
        authorlist <- rbind(c(truncauthor,1),authorlist)
      } else 
        authorlist[which(authorlist[,1] == truncauthor),2] <- as.numeric(as.character(authorlist[which(authorlist[,1] == truncauthor),2]))+1 #ADD 1 TO THE RESPECTIVE ROW
    }
  }
  authorlist<-as.data.frame(authorlist)
  authorlist[,2]<-as.numeric(as.character(authorlist[,2]))
  authorlist<-na.omit(authorlist)
  if(sort == "default") {authorlist <- authorlist[rev(row.names(authorlist)),]} else # in reality we flip the original order, because if we don't it doesn't match the network.
    if(sort == "author") {authorlist <- authorlist[order(authorlist$Author,decreasing=FALSE, na.last=FALSE),]} else
      if(sort == "pubNumber") {authorlist <- authorlist[order(authorlist$Occurrences,decreasing=FALSE, na.last=FALSE),]} else {authorlist<-authorlist}
  warning("Remember to inspect your coauthor list for duplicates, and fix these in the original bibliography file",call. = FALSE)
  return(authorlist)
}
