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
#' @param warnings If FALSE will suppress the warnings coming from loading the
#'     image file. Defaults to TRUE.
#' @param colorspace The colorspace in which the clustering is taking place.
#'     Allowed values are: "cmy", "cmyk", "hsl", "hsb", "hsv", "lab",
#'     "hunterlab", "lch", "luv", "rgb", "xyz", "yxy".
#' @return A color palette as a string.
#' @examples
#' url <- "https://raw.githubusercontent.com/EmilHvitfeldt/quickpalette/master/man/figures/README-testchart-1.png"
#' url_palette(url, n_cluster = 5)
#' @export
url_palette <- function(url, n_clusters = 1, rm_color = c("greyscale"),
                        warnings = TRUE, colorspace = "rgb") {

  if(!stringr::str_detect(url, "(png|jpg)")) {
    stop("url_palette only supports .png and files")
  }

  if(stringr::str_detect(url, "png")) {
    if(warnings) {
      my_image <- png::readPNG(RCurl::getURLContent(url))
    } else {
      my_image <- suppressWarnings(png::readPNG(RCurl::getURLContent(url)))
    }
  }
  if(stringr::str_detect(url, "jpg")) {
    if(warnings) {
      my_image <- jpeg::readJPEG(RCurl::getURLContent(url))
    } else {
      my_image <- suppressWarnings(jpeg::readJPEG(RCurl::getURLContent(url)))
    }
  }

  dimension <- dim(my_image)

  image_rgb <- data.frame(
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

  image_rgb <- farver::convert_colour(image_rgb, "rgb", colorspace)

  k_medoids <- cluster::clara(image_rgb, k = n_clusters)

  rgb(pmax(farver::convert_colour(k_medoids$medoids, colorspace, "rgb"), 0))
}
