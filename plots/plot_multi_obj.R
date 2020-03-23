
setwd("/Volumes/STEPHANIE/writeup/cambridge/sensor placement/code")
poi <- read.csv("poi_1.csv")
# get pop selection
S_pop_6 = S_pop_10[1:7]
pop_table_center_6 = pop_table_center[S_pop_6$S,]


# get traffic selection
traffic_poi <- read.csv("road_importance.csv")

# get poi selection
selected_id = c(0, 4, 11, 15, 18, 42, 54)
selected_id = selected_id + 1 # due to python starting from 0
poi_selected = poi[selected_id,]

camMap+
  geom_point(aes(x=lon, y=lat), data=poi_selected, alpha=1, col="black",
             size=5,shape=15) +
  geom_point(aes(x=lon, y=lat), data=poi_selected, alpha=0.8,col='red',
             size=4.5,shape=15) + 
  geom_point(aes(x=x, y=y), data=pop_table_center_6, alpha=1,col="black",size = 4.5) +
  geom_point(aes(x=x, y=y), data=pop_table_center_6, alpha=0.8,col="yellow",size = 4)+ 
  geom_point(aes(x=lon, y=lat), data=traffic_poi[1:7,], alpha=1, col="black",
             size=4.5,shape=17) +
  geom_point(aes(x=lon, y=lat), data=traffic_poi[1:7,], alpha=0.8,col='blue',
             size=4,shape=17)+
  theme(axis.line=element_blank(),axis.text.x=element_blank(),
        axis.text.y=element_blank(),axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),legend.position="none",
        panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),plot.background=element_blank())+ scale_fill_manual(labels=c("a", "b", "c")) + theme(legend.text = element_text(size = 10),
                                                                                                                              legend.position="bottom")