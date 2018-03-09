#' Extracts a color palette from a image by url
#'
#' Main utility of this function is to extract the color palette used in a
#' chart online.
#'
#' This function takes lets you skip the trouble it takes for you to
#' download a image to disk before running a clustering algorithm on it. It
#' defaults to 1 cluster to avoid errors.
#'
#' The rm_color will remove most unwanted colors when extracting color palettes
#' from charts, namely all greyscale colors. This is to ensure that neither
#' black or white will one of the color in the final palettes. To only remove
#' black or white set the argument to "black" or "white" respectively. Set to
#' any other value to avoid removing pixels.
#'
#' A variation of the Partitioning Around Medoids (PAM) clustering method is
#' used in this application to ensure that each of the resulting colors
#' appears in the original image which is something that is not guaranteed
#' using standard k-means. This is particular helpfull since most charts only
#' have a handfull of different colors in them.
#'
#' @param url A character string of the url with the png.
#' @param n_clusters number of clusters. Defaults to 1.
#' @param rm_color removes certain kinds of colors. Must be one of
#'     "greyscale", "white" or "black".
#' @return A color palette as a string.
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
url_palette <- function(url, n_clusters = 1, rm_color = c("greyscale")) {

  if(!stringr::str_detect(url, "(png|jpg)")) {
    stop("url_palette only supports .png and files")
  }

  if(stringr::str_detect(url, "png")) {
    my_image <- png::readPNG(RCurl::getURLContent(url))
  }
  if(stringr::str_detect(url, "jpg")) {
    my_image <- jpeg::readJPEG(RCurl::getURLContent(url))
  }

  dimension <- dim(my_image)

  image_rgb <- data.frame(
    x = rep(1:dimension[2], each = dimension[1]),
    y = rep(dimension[1]:1, dimension[2]),
    R = as.vector(my_image[, , 1]),
    G = as.vector(my_image[, , 2]),
    B = as.vector(my_image[, , 3])
  )

  if("greyscale" %in% rm_color) {
    image_rgb <- image_rgb[!(image_rgb$R == image_rgb$G &
                             image_rgb$G == image_rgb$B), ]
  }
  if("white" %in% rm_color) {
    image_rgb <- image_rgb[!(image_rgb$R == 1 &
                             image_rgb$G == 1 &
                             image_rgb$B == 1), ]
  }
  if("black" %in% rm_color) {
    image_rgb <- image_rgb[!(image_rgb$R == 0 &
                             image_rgb$G == 0 &
                             image_rgb$B == 0), ]
  }

  k_medoids <- cluster::clara(image_rgb[, c("R", "G", "B")], k = n_clusters)

  rgb(k_medoids$medoids)
}
