
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Stochastic competition model (2 Species)"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    
    sidebarPanel(
#    actionButton("go", "Simulate!"),
      tags$h3("Simulation parameters "),
      sliderInput("tt",
                  "Simulation steps:",
                  min = 10,
                  max = 1000,
                  value = 50),
      numericInput("nsims", "Number of simulations:",5,min=1,max=10),
      numericInput("rseed", "Random number seed   :",333,min=1,max=1000),

      tags$h3("Model parameters "),
      
      numericInput("N1","Initial population 1 :",10,min=1,max=1000),
      numericInput("N2","Initial population 2 :",10,min=1,max=1000),
      numericInput("r1" ,"Growth rate pop 1 (r1):",1,min=0,max=10),
      numericInput("r2" ,"Growth rate pop 2 (r2):",1,min=0,max=10),
      numericInput("d11" ,"Intra-specific denso-dependence 1 (d11) :",0.02,min=0.00001,max=5),
      numericInput("d22" ,"Intra-specific denso-dependence 1 (d22) :",0.02,min=0.00001,max=5),
      numericInput("d12" ,"Inter-specific 2 over 1 (d12) :",0.02,min=0.00001,max=5),
      numericInput("d21" ,"Inter-specific 1 over 2 (d21) :",0.02,min=0.00001,max=5),
      numericInput("im"  ,"Denso-independent Inmigration :",0,min=0,max=10),
      actionButton("go", "Simulate!"),
      
      tags$h3("Deterministic stability "),
      textOutput("Stability")
      
    ),

  mainPanel(

    tabsetPanel(    
      tabPanel("Time series",plotOutput("modelPlotTime",height="500px")),
      tabPanel("Phase Plot",plotOutput("modelPlotPhase",height="500px")),
      tabPanel("Data Table",tableOutput("datatable"))
    )  
  ) 
)
)
)



