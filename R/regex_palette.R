
#' Construct a vector from either the clipboard or a text string
#'
#' This function prepares the text for the regex_palette function
#'
#' @param text A character vector of length 1 or more. Takes the most recent value from the clipboard if the input is missing
#'
#' @return A character vector - which is either the text from the clipboard or the input text
vector_construct <- function(text){
  if(missing(text)){
    input_vector <- tryCatch({clipr::read_clip()},
                             error = function(e) {
                               return(NULL)
                             })
    input_vector <- paste0(input_vector,collapse = "\n")
    if(is.null(input_vector)){
      if(!clipr::clipr_available()) message("Clipboard is not available. Is xsel or xclip installed? Is DISPLAY set?")
      else message("Could not paste clipboard as a vector. Text could not be parsed.")
      return(NULL)
    }
  }
  input_vector
}


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

#' Convert palette to a vector representation
#'
#' @param text a vector with colour codes
#'
#' @return A string of length 1 - vector representation that starts with c


to_a_vector <- function(text){
  temp_vec <- c()
  for(i in 1:length(text)){
    if(i<length(text)){
      temp_vec <- paste0(temp_vec,paste0('"',noquote(text[[i]]),'"',","))
    } else {
      temp_vec <- paste0(temp_vec,paste0('"',noquote(text[[i]]),'"'))
    }
  }

  output_vec <- paste0("c(",temp_vec,")")
  output_vec
}

#' Converts a blob of text to a vector of colour palette
#'
#' @param text A character vector of length 1 or more.
#'
#' @return A colour palette string stored in a vector form
palette_paste <- function(text){

  construct_vector <- vector_construct(text)
  generate_pallete <- regex_palette(construct_vector)
  generate_vector <- to_a_vector(generate_pallete)
  rstudioapi::insertText(text = generate_vector)
}
