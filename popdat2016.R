# Tableau data preparation
library(RSQLite)
library(DBI)



df6 <- read.csv("https://www2.census.gov/programs-surveys/popest/datasets/2010-2019/counties/totals/co-est2019-alldata.csv")


con <- dbConnect(RSQLite::SQLite(), ":memory:")
dbWriteTable(con, "df6", df6)

res <- dbSendQuery(con, "SELECT DISTINCT STNAME, POPESTIMATE2016 FROM df6 WHERE STNAME == CTYNAME")
df6_filtered <- dbFetch(res)

write.csv(df6_filtered, "data/df6.csv")

## Clean up
files <- dir(path=tempdir(), pattern="df6*")
unlink(x=files)

dbDisconnect(con)
