# lib
pkgTest <- function(x)
{
  if (!require(x, character.only = TRUE))
  {
    install.packages(x, dep = TRUE)
    if (!require(x, character.only = TRUE))
      stop("Package not found")
  }
}
pkgTest("twitteR")



# 定数
usrName <- 'USER_NAME' # 対象アカウントのscreenname

# Key, Secret
consumerKey <- ""
consumerSecret <- ""
accessToken <- ""
accessSecret <- ""

setup_twitter_oauth(consumerKey, consumerSecret, accessToken, accessSecret)
usr <- getUser(usrName)
cnt <- usr$statusesCount
maxI <- ceiling(cnt / 3200 + 1)
statuses <- NULL
scId <- NULL
for (i in 1:maxI) {
  m <- userTimeline(
    usrName,
    n = 3200,
    maxID = scId,
    sinceID = NULL,
    includeRts = TRUE,
    excludeReplies = FALSE
  )
  df <- twListToDF(m)
  
  options(scipen = 100)
  scId <- df[nrow(df), 'id']
  cat(i, scId, '\n', sep = ':')
  
  if(!is.null(statuses)){
    if(df[1,'id'] == statuses[nrow(statuses),'id']){
      df <- df[-1, ]
    }
  }
  statuses <- rbind(statuses, df)
}

# 書き出し
write.csv(statuses, paste(usrName, '.utf8.csv', sep = ''), fileEncoding = 'UTF-8')
write.csv(statuses, paste(usrName, '.sjis.csv', sep = ''), fileEncoding = 'CP932')
