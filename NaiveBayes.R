#Max Roth
#Naive Bayes Classify function
#Input the independant and dependant columns separtely. The Dependant column is the one will want to predict
#The output Shows Proabability of the variable = value given the column.

NB.classify<-function(ind,dep){
  rowname=vector()
  colname=vector()
  features=vector()
  dat=data.frame(ind,dep)
  d=dat[,dim(dat)[2]]
  prob=vector()
  for(i in 1:length(levels(d))){
    #temp data frame with given indpepend col =
    temp=data.frame(dat[ which(dat[dim(dat)[2]]==levels(d)[i]),])
    temp[,dim(temp)[2]]=NULL
    colname=c(colname,paste('Given',levels(d)[i]))
    #for each variable in temp
    for(j in 1:dim(temp)[2]){
      #and for each facotr in each variable
      for(k in 1:length(levels(as.factor(temp[,j])))){
        prob=c(prob,length(temp[j][ which(temp[j]==levels(as.factor(temp[,j]))[k]),])/(dim(temp[j])[1]))
        if(i==1){
          temp.rowname=paste("P(",names(temp[j]),"=",levels(as.factor(temp[,j]))[k],")")
          rowname=c(rowname,temp.rowname)
          features=c(features,levels(as.factor(temp[,j]))[k])
        }
      }
    }
  }
  mat.name=list(rowname,colname)
  pretty=matrix(prob,nrow=length(rowname),ncol=length(colname),dimnames=mat.name)
  data.frame(pretty,features)
}

#EXAMPLE
#Make a data set with discrete variables

options(digits=5)
x=c('a','b','c')
x=as.factor(sample(x,150,replace=T))
y=c('Yes', 'No','maybe')
y=as.factor(sample(y,150,replace=T))
t=c('male','female')
t=as.factor(sample(z,150,replace=T))
c=data.frame(x,y,t)
#head(c)

prob.vect=NB.classify(c[1:2],c[3])
prob.vect

#prediction
newobs=c('c','maybe')
NB.Predict<-function(prob.vect,newobs){
classify.matrix=list()
for(ii in 1:length(newobs)){
  classify.matrix[[ii]]=prob.vect[ which(prob.vect$features==newobs[ii]),]
}
classify.matrix=do.call(rbind, classify.matrix)
classify.matrix[,dim(classify.matrix)[2]]=NULL
decision=apply(classify.matrix,2,prod)
sort(decision, decreasing=T)
}

NB.Predict(prob.vect,newobs)