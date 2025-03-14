# This script is used to plot single gene's high and low barcode lfc plot in one figure meantime

Highmin <- min(High$sgrna_lfc)
Highmax <- max(High$sgrna_lfc)
Lowmin <- min(Low$sgrna_lfc)
Lowmax <- max(Low$sgrna_lfc)

xlim <- c(min(Highmin, Lowmin) - 1, max(Highmax, Lowmax) + 1)
gene<-list("IGF2BP1", "JMJD6", "EIF4H", "MRPS9","EXOSC2","RNASE11","SNX10","HNRNPU","IGF2BP2","IGF2BP3")
# top and bottom are segments' begin and end positions
ytop <- c(2.5, 5)
ybottom <- c(0.5, 3)
# xleft and right are used to define the plot border
xleft<-rep(xlim[1]+1,length(ybottom))
xright<-rep(xlim[2]-1,length(ybottom))

# This section defines segments' color and linewidth("lwd")'s parameters 
allcolor <- adjustcolor("#D3D3D3", alpha.f = 0.3)
alllwd <- 0.1

zerocolor <- adjustcolor("#FFF700", alpha.f = 1)
zerowd <- 0.8

targetcolor <- adjustcolor("#FF0000", alpha.f = 1)
targetwd <- 1.2

for (g in gene) {
  png(paste0(g, "_lfc_barcode.png"), res = 800, width = 18, height = 12, units = "cm")
  plot(NA,type = 'n',xlim = xlim,ylim = c(0,6),axes = F,ann = T,xlab='',ylab='',cex.lab=1.3)
  axis(1, lty = 1, font = 2, cex.axis = 1.2, lwd = 2, tcl = -0.4, mgp = c(0, 0, -1))
  axis(2,at=(ytop-ybottom)/2+ybottom,labels = c("Low", "High"),las=2,tcl=0,lty = 0,font = 2,cex.axis=1.2,mgp=c(-2,-1.5,-1),)
  mtext(g, side = 1, line = 1.5, cex = 1.3)
  # This section plots the lfc data in High vs Input sample
  High_lfc = subset(High,Gene_ID==g)$sgrna_lfc
  for(x in 1:length(High$Gene_ID)){
    segments(High$sgrna_lfc[x], ybottom[2], High$sgrna_lfc[x], ytop[2], col = allcolor, lwd = alllwd)
  }
  segments(0, ybottom[2], 0, ytop[2], col = zerocolor, lty = 2, lwd = zerowd)
  for (x in 1:length(High_lfc)){
    segments(High_lfc[x],ybottom[2],High_lfc[x],ytop[2],col = targetcolor, lwd = targetwd)
  }
  
  # This section plots the lfc data in Low vs Input
  Low_lfc = subset(Low,Gene_ID==g)$sgrna_lfc
  for(x in 1:length(Low$Gene_ID)){
    segments(Low$sgrna_lfc[x], ybottom[1], Low$sgrna_lfc[x], ytop[1], col = allcolor, lwd = alllwd)
  }
  segments(0, ybottom[1], 0, ytop[1], col = zerocolor, lty = 2, lwd = zerowd)
  for (x in 1:length(Low_lfc)){
    segments(Low_lfc[x],ybottom[1],Low_lfc[x],ytop[1],col = targetcolor, lwd = targetwd)
  }
  rect(xleft = xleft,xright = xright,ybottom = ybottom,ytop = ytop,col=NA,border = 'black', lwd = 1.5)
  dev.off()
}
