#' Sends a message to room in Hangouts Chat using a configured webhook
#' @param url Character string with the full Webhook URL for a Hangouts Chat room
#' @param message Character string to be sent to Hangouts Chat
#' @return POST results
#' @description Send a message to a room in Hangouts Chat
#' @export

hangouts_chat_message <- function(url, message) {
  message <- as.character(message)
  message <- stringr::str_replace_all(message, "'", "\\\\u0027")
  stopifnot(is.character(url), nchar(message) > 0)
  header <- httr::add_headers(c("Content-Type" = "application/json", "charset" = "UTF-8"))
  httr::POST(url, header, body = paste0("{'text' : '", message, "'}"))
}
