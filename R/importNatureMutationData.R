#' \code{returnExomeFiles} searches through the directory of the Nature Mutation exome data, and returns a list of all readable .txt files
#'
#' @param directory the directory to search through
#' @return The file strings.
#' @seealso \code{\link{selectSubsitutionSubType}}
#' @examples
#' returnExomeFiles("~/files/mutational_catalogs/exomes")
#' @export
#'
returnExomeFiles <- function(directory) {
  return(Sys.glob(file.path(directory, "*", "*.txt")))
}

#' \code{selectSubsitutionSubType} returns only the filenames with the 96 substitution subtype
#'
#' @param fileList list of files
#' @param subtype the subtype to match. Uses grep pattern matching.
#' @return The file strings.
#' @seealso \code{\link{returnExomeFiles}}
#' @examples
#' selectSubstitutionType("~/files/mutational_catalogs/exomes")
#' @export
#'
selectSubsitutionSubType <- function(fileList, subtype = "96") {
  return(subtype <- fileList[grep(subtype, fileList)])
}

#' \code{getNatureMutatationData} returns only the filenames with the 96 substitution subtype
#'
#' @param directory specifically the directory of the supplementary data from the nature article (https://doi.org/10.1038/nature12477)
#' @return A 2d matrix, with columns representing the cancer subtypes, and the rows representing the mutation frequencies
#' @examples
#' getNatureMutatationData("~/files/mutational_catalogs/exomes")
#' @export
#'
getNatureMutatationData <- function(directory) {
  files <- returnExomeFiles(directory)
  selectedFiles <- selectSubsitutionSubType(files)
  df <- data.frame(NULL)
  first <- TRUE
  for (file in selectedFiles) {
    cancerData <- read.table(
      file,
      sep = "\t",
      header = TRUE,
      stringsAsFactors = FALSE
    )
    newCols <-
      paste(tail(strsplit(file, "/", fixed = TRUE)[[1]], n = 1), "-", colnames(cancerData), sep =
              "")
    newCols[1] <- "Mutation.Type"
    colnames(cancerData) <- newCols
    if (first) {
      df <- cancerData
      first <- FALSE
    } else{
      df <- merge(df, cancerData, by = "Mutation.Type")
    }
  }
  row.names(df) <- t(df[1])
  df[1] <- NULL
  return(df)
}
