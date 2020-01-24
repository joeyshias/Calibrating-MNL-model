library(base)
#設定資料夾位置
setwd(dir = "C:/...")

#匯入三個重要檔案。
Sample <- read.csv(file="Sample.csv", header=TRUE, sep=",")
Variables <- read.csv(file="Ver.Q.variables.csv", header=TRUE, sep=",")
Bait <- read.csv(file = "Bait.csv", header=TRUE, sep=",")
Ver.Q.altname <- read.csv(file = "Ver.Q.altname.csv", header=TRUE, sep=",")

Bait.plus <- merge(x = Bait,y = Variables, by= "Ver.Q", all.x=TRUE, all.y=FALSE)
data <- merge(x = Bait.plus ,y = Sample,by = "Respondent",all.x = TRUE, all.y = FALSE)

data$Choice <- 0
names(data)
data[data$Q.num==1,44] <- data[data$Q.num==1,40]
data[data$Q.num==2,44] <- data[data$Q.num==2,41]
data[data$Q.num==3,44] <- data[data$Q.num==3,42]
data[data$Q.num==4,44] <- data[data$Q.num==4,43]


data$Ver.Q.choice <- data$Ver.Q*10 + data$Choice
data <- merge(x = data,y = Ver.Q.altname, by = "Ver.Q.choice",all.x = TRUE, all.y = FALSE)


data <- data[order(data$Respondent),]
names(data)
data <- data[,c(46,6:33,36:38)]
ncol(data)
row.names(data) <- (1:nrow(data))

write.csv(data,file = "widedata.csv")
