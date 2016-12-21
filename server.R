library(shiny)
library(ggplot2)
require(RColorBrewer)
require(doParallel)
source("Simul_fun.r")


# Define server logic 
#
shinyServer(function(input, output) {
  
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot
  randomVals <- eventReactive(input$go, {
    TRUE
  })
  
  mdl <- reactive({
    if(randomVals()){
    # Build a list with parameters
    #
    set.seed(input$rseed)    
    nsims  <- input$nsims
    times  <- seq(0,input$tt,by=1)          # Simulation steps 
    xstart <- c(time=0,N1=input$N1,N2=input$N2)  # initial conditions
    params <- c(r1=input$r1,d11=input$d11,d12=input$d12,r2=input$r2,d22=input$d22, d21=input$d21,im=input$im)  # parameters 
    
    simdat <- data.frame()  # to store simulated data
    require(doParallel)
    cn <-detectCores()
    cl <- makeCluster(cn)
    registerDoParallel(cl)
    # Run simulations of the stochastic model
    #
    simdat <- foreach(k=1:nsims,.combine='rbind',
                      .export=c("STO_interact","interact_onestep")) %dopar%
    {
      data.frame(STO_interact(xstart,params,times),sim=k)
    }
    stopCluster(cl)
    
    # for (k in 1:nsims) {
    #   s<-STO_interact(xstart,params,times)
    #   s$sim<-k
    #   simdat <-rbind(simdat,s)
    # }

    # Determinista
    #
    require(deSolve)
    yini  <- c(N1 = input$N1,N2=input$N2)
#    times <- seq(0,input$tt,by=1)
    out   <- ode(yini, times, DET_interact, params)

    s<-data.frame(time=out[,1],N1=out[,2],N2=out[,3],sim="D")
    simdat$sim <-factor(simdat$sim)
    
    simdat <-rbind(simdat,s)
    
    }
  })
  
  output$modelPlotTime <- renderPlot({
    
  if(randomVals()){

    # Time plot
    #
    simdat <- mdl()
    
    
    ggplot(simdat,aes(time,N1,colour=sim))+theme_bw() + geom_line() + 
        scale_colour_brewer(palette="Dark2") + geom_line(aes(time,N2,colour=sim),linetype="dashed") +
        facet_wrap(~sim,ncol=2) + ylab("N")

       
    }

  })

  output$modelPlotPhase <- renderPlot({
    
  if(randomVals()){
    
    # Phase plot
    #
    simdat <- mdl()      
    
    simdat$sim <-factor(simdat$sim)
    ggplot(simdat,aes(N1,N2,colour=sim))+theme_bw() + geom_point(alpha=0.5) + 
            scale_colour_brewer(palette="Dark2")  + facet_wrap(~sim,ncol=2)

  }
    
  })
  
 
  output$datatable <- renderTable({
  if(randomVals()){

      simdat <- mdl()    
    }
  })
  
  output$Stability <- 
    renderText(paste0('d12/d22=', round(input$d12/input$d22,2), ' < r1/r2=', round(input$r1/input$r2,2),
                     ' < d11/d21=', round(input$d11/input$d21,2)))
  
  
})

