#' \code{createAtlas} plots the average flag representation of each specified type. The function determines matching types by prefix matching the column name.
#'
#' @param x a flagVisData object, that has nmfData
#' @param types the prefix strings that match a column name. An average nmf will be created over all columns that match the string.
#' @seealso \code{\link{createFlag}}
#' @examples
#' myData <- flagVis(sampleSmallMutationData)
#' createAtlas(myData, sampleCancerTypeList)
#' @export
#'
createAtlas <- function (x, types) {
  for (type in types) {
    grepNMF <- NMF::coef(x@nmfData)[, grepl(type, colnames(NMF::coef(x@nmfData)))]
    if (ncol(grepNMF) != 0) {
      for (i in 1:nrow(grepNMF)) {
        multiply <- max(grepNMF[i, ])
        grepNMF[i, ] <- grepNMF[i, ] / multiply
      }

      averageDf <-
        data.frame(matrix(ncol = nrow(grepNMF), nrow = 1))
      for (i in 1:nrow(grepNMF)) {
        averageDf[i] <- sum(grepNMF[i, ]) / ncol(grepNMF)
      }
      createFlag(nmfDataToRGB(t(averageDf)), title = type)
    }
  }
}

#' \code{createFlag} plots the colors given in a flag like shape
#'
#' @param flagColors the colors in the flag, painted from top to bottom. Must be hex strings.
#' @param maxColors the maximum number of rows in the flag
#' @param title the title at the top of the plot
#' @seealso \code{\link{createAtlas}}
#' @examples
#' createFlag(c("#000000", "#FFFFFF", "#00FF00", "#0000FF"))
#' createFlag(c("#000000", "#FFFFFF", "#00FF00", "#0000FF"), maxColors = 2, title = "Hello!")
#' @export
#'
createFlag <- function (flagColors,
                        maxColors = 4,
                        title = "Flag") {
  op <- par(bg = "white")
  plot(
    c(0, 400),
    c(0, 400),
    type = "n",
    xlab = "",
    ylab = "",
    axes = FALSE,
    main = title
  )
  height <- 200 / min(length(flagColors), maxColors)
  for (i in 1:min(length(flagColors), maxColors)) {
    rect(100,
         300 - (i + 1) * height,
         300,
         300 - (i) * height,
         col = flagColors[i],
         lwd = 1)
  }
}

# [END]
