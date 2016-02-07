coup <- function(p,g,n) {
  p <- p/sum(p)
  L <- length(g)
  q <- 0
  for(j in 1:(2^L-1)) {
    s <- which(intToBits(j) %in% "01")
    q <- q + (-1)^(L + length(s))*sum(p[g[s]])^n
  }
  return(q)
}

coupx <- function(p,g,k,n) {
  A <- 1:length(p)
  L <- length(g)
  gc <- A[-g]
  Lc <- length(gc)
  if(L == 1) {
    return(1-sum(p[gc])^n)
  } else {
    q <- 0
    for(m in k:L) {
      s <- combn(g,m)
      for(j in 1:choose(L,m)) {
        if(Lc == 1) {
          q <- q + coup(p,s[,j],n) + coup(p,sort(c(s[,j],gc)),n)
        } else {
          for(mc in 0:Lc) {
            if(mc > 0) {
              sc <- combn(gc,mc)
              for(jc in 1:choose(Lc,mc)) {
                h <- sort(c(s[,j],sc[,jc]))
                q <- q + coup(p,h,n)
              }
            } else {
              q <- q + coup(p,s[,j],n)
            }
          }
        }
      }
    }
    return(q)
  }
}
