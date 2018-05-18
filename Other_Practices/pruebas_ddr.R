suppressPackageStartupMessages(library(googleVis))
M <- gvisColumnChart(mtcars, "mpg", "wt")
plot(M)

G <- gvisGeoChart(Exports, "Country", "Profit",options=list(width=200, height=100))
T1 <- gvisTable(Exports,options=list(width=200, height=270))
M <- gvisMotionChart(Fruits, "Fruit", "Year")
GT <- gvisMerge(G,T1, horizontal=FALSE)
GTM <- gvisMerge(GT, M, horizontal=TRUE,tableOptions="bgcolor=\"#CCCCCC\" cellspacing=10")
plot(GTM)


#################
library(plotly)
mtcars
plot_ly(mtcars, x = mtcars$wt, y=mtcars$mpg, mode="markers", color=as.factor(mtcars$cyl))

plot_ly(x=mtcars$wt, y=mtcars$mpg, z=mtcars$cyl, mode="markers", type="scatter3d")
