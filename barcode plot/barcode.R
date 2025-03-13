sg<-High
sg<-sg[order(sg$sgrna_lfc),]

xlim<-c(min(sg$sgrna_lfc)-1,max(sg$sgrna_lfc)+1)
gene<-list("IGF2BP1", "JMJD6", "EIF4H")

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


png("sgr1.png", res = 300, width = 18, height = 16, units = "cm")
plot(NA,type = 'n',xlim = xlim,ylim = c(0,12),axes = F,ann = T,xlab='Log2(Fold change)',ylab='',cex.lab=1.3)
axis(1, lty = 1, font = 2, cex.axis = 1.2, lwd = 2, tcl = -0.4, mgp = c(0, 0, -1))
axis(2,at=(ytop-ybottom)/2+ybottom,labels = gene,las=2,tcl=0,lty = 0,font = 2,cex.axis=1.2,mgp=c(-2,-1.5,-1),)

#segments
for (g in 1:length(gene)){
  lfc=subset(sg,Gene_ID==gene[g])$sgrna_lfc 
  for(x in 1:length(sg$Gene_ID)){
    segments(sg$sgrna_lfc[x], ybottom[g], sg$sgrna_lfc[x], ytop[g], col = rgb(0.8,0.8,0.8,0.5), lwd = 0.5)
  }
  for (x in 1:length(lfc)){
    segments(lfc[x],ybottom[g],lfc[x],ytop[g],col = rgb(1,0,0,1),lwd = 1)
  }
}

rect(xleft = xleft,xright = xright,ybottom = ybottom,ytop = ytop,col=NA,border = 'black')

dev.off()