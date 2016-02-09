combnPure <- function(g,k) {
  # check for errors
  if(k != round(k)) stop("k not an integer")
  if(k < 0) stop("k is negative")
  if(k > length(g)) stop("k > length(g)")
  
  if(k == 0) {
    return(list(NULL))
  } else if(length(g) == 1) {
    return(list(g))
  } else {
    return(combn(g,k,simplify = FALSE))
  }
}

combnGE <- function(g,k = 0) {
  # check for errors
  if(k != round(k)) stop("k not an integer")
  if(k < 0) stop("k is negative")
  if(k > length(g)) stop("k > length(g)")

  s <- NULL
  for(j in k:length(g)) {
    s <- c(s,combnPure(g,j))
  }
  return(s)
}

coupExact <- function(p,n,g = 0) {
  # check for errors, data types, and default values
  if(length(p) == 1) {
    if(p != round(p)) stop("Number of coupons must be an integer.")
    if(p < 2) stop("Must have at least 2 coupons.")
    p <- rep(1,p)
  } 
  p <- p/sum(p)
  if(n != round(n) || n <= 0)
    stop("Number of trials must be a positive integer.")
  if(identical(g,0)) g <- 1:length(p)
  if(!identical(g,intersect(g,1:length(p))))
    stop("g must be a nonempty subset of coupon indices")
  
  if(n < length(g)) return(0)
  q <- 0
  for(h in combnGE(g)) {
    q <- q + (-1)^(length(g) + length(h))*sum(p[h])^n
  }
  return(q)
}

coup <- function(p,n,k = 0,g = 0) {
  # check for errors, data types, and default values
  if(length(p) == 1) {
    if(p != round(p)) stop("Number of coupons must be an integer.")
    if(p < 2) stop("Must have at least 2 coupons.")
    p <- rep(1,p)
  } 
  p <- p/sum(p)
  if(n != round(n) || n <= 0)
    stop("Number of trials must be a positive integer.")
  if(identical(g,0)) g <- 1:length(p)
  if(!identical(g,intersect(g,1:length(p))))
    stop("g must be a subset of coupon indices")
  if(k == 0) k <- length(g)
  if(k != round(k) || k <= 0)
    stop("k must be a positive integer.")
  if(k > length(g)) stop("k > length(g)")

  A <- 1:length(p)
  q <- 0
  for(h in combnGE(g,k)) {
    for(hc in combnGE(A[-g])) {
      q <- q + coupExact(p,n,sort(c(h,hc)))
    }
  }
  return(q)
}