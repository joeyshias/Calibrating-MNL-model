library(base)
#設定資料夾位置
setwd(dir = "C:/Users/ASUS/Dropbox/實習生宇軒/6624_MC/")

#匯入三個重要檔案。
Sample <- read.csv(file="Logit校估資料整理/Sample.csv", header=TRUE, sep=",")
Options <- read.csv(file="Logit校估資料整理/Options 0214.csv", header=TRUE, sep=",")
Bait <- read.csv(file = "Logit校估資料整理/Bait.csv", header=TRUE, sep=",")
#Sample為受試者資料
#Options為SP問卷的選項
#Bait為事先整理好的魚餌，由魚餌作開頭，把Option資料及Sample資料，按照順序接在後面


#把Options裡面的問項，依照Bait上的順序，就可以將問項排列多次。(以下使用的是join的功能)
Option.unroll <- merge(x = Bait,y = Options, by= "Ver.Q.Choice", all.x=TRUE, all.y=FALSE)

#下面程式碼，用來檢查的，如果回傳三個TRUE，表示配對正確
test1 <- Option.unroll$Version.x == Option.unroll$Version.y
all(test1)
test2 <- Option.unroll$Choice.num.x == Option.unroll$Choice.num.y
all(test2)
test3 <- Option.unroll$Q.num.y == Option.unroll$Q.num.x
all(test3)


#把join完後重複的欄位刪除
Option.unroll$Version.y <- NULL
Option.unroll$Choice.num.y <- NULL
Option.unroll$Q.num.y <- NULL

#重新命名欄位
names(Option.unroll)
names(Sample)
colnames(Option.unroll)[3] <- "Version"
colnames(Option.unroll)[4] <- "Q.num"
colnames(Option.unroll)[5] <- "Choice.num"

#利用join功能，將受試者的個人資料匯進來
data <- merge(x = Option.unroll,y = Sample,by = "Respondent",all.x = TRUE, all.y = FALSE)
colnames(data)[7] <- "Mode"


#下面程式碼，用來檢查的，如果回傳TRUE，表示配對正確
test4 <- data$Version.x == data$Version.y
all(test4)

#創建新的欄位
data$Respond <- 0   
data$choice <- 0  


#調整欄位排序，調到合適的排序
names(data)
data <- data[,c(6,1,16,17,7,8,46,47,9:14,27:45,3:5,2)]


#將受試者的答案，由第一題到第四題，依序填入Respond欄位裡
data[data$Q.num==1,7] <- data[data$Q.num==1,30]
data[data$Q.num==2,7] <- data[data$Q.num==1,31]
data[data$Q.num==3,7] <- data[data$Q.num==1,32]
data[data$Q.num==4,7] <- data[data$Q.num==1,33]

#將受試者勾選的運具，Choice標記為1
data[data$Respond == data$Choice.num, 8] <- 1
data <- data[order(data$Sample),]

#輸出
write.csv(data,file = "Logit校估資料整理/TN_MCdata2019.csv")

