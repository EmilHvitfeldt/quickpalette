#' Extracts a color palette from a string
#'
#' This function takes rather messy strings and extracts the color palette
#' presented as hexadesimals and returns them as a string.
#'
#' @param text A character vector of length 1 or more.
#' @return A color palette as a string or a list of strings depending on the input.
#' @examples
#' text1 <- "3b59988b9dc3dfe3eef7f7f7ffffff"
#' text2 <- "the palatte is #3472bc, #345682 then #112233 and finally #cbac43"
#'
#' # Returns vector when input is of length 1
#' regex_palette(text1)
#' regex_palette(text2)
#'
#' text3 <- c("3b59988b9dc3dfe3eef7f7f7ffffff", "3b59988b9dc3dfe3eef7f7f7ffffff")
#'
#' regex_palette(text3)
#' @export
regex_palette <- function(text) {
  palettes <- stringr::str_extract_all(text, "[0-9A-Fa-f]{6}") %>%
    lapply(function(x) stringr::str_c("#", x)) %>%
    lapply(function(x) ifelse(x == "#", NA, x))

  if(length(palettes) == 1) {
    return(unlist(palettes))
  }

  palettes
}
