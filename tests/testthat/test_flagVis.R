#test_flagVis.R

context("flagVis functions")
library(flagVis)
library(NMF)
library(colorspace)

# ==== BEGIN SETUP AND PREPARE =================================================
#
#
# ==== END SETUP AND PREPARE ===================================================

test_that("check flagvis generates errors",  {
  expect_error(flagVis(sampleSmallMutationData, factorsPerColor = 4), "Factors per color other than 2 not currently supported")
  expect_error(flagVis(sampleSmallMutationData, numColors = 0), "Need at least one color")
})
test_that("check dimensions of flagVisData class",  {
  myResult<- flagVis(sampleSmallMutationData)
  expect_equal(ncol(coef(myResult@nmfData)), 27 * 7)
  expect_equal(nrow(basis(myResult@nmfData)), 96)
  expect_equal(ncol(myResult@rgbData), 27 * 7)
  expect_equal(nrow(myResult@nmfData), 96)
  expect_equal(nrow(myResult@basisOrder), 4)
})
test_that("a flag is generated using the same seed to check color output",  {
  myResult<- flagVis(sampleSmallMutationData, seed = 5)
  expect_equal(myResult@rgbData[,1], c( "#680000", "#004AD0", "#2F003C", "#450000"))
})

# https://stackoverflow.com/questions/10826365/how-to-test-that-an-error-does-not-occur
# Downloaded on December 5th, 2018

test_that("a flag and atlas can be generated",  {
  myResult<- flagVis(sampleSmallMutationData, seed = 5)
  expect_error(createAtlas(myResult, sampleCancerTypeList), NA)
  expect_error(createFlag(myResult@rgbData[,109], title="guess?"), NA)
  expect_equal(myResult@rgbData[,1], c( "#680000", "#004AD0", "#2F003C", "#450000"))
})
