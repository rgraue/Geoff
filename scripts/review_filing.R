library(mongolite)

source("scripts/id_gen.R")

review_d <- mongo(collection = "reviews", url = "mongodb+srv://rgraue:LoopDLoop@geoffcluster-3sd9t.azure.mongodb.net/")

review_d$insert(reviews)

reviews <- review_d$find()


add_review <- function(user_id, review, rating, date, rest_id) {
  id <- get_random("RV", reviews)
  result <- data.frame(username_id = user_id, "review" = review, "rating" = rating,
                       "date" = date, "restroom_id" = rest_id, "review_id" = id )
  review_d$insert(result)
  reviews <- review_d$find
}