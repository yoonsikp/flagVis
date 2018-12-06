

#' \code{transformPolarLAB} transforms a 2d point into the polarLAB colorspace, given two accent colors. This function first rotates the point 45 degrees, then compresses the space vertically.
#' Then, the point is scaled in between the hue and lightness of the given accent colors.
#' @param x the complete returned data from the non-negative matrix factorization
#' @param color1 the "color" object for the first accent color, in any representation
#' @param color2 the "color" object for the second accent color, in any representation
#' @param color1Black the optional "color" object, currently only used for the second (darker) lightness. Default value is NULL
#' @param color2Black the optional "color" object, currently only used for the second (darker) lightness. Currently ignored. Default value is NULL
#' @return The transformed point as a "color" object in polarLAB space.
#' @examples
#' myColor <- transformPolarLAB(c(0, 1), colorspace::RGB(0, 1, 0), colorspace::RGB(0, 1, 0))
#' myColorAgain <- transformPolarLAB(c(1, 0), colorspace::RGB(0, 1, 0), colorspace::RGB(0, 1, 0),
#'    colorspace::polarLAB(10,100,260), colorspace::polarLAB(10,100,160))
#' @export

transformPolarLAB <-
  function(x,
           color1,
           color2,
           color1Black = NULL,
           color2Black = NULL) {
    color1 <- colorspace::coords(as(color1, "polarLAB"))
    color2 <- colorspace::coords(as(color2, "polarLAB"))
    if (is.null(color1Black)) {
      color1Black <- colorspace::polarLAB(20, color1[2], color1[3])
    }
    if (is.null(color2Black)) {
      color2Black <- colorspace::polarLAB(20, color2[2], color2[3])
    }
    if (x[1] < 0 | x[2] < 0) {
      stop("no negative values!")
    }
    if (x[1] > 1 | x[2] > 1) {
      stop("no values greater than one!")
    }
    color1Black <- colorspace::coords(as(color1Black, "polarLAB"))
    color2Black <- colorspace::coords(as(color2Black, "polarLAB"))
    # let's make the colors POP!!
    x <- sqrt(sqrt(x))
    #rotate 45 degrees
    new_x <-
      x[1] * cos(45 / 360 * (2 * pi)) - x[2] * sin(45 / 360 * (2 * pi))
    new_y <-
      x[1] * sin(45 / 360 * (2 * pi)) + x[2]  * cos(45 / 360 * (2 * pi))
    new_y <- new_y * (abs(new_x) * 0.5 / (sqrt(2) / 2) + 0.5)
    new_x <- new_x / (sqrt(2) / 2) + 0.5
    new_y <- new_y / (sqrt(2) / 2)
    axis1 <- (color1[1] - color1Black[1]) * new_y
    minHue <- min(color1[3] %% 360, color2[3] %% 360)
    maxHue <- max(color1[3] %% 360, color2[3] %% 360)
    if ((maxHue - minHue) > 180) {
      minHue <- minHue + 360
    }
    shear <- (color1Black[3] - color1[3])
    axis2 <- minHue +  (maxHue - minHue) * new_x
    return(colorspace::polarLAB(axis1, color1[2], axis2 %% 360))
  }

#' \code{convertValidRGB} converts any "color" object into a valid RGB hex string. Furthermore, it corrects gamma for visibility reasons.
#'
#' @param colorToConvert the "color" object
#' @param gamma the gamma correction value
#' @return A RGB hex string.
#' @examples
#' # Invalid RGB values...
#' validHex <- convertValidRGB(colorspace::RGB(1,0,0))
#' validHex == "#FF0000"
#' @export
#'
#'
convertValidRGB <- function (colorToConvert, gamma = 1.3) {
  hexVal <- colorspace::hex(colorToConvert, fixup = TRUE)
  newRGB <- colorspace::hex2RGB(hexVal)
  return(colorspace::hex(colorspace::sRGB(
    colorspace::coords(newRGB)[1] ^ (1 / gamma),
    colorspace::coords(newRGB)[2] ^ (1 / gamma),
    colorspace::coords(newRGB)[3] ^ (1 / gamma)
  ), fixup = TRUE))
}
#' \code{getNextColor} internal function for returning different colors based on counter.
#'
#' @param i the counter variable
#' @param colorPalette the color palette, colors repeat once iterated through. Must be of color-class
#' @return A "color" object.
#'
#'
getNextColor <- function(i, colorPalette = list(colorspace::RGB(1, 0.1, 0),
                                             colorspace::RGB(0, 1, 0),
                                             colorspace::RGB(0, 0.2, 1),
                                             colorspace::RGB(1, 1, 0),
                                             colorspace::RGB(0, 0, 1),
                                             colorspace::RGB(0, 1, 0),
                                             colorspace::RGB(0.5, 0.5, 1),
                                             colorspace::RGB(1, 0, 0.5))    ) {
  num <- length(colorPalette)

  return(colorPalette[[i %% num + 1]])

}

# [END]
