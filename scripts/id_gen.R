get_random <- function (prefix, df) {
  rand <- round(runif(1) * 100000000, digits = 0)
  id <- paste(prefix , rand , sep = "")
  if (is_unique(id, df) == TRUE) {
    return(id)
  } else {
    get_random(prefix, df)
  }
}

is_unique <- function (id, df){
  if(df[ncol(df)] == id) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

