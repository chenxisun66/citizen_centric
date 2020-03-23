library(ggmap)
library(ggplot2)
library(rgdal)
# read in the data
# ! the position may change
setwd("/Users/stephanie/Desktop")
load(".RData")
#poi <- read.csv("poi_1.csv")
#poi <- read.csv("G:/writeup/cambridge/sensor placement/code/poi_1.csv")
setwd("/Volumes/STEPHANIE/writeup/cambridge/sensor placement/code")
poi <- read.csv("poi_1.csv")
camMap = ggmap(get_googlemap(center=c(0.1229,52.205067), scale=1, zoom=13
                             ,size = c(640, 640),maptype='roadmap',key = 'AIzaSyBwf83B87L-GUOCzJ74AnfMwIwuomB3KtA'),alpha = .5,legend="right")
camMap+geom_point(aes(x=lon, y=lat), data=poi, alpha=1, col="black",
                                      size=2.5) + geom_point(aes(x=lon, y=lat,col = type), data=poi, alpha=0.8,
                                                             size=2) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                    axis.text.y=element_blank(),axis.ticks=element_blank(),
                                    axis.title.x=element_blank(),
                                    axis.title.y=element_blank(),legend.position="none",
                                    panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                    panel.grid.minor=element_blank(),plot.background=element_blank())+ scale_fill_manual(labels=c("a", "b", "c")) + theme(legend.text = element_text(size = 10),
                                                                                                                                                          legend.position="bottom")


# selected 10

selected_id = c(3,4,10,11,15,27,28,46,54,56)
selected_20 = c(2,3,8,9,10,11,16,22,23,24,27,28,30,31,33,41,44,46,47,50)

# add poi cluster result
poi_cluster <-read.csv("G:/writeup/cambridge/sensor placement/code/result_20_obj2.csv")
poi$cluster = poi_cluster$cluster_id

selected_20 = selected_20 + 1 # due to the starting from zero in python
poi_selected = poi[selected_id,]
camMap+geom_point(aes(x=lon, y=lat), data=poi_selected, alpha=1, col="black",
                  size=4.5) + geom_point(aes(x=lon, y=lat), data=poi_selected, col="red", alpha=0.8,
                                         size=4) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                         axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                         axis.title.x=element_blank(),
                                                         axis.title.y=element_blank(),legend.position="none",
                                                         panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                                         panel.grid.minor=element_blank(),plot.background=element_blank())+ scale_fill_manual(labels=c("a", "b", "c")) + theme(legend.text = element_text(size = 10),
                                                                                                                                                                               legend.position="bottom")

poi_20 = poi[selected_20,]
camMap+geom_point(aes(x=lon, y=lat), data=poi_20, alpha=1, col="black",
                  size=4.5) + geom_point(aes(x=lon, y=lat), data=poi_20, col="red", alpha=0.8,
                                         size=4) + theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                         axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                         axis.title.x=element_blank(),
                                                         axis.title.y=element_blank(),legend.position="none",
                                                         panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                                         panel.grid.minor=element_blank(),plot.background=element_blank())+ scale_fill_manual(labels=c("a", "b", "c")) + theme(legend.text = element_text(size = 10),
                                                                                                                                                                               legend.position="bottom")
cols <- c("1"="red","2"="blue","3"="green","4"="orange","5"="yellow",
          "6"="darkgreen","7"="black","8"="purple","9"="skyblue","10"="brown",
          "11"="darkred","12"="darkblue","13"="cyan","14"="violet","15"="pink",
          "16"="lightred","17"="darkgray","18"="darkpurple","19"="darkred","20"="darkorange")
# plot cluster points

# col=factor(cluster)
#+ scale_colour_manual(values = cols,aesthetics = c("colour", "fill"))+ 
camMap + geom_point(aes(x=lon, y=lat,colour=factor(cluster)), data=poi, alpha=0.8,
                                         size=4,show.legend=FALSE) +theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                         axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                         axis.title.x=element_blank(),
                                                         axis.title.y=element_blank(),legend.position="none",
                                                         panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                                         panel.grid.minor=element_blank(),plot.background=element_blank())+ scale_fill_manual(labels=c("a", "b", "c")) + theme(legend.text = element_text(size = 10),
                                                                                                                                                                               legend.position="bottom") 

