library(ggmap)
library(ggplot2)

# read in the data
# ! the position may change
setwd("/Users/stephanie/Desktop")
load(".RData")

cam_center = c(52.205067, 0.107760)

#camMap = ggmap(get_googlemap(center=c(52.205067, 0.107760), scale=2, zoom=21,size = c(640, 600),maptype='roadmap'),alpha = .5)
camMap = ggmap(get_googlemap(center=c(0.1229,52.205067), scale=1, zoom=13
                             ,size = c(640, 640),maptype='roadmap'),alpha = .5,legend="right")

camMap + geom_point(aes(x=lon, y=largest_idx), data=sensor_gps, col="black",size = 4.5) +geom_point(aes(x=lon, y=largest_idx), data=sensor_gps, col="red",size = 4)+ theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                    axis.text.y=element_blank(),axis.ticks=element_blank(),
                                    axis.title.x=element_blank(),
                                    axis.title.y=element_blank(),legend.position="none",
                                    panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                    panel.grid.minor=element_blank(),plot.background=element_blank())
