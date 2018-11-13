library(shiny)
library(shinythemes)
library(DT)
library(dplyr)
library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(extrafont)
library(scales)

# font_import()
# loadfonts(device = "win")
# windowsFonts()

df_melt <- read.csv("df_melt1.csv")
df_melt <- select(df_melt, -X)
# df_melt$Year <- as.factor(df_melt$Year)

ui <- fluidPage(
  basicPage(
  h1("U.S. Non Immigrant Visa Issuances"),
  h2("1997-2017"),
  DT::dataTableOutput("mytable"),
  titlePanel(img(src="picture.png", align="right", width=100)),
  sidebarLayout(
    sidebarPanel(
      # h2("Installation"),
      sliderInput("yearInput", label = strong("Year"), 1997, 2017, c(2000, 2005), sep = ""),
      tags$hr(),
      radioButtons("visatypeInput", label = strong("Visa Type"),
                   choices =unique(df_melt$VisaType),
                   selected = "Visitor", inline= FALSE),
      tags$hr(),
      selectInput("countryInput", label = strong("Country"),
                  choices = unique(df_melt$Country),
                  selected = "Mexico", multiple = FALSE),
      tags$hr(),
      h5("Built with",
         img(src = "shiny.png", height = "30px"),
         "by",
         img(src = "RStudio.png", height = "30px"),
         "Studio.")
                
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("myplot")), 
        tabPanel("Table", dataTableOutput("table"), value="table"),
        tabPanel("ReadMe", verbatimTextOutput("ReadMe"))
      # plotOutput("myplot"),
      # tableOutput("results")
    ))
)))

  
server <- function(input, output) {
  
  filtered_data <- reactive({filter(df_melt, Country == input$countryInput, Year >= input$yearInput[1], Year <= input$yearInput[2], VisaType %in% input$visatypeInput) })
  output$table = renderDataTable({
    filtered_data()})
  output$myplot <- renderPlot({
    ggplot(filtered_data(), aes(x=Year, y=NumberofVisas)) + geom_bar(stat = "sum", fill="#138D75", width=0.5) + theme_bw() +theme(legend.position="none", text=element_text(size=14))+labs(title="Number of Issued Visas by Type and Country", y="Visa Issuances", x="Year", caption="Source: Department of Homeland Security") + geom_text(aes(label = comma(NumberofVisas))) + geom_label(aes(label = NumberofVisas)) + scale_y_continuous(labels = comma) 
})
  output$ReadMe <- renderText({
    "This Shiny application enables users to explore U.S. non-immigrant visa issuances by country, 
year and visa category.
    
Data source: https://travel.state.gov/content/travel/en/legal/visa-law0/visa-statistics/nonimmigrant-visa-statistics.html"
  })
  
}



shinyApp(ui = ui, server = server)

# fonts()
