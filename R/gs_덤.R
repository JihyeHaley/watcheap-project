as.Date(Sys.Date()) #년, 월, 일

library(stringr)
library(RSelenium)
library(dplyr)
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()
url <- 'http://gs25.gsretail.com/gscvs/ko/products/event-goods'
remDr$navigate(url)



#덤덤


more<-remDr$findElement(using='css','#GIFT ')
more$getElementTagName()
more$getElementText()
more$clickElement()

plusGiftsample<-NULL
plusGiftname<-NULL
plusGiftmanuf<-NULL
plusGiftprice <- NULL
plusGiftdate <- NULL
plusGiftstore <- NULL
for(i in 1:1){
  for(n in 1:8){
    
    #상품명
    plusGiftsample <- remDr$findElement(using='css',paste0("#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(7) > ul > li:nth-child(",n,") > div > p.tit"))
    plusGiftname<- append(plusGiftname,plusGiftsample$getElementText())
    
    #가격
    plusGiftsample <- remDr$findElement(using='css', paste0("#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(7) > ul > li:nth-child(",n,") > div > p.price > span"))
    plusGiftprice<- append(plusGiftprice,plusGiftsample$getElementText())
    
    #날짜
    plusGiftdate <- append(plusGiftdate, Sys.Date())
    
    #유통업체
    plusGiftstore <- append(plusGiftstore, "GS리테일")
  }
  more<-remDr$findElement(using='css','#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(7) > div > a.next')
  more$getElementTagName()
  more$getElementText()
  more$clickElement()
  Sys.sleep(1)
}

#제조사) 가져오기
plusGiftname%>% str_extract(., "[[가-힣]\\w]{1,}[)]" )%>% gsub(")","",.)->plusGiftmanuf


#상품명만 남기기
plusGiftname%>% str_extract(.,"[)]{1}[[가-힣]\\w]{1,}")%>% gsub(")","",.)->plusGiftname

#가격
plusGiftprice%>% gsub("원","",.) ->plusGiftprice

#cbind

gsplusGiftproduct <- cbind(plusGiftdate, plusGiftname, plusGiftstore, plusGiftprice, plusGiftmanuf)
View(gsplusGiftproduct)
names(gsplusGiftproduct)=c("기준날짜","상품명","판매업소","판매가격","제조사")


write.csv(gsplusGiftproduct,"gs덤.csv")
