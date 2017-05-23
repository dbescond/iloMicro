## ----install, eval=FALSE-------------------------------------------------
#  # install.packages("iloMicro")

## ----install2, eval=FALSE------------------------------------------------
#  require(devtools)
#  install_github("dbescond/iloMicro")

## ---- eval=TRUE----------------------------------------------------------
require(iloMicro)
as.data.frame(ls("package:iloMicro")) 

## ----sessioninfo, message=FALSE, warning=FALSE---------------------------
sessionInfo()

