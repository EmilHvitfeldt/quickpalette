context("test-regex_palette.R")

test_that("regex_palette returns a vector with correct number of outputs with
          supplied with a string", {
  text <- '"#1B9E77" "#D95F02" "#7570B3" "#E7298A" "#66A61E"'

  expect_equal(length(regex_palette(text)), 5)
  expect_is(regex_palette(text), "character")
  expect_equal(regex_palette(""), NA)
})

test_that("regex_palette returns a list with correct number of outputs with
          supplied with a vector of strings", {
  text <- c("#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E")

  expect_equal(length(regex_palette(text)), 5)
  expect_is(regex_palette(text), "list")
})
