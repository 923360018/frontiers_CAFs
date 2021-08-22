

library(ggpubr)
rt=read.table("immune.txt",header = TRUE, row.names = 1)       #读取输入文件
group=read.table("risk.txt",sep="\t",check.names=F,header=T,row.names=1,)#加载分组文件
table(group$risk)
group=group[order(group$risk),]
index=as.character(rownames(group))

rt=rt[,index]
#判断一下顺序和名称是否一致了
identical(rownames(group),colnames(rt))
rt=t(rt)
risk=c(rep("high",485),rep("low",485))
risk
#准备箱线图的输入文件
data=data.frame()
for(i in colnames(rt)){
  data=rbind(data,cbind(expression=log2(rt[,i]+1),gene=i,risk))
}
write.table(data,file="riskimmbox.txt",sep="\t",row.names=F,quote=F)

data=read.table("riskimmbox.txt",sep="\t",header=T,check.names=F)       #读取箱线图输入文件
#绘制箱型图
p=ggboxplot(data, x="gene", y="expression", 
            #color = "risk", 
            fill="risk",
     ylab="Gene expression",
     xlab="",
     sort.val="desc",#下降排序，asc上升排序
     sort.by.groups=T,#按组排序
     scale_x_discrete(limits=c("low", "high")), #选择变量，更改顺序
     palette=c("#EA5413","#009FE9"),
     outlier.size = 0.5 
     )
library(ggThemeAssist)
ggThemeAssistGadget(p)

pdf(file="boxplot.pdf",width=18.2,height=6.59)                          #输出图片文件
p + theme(axis.text.x = element_text(size = 10, 
                                     angle = 15)) +labs(x = NULL)+ stat_compare_means(aes(group = risk),label = "p.signif")

dev.off()
