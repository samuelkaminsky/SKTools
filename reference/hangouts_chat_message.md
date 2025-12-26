# Sends a message to room in Hangouts Chat using a configured webhook

Send a message to a room in Hangouts Chat

## Usage

``` r
hangouts_chat_message(url, message)
```

## Arguments

- url:

  Character string with the full Webhook URL for a Hangouts Chat room

- message:

  Character string to be sent to Hangouts Chat

## Value

POST results

## Examples

``` r
if (FALSE) { # \dontrun{
hangouts_chat_message("https://chat.googleapis.com/...", "Hello World")
} # }
```
