#' Cancer Base Subtitution Data
#' \code{sampleSmallMutationData}
#' Describes the frequencies of the 96 possible mutations for multiple different types of cancer.
#' Since each mutation can be described as (C>A, C>G, C>T, T>A, T>C, T>G), by taking the one immediately preceding and after, we get 96 possibilities.
#' There are 25 cancer types, with 5 samples for each cancer type. Please see \code{./inst/scripts/generateExtData.R} to see how it was generated.
#' @format An RData file with 96 rows and 135 columns (27 * 5):
#' \describe{
#'   \item{A,C>A,A}{represents the C to A mutation, as well as the surrounding bases}
#'   \item{A,C>A,C}{represents the same mutation with different surrounding bases}
#'   ...
#'   \item{Uterus_exomes_mutational_catalog_96_subs.txt-TCGA.A5.A0GD.01A.11W.A062.09}{represents the source text file, cancer type, and sample type}
#' }
#' @source \url{https://www.nature.com/articles/nature12477#mutational-signatures-and-age-of-cancer-diagnosis}
#' @examples
#' \dontrun{
#' load("data/smallMutationData.RData")
#' }
#' @name sampleSmallMutationData
NULL

#' List of Cancer Types
#' \code{sampleCancerTypeList}
#' Describes a list of the cancer types, i.e. filenames.
#' @format An RData file with 27 filenames/strings:
#' @source \url{https://www.nature.com/articles/nature12477#mutational-signatures-and-age-of-cancer-diagnosis}
#' @examples
#' \dontrun{
#' load("data/cancerTypeList.RData")
#' }
#' @docType data
#' @name sampleCancerTypeList
NULL

# [END]
