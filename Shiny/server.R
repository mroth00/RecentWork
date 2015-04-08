library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
	output$ABInfo <- renderPlot({
		  library(shiny)

		  if(input$split=="even"){
		  	  pretty_coversion=function(Xold,Yold,tau,num_visitors,alpha){
			  #People in x and y
			  nx=0
			  ny=0
			  #Conversions in x and y
			  cx=0
			  cy=0
			  test=vector()
			  diff=vector()
			  for(i in 1:num_visitors){
			    nx = nx + 1
			    ny = ny + 1 
			    #print(nx)
			    cx=cx+rbinom(1,1,Xold)
			    #print(cx)
			    cy=cy+rbinom(1,1,Yold)
			    #print(cy)
			    Xn=cx/nx
			    Yn=cy/ny
			    diff[i]=abs(Xn-Yn)
			    Vn=(Xn*(1-Xn)+Yn*(1-Yn))/(ny)
			    #print(Vn)
			    test_crit=((2*log(1/alpha)-log(Vn/(Vn+tau)))*((Vn*(Vn+tau))/tau))^.5
			    test[i]=test_crit
			    #print(test[i])
			  }
			  x=data.frame(test[50:num_visitors],diff[50:num_visitors],50:num_visitors)
			  colnames(x) = c("test","diff","index")
			  return(x)
			  
			}

  			q=pretty_coversion(input$sliderX,input$sliderY,input$Tau,input$Visitors,input$Alpha)
  			s=ggplot(q, aes(x=index)) +
      		geom_line(aes(y=test), colour="red")+
      		geom_line(aes(y=diff), colour="blue")+
      		ylab(label="Difference in Conversion Rate")+
      		xlab(label="Number of visits in X")
  			print(s)
		  } else{
		  	  pretty_coversion=function(Xold,Yold,tau,num_visitors,alpha){
			  #People in x and y
			  nx=1
			  ny=1
			  #Conversions in x and y
			  cx=0
			  cy=0
			  test=vector()
			  diff=vector()
			  for(i in 1:num_visitors){
			    nx = nx + 1
			    if(i%%5==0){
			    	ny= ny+1
			    	cy=cy+rbinom(1,1,Yold)
			    } 
			    #print(nx)
			    cx=cx+rbinom(1,1,Xold)
			    #print(cx)
			    #print(cy)
			    Xn=cx/nx
			    Yn=cy/ny
			    diff[i]=abs(Xn-Yn)
			    Vn=(((Xn*(1-Xn))/nx)+((Yn*(1-Yn))/ny))
			    #print(Vn)
			    test_crit=((2*log(1/alpha)-log(Vn/(Vn+tau)))*((Vn*(Vn+tau))/tau))^.5
			    test[i]=test_crit
			    #print(test[i])
			  }
			  x=data.frame(test[50:num_visitors],diff[50:num_visitors],50:num_visitors,nx,ny)
			  colnames(x) = c("test","diff","index","nx","ny")
			  return(x)
			  
			}

  			q=pretty_coversion(input$sliderX,input$sliderY,input$Tau,input$Visitors,input$Alpha)
  			s=ggplot(q, aes(x=index)) +
      		geom_line(aes(y=test), colour="red")+
      		geom_line(aes(y=diff), colour="blue")+
      		ylab(label="Difference in Conversion Rate")+
      		xlab(label="Number of visits in X")
  			print(s)
		  }
		
	})
	output$Textout <- renderText({
		if(input$split=="even"){
			paste("Number of people in X: ", input$Visitors, "Number of people in Y: ", input$Visitors)
			} else{
				paste("Number of people in X: ", input$Visitors, "Number of people in Y: ", input$Visitors*.2)
			}
		})
})