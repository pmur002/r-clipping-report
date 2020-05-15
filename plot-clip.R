plot(mpg ~ disp, mtcars, pch=21, bg="grey")
text(mpg ~ disp, mtcars, label=rownames(mtcars), pos=1, col=hcl(0, 80, 60))
