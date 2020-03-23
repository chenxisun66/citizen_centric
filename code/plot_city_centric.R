library(rgdal)
library(raster)
library(ggmap)
register_google(key = "AIzaSyAippc0YN-rbTuUevlRZK-k8WjwJFGN3YA")
r <- rasterFromXYZ(as.data.frame(pop_table)[, c("x", "y", "sta")])
lat1 = 52.170841
lon1 = 0.080505
lat2 = 52.234911
lon2 = 0.186420
pop_table_center = subset(pop_table, x>=lon1 & x<=lon2)
pop_table_center = subset(pop_table_center, y>=lat1 & y<=lat2)
pop_table_center[is.na(pop_table_center)] <- 0
names(pop_table_center) <- c("x", "y", "population")
r <- rasterFromXYZ(as.data.frame(pop_table_center)[, c("x", "y", "population")])
#plot(r)


rtp <- rasterToPolygons(r)
rtp@data$id <- 1:nrow(rtp@data)   # add id column for join

rtpFort <- fortify(rtp, data = rtp@data)
rtpFortMer <- merge(rtpFort, rtp@data, by.x = 'id', by.y = 'id')  # join data

bm <- ggmap(get_map(location = c(0.1229,52.205067), zoom = 13))
#,maptype='roadmap'
bm <- ggmap(get_map(location=c(0.1229,52.205067), source ="google",scale=1, zoom=13),alpha = .5,extent = "device",legend="bottomleft")
bm + geom_polygon(data = rtpFortMer, 
                  aes(x = long, y = lat, group = group, fill = population), 
                  alpha = 0.5, 
                  size = 0) +  ## size = 0 to remove the polygon outlines
  scale_fill_gradientn(colours = hsv(1, seq(0,1,length.out = 20) , 1))+theme(axis.text=element_text(size=16),
         axis.title=element_text(size=14,face="bold"))
#topo.colors(255)
#heat.colors(12)


official = data.frame(t(unlist(c(0.124456,52.202370))))

bm+ geom_point(aes(x=X1, y=X2), data=official, col="black",size = 6.5) +geom_point(aes(x=X1, y=X2), data=official, col="red",size = 4)+ theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                                                                                                                                      axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                                                                                                                                      axis.title.x=element_blank(),
                                                                                                                                                                      axis.title.y=element_blank(),legend.position="none",
                                                                                                                                                                      panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                                                                                                                                                      panel.grid.minor=element_blank(),plot.background=element_blank())




# a function to calculate mahattance distance between two grids
manhattan_dist <- function(id1,id2,pop_hk){
  distance = floor(abs(pop_hk[id1,1]-pop_hk[id2,1])/0.0083) +  floor(abs(pop_hk[id1,2]-pop_hk[id2,2])/0.00833)
  return(distance)
}
n = nrow(pop_table_center)
distances=matrix(0, nrow = n, ncol = n) 
# a function to calculate euclidean distance between two grids
for (i in 1:n){
  for (j in i:n){
    distances[i,j] = manhattan_dist(i,j,pop_table_center)
  }
}
# only stored in the upper matrix
# may consider to convert to sparse representation later (can save half)

# load in the saved file
#distances = read.csv("distances.csv",header = FALSE)


# greedy selection: return the row id
human_centric_greedy_selection_o<- function(k,distances,pop_hk,theta){
  #S <- vector(length = k)
  #tmp = pop_hk[,3]
  gain = 0
  S <- c()
  selected = logical(length = nrow(distances))
  for (i in 1:k){
    #tmp_max <- max(tmp)
    #S[i] <- match(tmp_max,pop_hk[,3])
    #tmp <- tmp[-which(tmp==tmp_max)]
    tmp_gain = vector(length = nrow(distances))
    for (s in 1:nrow(distances)){
      if (selected[s]==FALSE){
        distance_reduction = cal_distance_reduction(S, s, distances,theta)
        #print(distance_reduction)
        sat_gain = satisfaction_gain(distance_reduction,pop_hk)
        tmp_gain[s] = sum(sat_gain)        
      }
    }
    
    tmp_max_id = which.max(tmp_gain)
    gain = gain + max(tmp_gain)
    S<-c(S,tmp_max_id)
    selected[tmp_max_id] = TRUE
  }
  return(list("gain" =gain, "S" = S))
}

# calculate the satisfaction gain by adding s to S
# theta is the parameter for controlling the impact of distance
cal_distance_reduction <- function(S, s, distances,theta){
  n = nrow(distances)
  min_distances <- vector(length = n)
  distance_reduction <- rep(0, n)
  for (i in 1:n){
    if(length(S)==0){
      tmp <- distances[s,i] + distances[i,s]
      distance_reduction[i] = exp(-tmp/theta) 
    }
    else{
      min_distances[i] <- min(distances[S,i] + distances[i,S])
      tmp <- distances[s,i] + distances[i,s]
      if(tmp < min_distances[i]){
        distance_reduction[i] = exp(-tmp/theta) - exp(-min_distances[i]/theta)
      } 
    }
  }
  return(distance_reduction)
  #return(list(min_distances=min_distances,distance_reduction=distance_reduction))
}

satisfaction_gain <- function(distance_reduction,pop_hk){
  n = length(distance_reduction)
  sat_gain = vector(length = n)
  for (i in 1:n){
    sat_gain[i] = pop_hk[i,3] *distance_reduction[i]
  }
  return(sat_gain)
}


# maybe consider switching exp(-x) to a more sophisticated modeled function?
# !! population needs to be normalized
S_pop_10 = human_centric_greedy_selection_o(10,distances,pop_table_center,1)
pop_table_center_10 = pop_table_center[S_pop_10$S,]

S_pop_20 = human_centric_greedy_selection_o(20,distances,pop_table_center,1)
pop_table_center_20 = pop_table_center[S_pop_20$S,]

register_google(key = "AIzaSyAippc0YN-rbTuUevlRZK-k8WjwJFGN3YA")
camMap = ggmap(get_map(location = c(0.1229,52.205067), source = "google", zoom = 13, maptype = "roadmap"))

#top_20 <- pop_table_center[with(pop_table_center,order(-population)),][1:10,]
camMap + geom_point(aes(x=x, y=y), data=pop_table_center_10[1:6,], col="black",size = 4.5) +geom_point(aes(x=x, y=y), data=pop_table_center_10[1:6,], col="red",size = 4)+ theme(axis.line=element_blank(),axis.text.x=element_blank(),
                                                                                                                                         axis.text.y=element_blank(),axis.ticks=element_blank(),
                                                                                                                                         axis.title.x=element_blank(),
                                                                                                                                         axis.title.y=element_blank(),legend.position="none",
                                                                                                                                         panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
                                                                                                                                         panel.grid.minor=element_blank(),plot.background=element_blank())




