library(shiny)
library(shinythemes)
library(DT)

NIV <- read.csv("clean NIV data 11-9.csv", stringsAsFactors = FALSE)

names(NIV) <- c("Continent", "Country", "Fiance", "Number_of_Records", "Student", "Temp_Worker",
                "Total_Visas", "Visitor", "Year")

NIV_df <- select(NIV, -Number_of_Records)
df <- NIV_df[,c(8,2,1,3,4,5,7,6)]

ui <- fluidPage(theme = shinytheme("lumen"),
  basicPage(
  h2("NIV Data"),
  DT::dataTableOutput("mytable"),
  titlePanel("NIV Issuances 1997-2017"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("yearInput", "Year", 1997, 2017, c(2000, 2005), sep = ""),
      checkboxGroupInput("visatypeInput", "Visa Type",
                   choices = c("Fiance", "Student", "Visitor", "Temporary Worker", "Total"),
                   selected = "Visitor", inline= FALSE),
      selectInput("countryInput", "Country",
                  choices = unique(df$Country),
                  selected = "Mexico", multiple = TRUE)
                
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("myplot")), 
        tabPanel("Summary", verbatimTextOutput("summary")), 
        tabPanel("Table", dataTableOutput("table"), value="table"),
      plotOutput("myplot"),
      br(), br(),
      tableOutput("results")
    ))
)))

dataset <- reactive({df})
  
server <- function(input, output) {
  output$table = renderDataTable({
    df})
  output$myplot <- renderPlot({
    ggplot(df, aes(x=Year, y=Total_Visas)) + geom_point() #placeholder plot
})
}







shinyApp(ui = ui, server = server)



