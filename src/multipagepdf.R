library(grid)
grid.arrange(rectGrob(), rectGrob())
## Not run:  
library(ggplot2)
pl <- lapply(1:11, function(.x) qplot(1:10, rnorm(10), main=paste("plot", .x)))
ml <- marrangeGrob(pl, nrow=2, ncol=2)
## non-interactive use, multipage pdf
ggsave("doc/multipage.pdf", ml)
## interactive use; open new devices
ml

## End(Not run)
