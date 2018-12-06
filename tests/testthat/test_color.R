#test_color.R

context("color transformation functions")
library(flagVis)
library(NMF)
library(colorspace)

# ==== BEGIN SETUP AND PREPARE =================================================
#

#
# ==== END SETUP AND PREPARE ===================================================


test_that("corrupt input for transform generates errors",  {
  expect_error(transformPolarLAB(), "argument \"color1\" is missing, with no default")
  expect_error(transformPolarLAB(c(0,10), colorspace::RGB(0, 1, 0), colorspace::RGB(0, 1, 0)), "no values greater than one!")
  expect_error(transformPolarLAB(c(0.2,-2), colorspace::RGB(0, 1, 0), colorspace::RGB(0, 1, 0)), "no negative values!")
})

test_that("an invalid RGB provides truncated output",  {
  expect_equal(convertValidRGB(RGB(0,2,0)), "#00FF00")
})

test_that("a correct hex does not change during conversion without gamma",  {
  expect_equal(convertValidRGB(as(hex2RGB("#123456"), "RGB"), gamma = 1), "#123456")
})
