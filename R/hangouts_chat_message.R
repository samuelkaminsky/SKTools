#' Sends a message to room in Hangouts Chat using a configured webhook
#' @param url Character string with the full Webhook URL
#' @param message Character string to be sent to Hangouts Chat, does not accept strings with apostrophes
#' @return POST results
#' @description Send a message to a room in Hangouts Chat
#' @export

hangouts_chat_message <- function(url, message) {
  header <- httr::add_headers(c('Content-Type' = "application/json",
                                'charset' = 'UTF-8'))
  # message <- stringr::str_replace_all(message, "'", "\'")
  # message <- stringr::str_replace_all(message, '"', '\\"')
  # message <- stringr::str_replace_all(message, "[\n\r]", ' ')
  # if (is.null(url)) {
    stopifnot(is.character(url), is.character(message))
    # message("No URL")
    # return(invisible())
  # }
  
  httr::POST(url,
             header,
             body = paste0("{'text' : '", message, "'}"))
}
