
# Simulacion estocastica para interaciones competitivas 
#
STO_interact <- function(x,pars,times)
{
  # Setup an array to store results: time, N
  #
  ltimes<-length(times)
  output <- array(dim=c(ltimes,3),dimnames=list(NULL,names(x)))
  t <- x[1]
  stopifnot(t<=times[1])
  
  # loop until either k > maxstep or
  #
  output[1,] <-x
  k <- 2
  while (k <= ltimes) {
    while (t < times[k]) {
      x <- interact_onestep(x,pars) 
      t <- x[1]
    }
    while (t >= times[k] && k <= ltimes) {
      output[k,] <- x
      k <- k+1
    }
  }
  as.data.frame(output)
}

# interaciones competitivas - Simulacion de Eventos 
#
interact_onestep<- function(x,pars){
  p<-as.list(pars)
  # 2nd element is the population 
  #
  N1<-x[2]
  N2<-x[3]
  B1<-N1*p$r1+p$im
  B2<-N2*p$r2+p$im
  D1<- N1*(N1*p$d11+N2*p$d12)
  D2<- N2*(N1*p$d21+N2*p$d22)
  R <- B1+B2+D1+D2
  if(R>0) {
    Y1 <- runif(1)
    
    if(Y1 <=B1/R){
      if(N1>0) N1<-N1+1
    } else if(Y1 <= (B1+D1)/R) {
      N1<-N1-1
    } else if(Y1 <= (B1+D1+B2)/R) {
      if(N2>0) N2<-N2+1
    } else {
      N2<-N2-1
    }
    # Exponential random number
    tau<-rexp(n=1,rate=R)
    
  } else tau<-1
  
  c(x[1]+tau,N1,N2)
}


#
DET_interact<-function(t,State,Pars){
  with(as.list(c(State, Pars)), {
    
    dN1 <- N1*(r1-d11*N1-d12*N2)+im 
    dN2 <- N2*(r2-d21*N1-d22*N2)+im    
    return(list(c(dN1,dN2)))
  })
}
