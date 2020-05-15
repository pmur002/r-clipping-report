library(grid)
grid.polygon(c(.2, .8, 1.4, .8),
             c(.5, .2, .5, .8),
             gp=gpar(lwd=20, linejoin="mitre", lineend="butt",
                     col=rgb(0,0,0,.5), fill=NA))
