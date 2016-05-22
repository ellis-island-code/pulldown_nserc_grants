# plot NSERC funding 
# written by Brad MacIntosh May 2016

library(XML)

nserc.url<-"http://www.nserc-crsng.gc.ca/NSERC-CRSNG/FundingDecisions-DecisionsFinancement/ResearchGrants-SubventionsDeRecherche/ResultsInsDetail-ResultatsEtabDetails_eng.asp?"
year=2015
num.schools=88
dataout<-as.matrix(NA,ncol=num.schools)
for (institute.index in 1:num.schools) {
  URL<- paste0(nserc.url,"Year=",year,"&Institution=",institute.index)
  tables = readHTMLTable(URL)
  t = data.frame(tables[1])
  # create a list with the school name and number of awards received
  dataout[institute.index]<-sprintf("%s , %1.0f", gsub("Applicant.Name","",names(t)[1]),dim(t)[1]) 
}

# split and unlist the list of schools
nserc.out=matrix(unlist(strsplit(dataout,",")),ncol=2, byrow=TRUE)
# convert the second column to numeric
nserc.out=data.frame(nserc.out[,1],as.numeric(nserc.out[,2]))
# sort based on the number of awards
nserc.out<-nserc.out[order(nserc.out[,2],decreasing=T),]
# remove zero entries
nserc.out<-nserc.out[!nserc.out[,2]==0,]
# remove periods in first column
nserc.out[,1]<-gsub("\\.","",nserc.out[,1])
# remove funky characters in first column
nserc.out[,1]<-gsub("Ã","e",nserc.out[,1])

# create pie chart for the top 20 schools
png(filename="~/Dropbox/MyFinances/NeuranalysisConsulting/piechart_nsercawards.png",width=800,height=500,units="px")
pie(nserc.out[1:20,2],labels=nserc.out[1:20,1],col=terrain.colors(5),main="Top 20 NSERC funded CDN universities by number")
mtext("Data accessed from www.nserc-crsng.gc.ca")
dev.off()

