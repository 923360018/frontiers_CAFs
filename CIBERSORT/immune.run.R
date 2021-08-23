source("CIBERSORT.R")
results=CIBERSORT("ref.txt", "normalize.txt", perm=100, QN=F)

write.table(results,file="results.txt",sep="\t",quote=F,col.names=T)
