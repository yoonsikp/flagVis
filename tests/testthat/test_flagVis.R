#test_flagVis.R

context("flagVis functions")
library(flagVis)

# ==== BEGIN SETUP AND PREPARE =================================================
#
load("../../data/smallMutationData.RData")
load("../../data/cancerTypeList.RData")
#
# ==== END SETUP AND PREPARE ===================================================

test_that("check flagvis generates errors",  {
  expect_error(flagVis(x, factorsPerColor = 4), "Factors per color other than 2 not currently supported")
  expect_error(flagVis(x, numColors = 0), "Need at least one color")
})
test_that("check dimensions of flagVisData class",  {
  myResult<- flagVis(x)
  expect_equal(ncol(coef(myResult@nmfData)), 27 * 7)
  expect_equal(nrow(basis(myResult@nmfData)), 96)
  expect_equal(ncol(myResult@rgbData), 27 * 7)
  expect_equal(nrow(myResult@nmfData), 96)
  expect_equal(nrow(myResult@basisOrder), 4)
})
test_that("a flag is generated using the same seed to check color output",  {
  myResult<- flagVis(x, seed = 5)
  expect_equal(myResult@rgbData[,1], c("#4F0000", "#003382", "#1C0027", "#2F0000"))
})
