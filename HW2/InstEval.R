require(rectools)
require(qeML)
set.seed(9999)

head(InstEval)
ncol(InstEval)

InstLin0 <- qeLin(InstEval[,c('s','d','studage','lectage','service','dept')], 'y')
cat('base accuracy: ', InstEvalRes$baseAcc) 
cat('test accuracy: ', InstEvalRes$testAcc)