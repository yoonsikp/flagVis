# example.R
#
# Purpose: To show the capabilities of flagVis on sample mutation data
# Version: 0.1
# Date: 2018-10-06
# Author: Yoonsik Park
#
# Input: N/A
# Output: Plots
# Dependencies: flagVis, NMF, colorspace
# ==============================================================================

# ====  PACKAGES  ==============================================================
# Load all required packages.

if (! require(NMF, quietly=TRUE)) {
  install.packages("NMF")
  library(NMF)
}
library(colorspace)
library(flagVis)


# ====  PROCESS  ===============================================================
# Enter the step-by-step process of your project here. Strive to write your
# code so that you can simply run this entire file and re-create all
# intermediate results.

# load dataset into variable x
load("./data/smallMutationData.RData")
# load selectedFiles, which contains all cancer type strings
load("./data/cancerTypeList.RData")

# get NMF and RGB Transformation results
flagVisResult <- flagVis(x)

# average and plot all cancer types as flags
createAtlas(flagVisResult, selectedFiles)

# guess what flag this is?
createFlag(flagVisResult@rgbData[,109], title="guess?")

# here's the answer:
print(colnames(coefficients(flagVisResult@nmfData))[109])
