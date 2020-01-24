#安裝mlogit套裝
install.packages(mlogit)
library(mlogit)

#讀入橫式資料
data <- read.csv(file="widedata.csv", header=TRUE, sep=",")
data$X <- NULL

#進行資料轉置 #修改Varying的範圍
df2 <- mlogit.data(data, varying=2:29, choice="MODE", shape="wide")

#放入變數，進行模式校估
model1 <- mlogit(MODE ~ Inv+Tripcost+Transfer | Num.car+Num.scoot , data=df2, reflevel="car")
summary(model1)



#為所有運具創造dummy變數
df2$car <- ifelse(df2$alt=="car",1,0)
df2$bus <- ifelse(df2$alt=="bus",1,0)
df2$scoot <- ifelse(df2$alt=="scoot",1,0)
df2$mrt <- ifelse(df2$alt=="mrt",1,0)

#將方案特定變數以 I(X*dummy)的形式，依需要填在"|"前
mlogit.model1 <- mlogit(MODE ~ Inv+Tripcost+Transfer+I(Num.scoot*scoot)+I(Num.scoot*mrt)+I(Num.car*scoot)+I(Num.car*mrt) | 1 , data=df2, reflevel="car")
summary(mlogit.model1)


#找Log-liklihood (0)
mlogit.model2 <- mlogit(MODE ~ 1 | 1, data=df2, reflevel="car")
summary(mlogit.model2)


LLB <- -4898.7
LL0 <- -5260
rho_square <- 1- (LLB/LL0)
rho_square
