miniDataset <- function (directory, numSamples = 7) {
  files <- returnExomeFiles(directory)
  selectedFiles <- selectSubsitutionSubType(files)
  df <- data.frame(NULL)
  first <- TRUE
  for (file in selectedFiles){
    cancerData <- read.table(file,
                             sep="\t",
                             header=TRUE,
                             stringsAsFactors = FALSE) [1:(numSamples + 1)]
    newCols <- paste(tail(strsplit(file, "/", fixed=TRUE)[[1]], n=1),"-", colnames(cancerData), sep="")
    newCols[1] <- "Mutation.Type"
    colnames(cancerData) <- newCols
    if (first){
      df <- cancerData
      first <- FALSE
    } else{
      df <- merge(df, cancerData[1:(numSamples + 1)], by="Mutation.Type")
    }
  }
  #  print(df)
  row.names(df) <- t(df[1])
  df[1] <- NULL
  df
}
directory <-("/Users/yoonsik/Library/Mobile Documents/com~apple~CloudDocs/Current Courses/BCB410/testing/mutational_catalogs/exomes")
files <- returnExomeFiles(directory)
selectedFiles <- selectSubsitutionSubType(files)
for (i in 1:length(selectedFiles)){
   selectedFiles[i] <- tail(strsplit(selectedFiles[i], "/", fixed=TRUE)[[1]], n=1)
}
x <- miniDataset("/Users/yoonsik/Library/Mobile Documents/com~apple~CloudDocs/Current Courses/BCB410/testing/mutational_catalogs/exomes")
sampleSmallMutationData <- x
save(sampleSmallMutationData, file='./data/smallMutationData.RData')
sampleCancerTypeList <- selectedFiles
save(sampleCancerTypeList, file='./data/cancerTypeList.RData')


