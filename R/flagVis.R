#' \code{flagVis} reduces the dimensions of 2D matrix data and calculates multiple rgb values representing each sample. The rank of the NMF will be determined by factorsPerColor * numColors.
#'
#' @param x the 2D dataset. Only non-negative numeric values should be in the matrix. A row cannot contain all zeros.
#' @param factorsPerColor the number of factors each color should represent. Currently only supports the value of 2.
#' @param numColors the number of colors to output for each column.
#' @param seed random seed for repeated runs
#' @param calculateVarianceRank option to calculate the ranking of the normalized coefficient matrix rows by standard deviation (1 being highest)
#' @return A flagVisData Class.
#' @examples
#' myData <- flagVis(flagVis::sampleSmallMutationData)
#' @export
#'

flagVis <- function(x,
           factorsPerColor = 2,
           numColors = 4,
           seed = 3,
           calculateVarianceRank = FALSE) {
    if (factorsPerColor != 2) {
      stop("Factors per color other than 2 not currently supported")
    }
    if (numColors <= 0) {
      stop("Need at least one color")
    }
    nmfResult <- NMF::nmf(x, numColors * factorsPerColor, seed = seed)
    basisOrder <- data.frame(1:numColors * factorsPerColor)
    if (calculateVarianceRank) {
      basisOrder <- data.frame(rank(getNormalizedCoefSD(nmfResult) * -1))
    }
    df <- cbind(NMF::coef(nmfResult))
    for (i in 1:nrow(NMF::coef(nmfResult))) {
      multiply <- max(NMF::coef(nmfResult)[i, ])
      df[i, ] <- df[i, ] / multiply
    }
    rgbData <- nmfDataToRGB(df)
    retData <-
      new(
        "flagVisData",
        rgbData = rgbData,
        nmfData = nmfResult,
        nmfNormData = df,
        basisOrder = basisOrder
      )
    return(retData)
  }

#' \code{flagVisData} A class to hold the data returned from the flagVis function. This includes the NMF data, the RGB data, and the normalized coefficient matrix ranking.
#'
#' @param rgbData the RGB data, represented as hex strings. Each column may hold multiple RGB hex strings.
#' @param nmfData the object returned from the non-negative matrix factorization
#' @param nmfNormData the normalized nmfData, used to recalculate rgbData when the color palette is changed
#' @param basisOrder the ranking of the normalized coefficient matrix rows by standard deviation (1 being highest).
#' @seealso \code{\link{flagVis}}
#' @examples
#' myData <- flagVis(flagVis::sampleSmallMutationData)
#' createFlag(myData@rgbData[,10])
#' @export
#' @importClassesFrom NMF NMFfit
#'
setClass(
  "flagVisData",
  representation(
    rgbData = "array",
    nmfData = "NMFfit",
    nmfNormData = "matrix",
    basisOrder = "data.frame"
  )
)

#' \code{nmfDataToRGB} is the helper function to flagVis. It uses the coefficient matrix, x, to construct the rgbData attribute. It assumes that the values for x are only between 0 and 1.
#'
#' @param x the coefficient matrix. Only non-negative numeric values should be in the matrix, with values between 0 and 1.
#' @param factorsPerColor the number of factors each color should represent. Currently only supports the value of 2.
#' @param numColors the number of colors to output for each column.
#' @param colorPalette a List containing multiple color-class objects. These are used for coloring
#' @return A 2D string array.
#' @seealso \code{\link{flagVis}}
#'
#' @export
nmfDataToRGB <- function (x,
                          factorsPerColor = 2,
                          numColors = 4,
                          colorPalette = NULL) {
  rgbData <- array(rep(NaN, numColors * ncol(x)), c(numColors, ncol(x)))
  for (i in 1:ncol(x)) {
    for (j in 1:numColors) {
      allFactors <-
        (x[((j - 1) * factorsPerColor + 1):((j - 1) * factorsPerColor + factorsPerColor), i])
      if (is.null(colorPalette)) {
        rgbData[j, i] <-
          convertValidRGB(transformPolarLAB(allFactors, getNextColor(2 * j), getNextColor(2 * j + 1)))
      } else {
        rgbData[j, i] <-
          convertValidRGB(transformPolarLAB(allFactors, getNextColor(2 * j, colorPalette = colorPalette),
                                            getNextColor(2 * j + 1, colorPalette = colorPalette)))
      }

    }
  }
  return(rgbData)
}

#' \code{getL1Norms} returns the normalization coefficients for each column required for the basis columns. This type of normalization ensures that the column sum is 1
#'
#' @param nmfBasis the basis matrix of the non-negative matrix factorization data
#' @return A numeric vector.
#'
#'
getL1Norms <- function(nmfBasis) {
  df = colSums(nmfBasis)
}
#' \code{normalizeBasis} returns the normalized basis, based on the given normalization coefficients. This function divides each column in nmfBasis by the corresponding value in norms.
#'
#' @param nmfBasis the basis matrix of the non-negative matrix factorization data
#' @param norms the normalization coefficients
#' @return A numeric vector.
#' @seealso \code{\link{getL1Norms}}
#'
normalizeBasis <- function(nmfBasis, norms) {
  for (i in 1:ncol(nmfBasis)) {
    nmfBasis[, i] <- nmfBasis[, i] / norms[i]
  }
  return(nmfBasis)
}
#' \code{normalizeCoef}  returns the normalized coefficients, based on the given normalization coefficients. This function divides each column in nmfCoef by the corresponding value in norms.
#'
#' @param nmfCoef the coefficient matrix of the non-negative matrix factorization data
#' @param norms the normalization coefficients
#' @return A numeric vector.
#' @seealso \code{\link{seq}}
#'
normalizeCoef <- function(nmfCoef, norms) {
  for (i in 1:nrow(nmfCoef)) {
    nmfCoef[i, ] <- nmfCoef[i, ] * norms[i]
  }
  return(nmfCoef)
}

#' \code{getNormalizedCoefSD} calculates the standard deviation for each normalized row of the correlation matrix
#'
#' @param nmfResult the complete returned data from the non-negative matrix factorization
#' @return A numeric vector.
#'
getNormalizedCoefSD <- function(nmfResult) {
  norms <- getL1Norms(NMF::basis(nmfResult))
  newBasis <- normalizeBasis(NMF::basis(nmfResult), norms)
  newCoefficients <- normalizeCoef(NMF::coefficients(nmfResult), norms)

  df <- data.frame(matrix(ncol = nrow(newCoefficients), nrow = 1))
  for (i in 1:nrow(newCoefficients)) {
    df[i] <- sd(newCoefficients[i, ])
  }
  return(df)
}

# [END]
