library(ggmap)
library(ggplot2)
library(rgdal)
# read in the data
# ! the position may change
#setwd("/Users/stephanie/Desktop")
#load(".RData")
setwd("/Volumes/STEPHANIE/writeup/cambridge/sensor placement/code")
poi <- read.csv("road_importance.csv")

register_google(key = "AIzaSyAippc0YN-rbTuUevlRZK-k8WjwJFGN3YA")
camMap = ggmap(get_googlemap(center=c(0.1229,52.205067), scale=1, zoom=13
                             ,size = c(640, 640),maptype='roadmap'),alpha = .5,legend="right")
camMap+geom_point(aes(x=lon, y=lat), data=poi, alpha=1, col="black",
                  size=2.5) + geom_point(aes(x=lon, y=lat), data=poi, alpha=0.8,col='red',
                                         size=2) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                         axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                         axis.title.x=element_blank(),
                                                         axis.title.y=element_blank(),legend.position="none",
                                                         panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                                         panel.grid.minor=element_blank(),plot.background=element_blank())+ scale_fill_manual(labels=c("a", "b", "c")) + theme(legend.text = element_text(size = 10),
                                                                                                                                                                               legend.position="bottom")

