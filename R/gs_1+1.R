#plus11<- sapply(plus11sample, function(x){x$getElementText()})
#plus11<- c(plus11, unlist(repl))
#more$clickElement()
#plus11sample$clickElement()

as.Date(Sys.Date()) #년, 월, 일

library(stringr)
library(RSelenium)
library(dplyr)
remDr <- remoteDriver(remoteServerAddr = "localhost" , port = 4445, browserName = "chrome")
remDr$open()
url <- 'http://gs25.gsretail.com/gscvs/ko/products/event-goods'
remDr$navigate(url)


#1+1

more<-remDr$findElement(using='css','#ONE_TO_ONE ')
more$getElementTagName()
more$getElementText()
more$clickElement()

plus1sample<-NULL
plus1name<-NULL
plus1manuf<-NULL
plus1price <- NULL
plus1date <- NULL
plus1store <- NULL
for(i in 1:22){
  for(n in 1:8){
    
    #상품명
    plus1sample <- remDr$findElement(using='css',paste0("#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(3) > ul > li:nth-child(",n,") > div > p.tit"))
    plus1name<- append(plus1name,plus1sample$getElementText())
    
    #가격
    plus1sample <- remDr$findElement(using='css', paste0("#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(3) > ul > li:nth-child(",n,") > div > p.price > span"))
    plus1price<- append(plus1price,plus1sample$getElementText())
    
    #날짜
    plus1date <- append(plus1date, Sys.Date())
    
    #유통업체
    plus1store <- append(plus1store, "GS리테일")
  }
  more<-remDr$findElement(using='css','#contents > div.cnt > div.cnt_section.mt50 > div > div > div:nth-child(3) > div > a.next')
  more$getElementTagName()
  more$getElementText()
  more$clickElement()
  Sys.sleep(1)
}

#제조사) 가져오기
plus1name%>% str_extract(., "[[가-힣]\\w]{1,}[)]" )%>% gsub(")","",.)->plus1manuf


#상품명만 남기기
plus1name%>% str_extract(.,"[)]{1}[[가-힣]\\w]{1,}")%>% gsub(")","",.)->plus1name

#가격
plus1price%>% gsub("원","",.) ->plus1price

#cbind

gsplus1product <- data.frame(plus1date1, plus1name, plus1store, plus1price, plus1manuf)
View(gsplus1product)
names(gsplus1product)=c("기준날짜","상품명","판매업소","판매가격","제조사")


write.csv(gsplus1product,"gs1+1.csv")
