library(ggpubr)
rt=read.table("immune.txt",header = TRUE, row.names = 1)     
group=read.table("risk.txt",sep="\t",check.names=F,header=T,row.names=1,)
table(group$risk)
group=group[order(group$risk),]
index=as.character(rownames(group))

rt=rt[,index]
identical(rownames(group),colnames(rt))
rt=t(rt)
risk=c(rep("high",485),rep("low",485))
risk
data=data.frame()
for(i in colnames(rt)){
  data=rbind(data,cbind(expression=log2(rt[,i]+1),gene=i,risk))
}
write.table(data,file="riskimmbox.txt",sep="\t",row.names=F,quote=F)

data=read.table("riskimmbox.txt",sep="\t",header=T,check.names=F)      
p=ggboxplot(data, x="gene", y="expression", 
            fill="risk",
     ylab="Gene expression",
     xlab="",
     sort.val="desc",
     sort.by.groups=T,
     scale_x_discrete(limits=c("low", "high")), 
     palette=c("#EA5413","#009FE9"),
     outlier.size = 0.5 
     )
pdf(file="boxplot.pdf",width=18.2,height=6.59)                         
p + theme(axis.text.x = element_text(size = 10, 
                                     angle = 15)) +labs(x = NULL)+ stat_compare_means(aes(group = risk),label = "p.signif")

dev.off()
