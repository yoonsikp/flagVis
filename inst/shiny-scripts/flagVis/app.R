# server.R
#
# Code referenced from https://github.com/hyginn/rptPlus on December 4th, 2018
# Parts of the code inspired by the RStudio shiny tutorial script 01_hello.

library(shiny)
library(flagVis)
if (! require(colourpicker, quietly=TRUE)) {
  install.packages("colourpicker")
  library(colourpicker)
}
library(colorspace)

# Initialize NMF data and flagVisClass
flagVisResult <- flagVis(sampleSmallMutationData)

numRecords <- length(colnames(NMF::coefficients(flagVisResult@nmfData)))
fullList <- sampleCancerTypeList
fullList[28] <- "Choose Individual ID"
# Define UI for sample app
myUi <- fluidPage(

  titlePanel("flagVis for Cancer Types, using Mutation Data"),
  sidebarLayout( position = "right",
    sidebarPanel(

      selectInput(inputId = "mytype", "Select Cancer Type:", fullList, selected = "Choose Individual ID")
      , sliderInput(inputId = "id",
                  label = "Individual ID:",
                  min = 1,
                  max = numRecords,
                  value = 30)
      , colourInput(inputId = "col3", "Select colour", value = "#1C21A8")
      , colourInput(inputId = "col4", "Select colour", value = "#26A81C")
      , colourInput(inputId = "col5", "Select colour", value = "#FF0000")
      , colourInput(inputId = "col6", "Select colour", value = "#E100FF")
      , colourInput(inputId = "col1", "Select colour", value = "#FFA600")
      , colourInput(inputId = "col2", "Select colour", value = "#00FF22")
    ),

    mainPanel(
      textOutput(outputId = "number")
      ,
      plotOutput(outputId = "plott")
    )
  )
)

# Define server logic to subject samples to large numbers of small changes,
# subject to a left-hand bound
# normalize the data, and overlay with a normal distribution.
myServer <- function(input, output) {

  output$number <- renderText({
    sprintf("Bound: %f", input$bound)
    })
  output$plott <- renderPlot({
    myPalet <- list(hex2RGB(input$col1), hex2RGB(input$col2), hex2RGB(input$col3),
                    hex2RGB(input$col4), hex2RGB(input$col5), hex2RGB(input$col6))

    flagVisResult@rgbData <- nmfDataToRGB(flagVisResult@nmfNormData, colorPalette = myPalet)

    if (input$mytype == "Choose Individual ID") {
      createFlag(flagVisResult@rgbData[,input$id],
                 title=(colnames(NMF::coefficients(flagVisResult@nmfData))[input$id]))

    } else {
      grepNMF <- NMF::coef(flagVisResult@nmfData)[, grepl(input$mytype, colnames(NMF::coef(flagVisResult@nmfData)))]
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
        createFlag(nmfDataToRGB(t(averageDf), colorPalette = myPalet), title = input$mytype)
      }
    }

  })

}

shinyApp(ui = myUi, server = myServer)

# [END]
