library(grid)
runR <- function(file, label=gsub(".R", "", file), width=7, height=7,
                 xfig=FALSE) {
    if (xfig) {
        figfile <- paste0(label, ".fig")
        xfig(figfile)
        pushViewport(viewport(width=unit(width, "in"), 
                              height=unit(height, "in")))
        grid.rect(gp=gpar(col="grey"))
        pushViewport(viewport(width=.8, height=.8, clip=TRUE))
        grid.rect(gp=gpar(col="grey90", fill="grey90"))
    } else {
        svg(paste0(label, ".svg"), width, height)
    }
    ## Print to make sure plots are displayed
    source(file, print.eval=TRUE)
    dev.off()
    if (xfig) {
        pngfile <- gsub("[.]fig", ".png", figfile)
        system(paste0("fig2dev -L png ", figfile, " ", pngfile))
    }
}    
