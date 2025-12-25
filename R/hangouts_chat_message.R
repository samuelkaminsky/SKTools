#' Sends a message to room in Hangouts Chat using a configured webhook
#' @param url Character string with the full Webhook URL for a Hangouts Chat room
#' @param message Character string to be sent to Hangouts Chat
#' @return POST results
#' @description Send a message to a room in Hangouts Chat
#' @export

hangouts_chat_message <- function(url, message) {
  stopifnot(is.character(url), nchar(as.character(message)) > 0)
  header <- httr::add_headers(c(
    "Content-Type" = "application/json",
    "charset" = "UTF-8"
  ))

  body <- jsonlite::toJSON(
    list(text = as.character(message)),
    auto_unbox = TRUE
  )
  httr::POST(url, header, body = body)
}
