# Quick Run

Please see `inst/scripts/example.R` for a quick intro to the functions.
Please run `inst/shiny-scripts/flagVis/app.R` for a Shiny interface.

Load the package with: `devtools::install_github("yoonsikp/flagVis")`


## Introduction

The original purpose of this package was to create flags that allow someone to recognize a cancer type just from its colors. For example, the colors black, red, and yellow in horizontal bars, would immediately be recognized as the German flag. The inspiration was from my work on cancer genetics during my undergraduate research course, where I noticed an article about extracting cancer “signatures” from mutation data. https://www.nature.com/articles/nature12477#s1. The authors found that every cancer type could be described by a handful of features. These features, multiplied by the coefficients for each cancer type, would result in the original (but large) matrix.

This form of extracting a lower-dimensional feature set is called “Non-negative matrix factorization”“. However, this algorithm is much more general, and can be applied to almost any matrix data, with the only condition that the input has absolutely no negative numbers. Furthermore, the basis matrix determined through this method has the benefit of containing feature representations that are more human understandable. This is because of the purely additive (non-negative) aspect. Other dimensionality reduction techniques produce features that subtract and add values. NMF tends to create features that are independent of each other, e.g. NMF would produce eyes, nose, and mouth if decomposing a face image.

Since NMF produces useful signatures, then perhaps NMF may potentially be used to create a better visualization tool. My future goals with this is to be able to input a previous feature list from a previous, and as input data evolves and improves, a feature can be split into it’s more constituent parts -> eyes into left eye and right eye. However, the NMF package used in this project has some rough edges, and it is not currently technically feasible using its functions/API.

## flagVis

flagVis is an R package that aims to first, create unique flag-like visualizations and representations of a datapoint, and second, streamline the process from raw mutation data to non-negative matrix factorization (NMF) results. Each color of a flag contains two NMF coefficients. The 2D vector is then transformed, such that values of 0 are closer to black, while values of 1 are more saturated. Different coefficients produce different hues. All color work is conducted in the CIELCh color space, before being reconverted to sRGB. 

There is sample data included with the package, called '''sampleSmallMutationData'''. This data is a subset of the cancer mutation data used for the original Nature paper that inspired this project. 

There are functions to plot a single flag, as well as create a flag "atlas" based on the average values of a group of columns that match a string/prefix. The resulting NMF matrices and RGB matrices are stored in a flagVisData class, which can be hopefully be extended in the future.

Please check out "example.R" in the package for an easy explained demo. Please run the following commands to start the shiny interface:

```R
appDir <- system.file("shiny-scripts", "flagVis", package = "flagVis")
shiny::runApp(appDir, display.mode = "normal")
```

## References

* In non-negative matrix factorization, are the coefficients of features comparable? (n.d.). Retrieved from https://stats.stackexchange.com/questions/46469/in-non-negative-matrix-factorization-are-the-coefficients-of-features-comparable

* CIELAB color space. (2018, September 11). Retrieved from https://en.wikipedia.org/wiki/CIELAB_color_space

* OpenCV Gamma Correction. (2018, August 02). Retrieved from https://www.pyimagesearch.com/2015/10/05/opencv-gamma-correction/

* Subset data to contain only columns whose names match a condition. (n.d.). Retrieved from https://stackoverflow.com/questions/18587334/subset-data-to-contain-only-columns-whose-names-match-a-condition

* Vignettes by  by Hadley Wickham. Retrieved from http://r-pkgs.had.co.nz/vignettes.html Accessed December 5th, 2018
* Shiny Tutorial. Retrieved from http://shiny.rstudio.com/tutorial/ Accessed December 4th, 2018

* Shiny ColourInput. Retrieved from https://deanattali.com/2015/06/28/introducing-shinyjs-colourinput/ Accessed December 4th, 2018

* Shiny SelectInput. Retrieved from https://shiny.rstudio.com/reference/shiny/1.0.1/selectInput.html Accessed December 4th, 2018
