library(sodium)
library(dplyr)
library(mongolite)

source("scripts/id_gen.R")

log_d <- mongo(collection = "logins", url = 'mongodb+srv://rgraue:LoopDLoop@geoffcluster-3sd9t.azure.mongodb.net/test')

credentials <- log_d$find()


add_user <- function (username, password) {
  id <- get_random("UN", credentials)
  result <- data.frame(username = username, "passod" = password_store(password),
                       "permission" = "basic", username_id = id)
  log_d$insert(result)
  credentials <<- log_d$find()
}



 
