sg<-High
sg<-sg[order(sg$sgrna_lfc),]

xlim<-c(min(sg$sgrna_lfc)-1,max(sg$sgrna_lfc)+1)
gene<-list("IGF2BP1", "JMJD6", "EIF4H")

allcolor <- adjustcolor("#C0C0C0", alpha.f = 0.2)
alllwd <- 0.3

zerocolor <- adjustcolor("#FFF700", alpha.f = 1)
zerowd <- 0.8

targetcolor <- adjustcolor("#FF0000", alpha.f = 1)
targetwd <- 1.2

ybottom<-c()
ytop<-c()
binwidth = 2
interval = 0.5
for (i in 1:length(gene)){
  ybottom<-append(ybottom,interval*i+binwidth*(i-1))
  ytop<-append(ytop,interval*i+binwidth*i)
}
xleft<-rep(xlim[1]+1,length(ybottom))
xright<-rep(xlim[2]-1,length(ybottom))

png("demo.png", res = 800, width = 18, height = 14, units = "cm")

plot(NA,type = 'n',xlim = xlim,ylim = c(0,8),axes = F,ann = T,xlab='',ylab='',cex.lab=1.3)
axis(1, lty = 1, font = 2, cex.axis = 1.2, lwd = 2, tcl = -0.4, mgp = c(0, 0, -1))
axis(2,at=(ytop-ybottom)/2+ybottom,labels = gene,las=2,tcl=0,lty = 0,font = 2,cex.axis=1.2,mgp=c(-2,-1.5,-1),)

mtext("Log2(Fold change)", side = 1, line = 1.5, cex = 1.3)

#segments
for (g in 1:length(gene)){
  lfc=subset(sg,Gene_ID==gene[g])$sgrna_lfc 
  for(x in 1:length(sg$Gene_ID)){
    segments(sg$sgrna_lfc[x], ybottom[g], sg$sgrna_lfc[x], ytop[g], col = allcolor, lwd = alllwd)
  }
  segments(0, ybottom[g], 0, ytop[g], col = zerocolor, lty = 2, lwd = zerowd)
  for (x in 1:length(lfc)){
    segments(lfc[x],ybottom[g],lfc[x],ytop[g],col = targetcolor, lwd = targetwd)
  }
}

rect(xleft = xleft,xright = xright,ybottom = ybottom,ytop = ytop,col=NA,border = 'black', lwd = 1.5)

# png("demo.png", res = 3000, width = 16, height = 15, units = "cm")
dev.off() # Must contain this command, or the figure will not be stored