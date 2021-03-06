library(dplyr)
library(ggplot2)
library(usmap)
library(rvest)
require(janitor)



theme_bill <- function() {
  theme_bw(base_size=12, base_family="Avenir") %+replace%
    theme(
      panel.background  = element_blank(),
      plot.background = element_rect(fill="grey98", colour=NA),
      legend.background = element_rect(fill="transparent", colour=NA),
      legend.key = element_rect(fill="transparent", colour=NA),
      legend.position = "bottom"
    )
}
# ggsave("themes_bill.pdf", device=cairo_pdf, width=6, height=6)


# main data source: https://www.kaggle.com/jpmiller/publicassistance
SNAP_hist <- read.csv("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/SNAP_history_1969_2019.csv", stringsAsFactors=FALSE)
SNAP_hist[14,1] <- "1982"
SNAP_hist <- SNAP_hist %>%
  dplyr::rename(Year=Fiscal.Year)
SNAP_hist$Year <- as.Date(SNAP_hist$Year, format = "%Y")


inflat <- read.csv("https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=748&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=FPCPITOTLZGUSA&scale=left&cosd=1960-01-01&coed=2019-01-01&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Annual&fam=avg&fgst=lin&fgsnd=2009-06-01&line_index=1&transformation=lin&vintage_date=2021-04-28&revision_date=2021-04-28&nd=1960-01-01")
inflat$DATE <- substring(inflat$DATE, 1, 4)
inflat <- dplyr::filter(inflat, DATE > "1968")
inflat <- inflat %>%
  dplyr::rename(Year=DATE, Annual_Rate=FPCPITOTLZGUSA)
inflat$Year <- as.Date(inflat$Year, format = "%Y")

inflat$BackCalc <- NA
nYears <- length(inflat$Year)
d <- 1 # 2020 dollar index value

for (i in 1:nYears){
  d <- d * 100
  d <- d / (100 + inflat$Annual_Rate[nYears-i+1])
  inflat$BackCalc[nYears-i+1] <- d
}

df1 <- full_join(SNAP_hist,inflat, by="Year")
df1$Average.Benefit.Per.Person_adj <- df1$Average.Benefit.Per.Person / df1$BackCalc



# 1 - SNAP benefit over time
ggplot() +
  geom_point(data=df1, aes(x=Year, y=Average.Benefit.Per.Person_adj), size=2, alpha=0.7, color="darkblue") +
  geom_line(data=df1, aes(x=Year, y=Average.Benefit.Per.Person_adj), size=1, color="darkblue") +
  ggtitle("Average SNAP Benefit per Person, 1969-2019", subtitle = "Sources: US Census Bureau, USDA, World Bank") +
  xlab("Fiscal Year") +
  ylab("Avg. Monthly Benefit / Person (2020 USD)") +
  scale_y_continuous(labels=scales::dollar_format(), limits=c(0, 160)) +
  annotate("segment", x = as.Date('1974-7-1'), xend = as.Date('1974-7-1'), y = 0, yend = 160, colour = "grey30", alpha = 0.8) +
  annotate("label", x = as.Date('1974-7-1'), y = 30, label = "1974: \nLinda Taylor trial") +
  annotate("rect", xmin = as.Date('1981-7-1'), xmax = as.Date('1982-7-1'), ymin = 0, ymax = 160, colour = "grey30", alpha = 0.2) +
  annotate("label", x = as.Date('1982-1-1'), y = 70, label = "1981-82: \nReagan-era \nwelfare reform") +
  annotate("segment", x = as.Date('1996-7-1'), xend = as.Date('1996-7-1'), y = 0, yend = 160, colour = "grey30", alpha = 0.8) +
  annotate("label", x = as.Date('1996-7-1'), y = 70, label = "1996: \nClinton-era \nwelfare reform") +
  annotate("segment", x = as.Date('2008-7-1'), xend = as.Date('2008-7-1'), y = 0, yend = 160, colour = "grey30", alpha = 0.8) +
  annotate("label", x = as.Date('2008-7-1'), y = 70, label = "2008: \nFood Stamp \nProgram changed \nto 'SNAP'") +
  theme_bill()



Children <- read.csv("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/WICAgencies2016ytd/Children_Participating.csv")
keeps1 <- c("State.Agency.or.Indian.Tribal.Organization","Average.Participation")
Children <- Children[keeps1]
Children <- Children %>%
  dplyr::rename(Name=State.Agency.or.Indian.Tribal.Organization)


Food_Costs <- read.csv("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/WICAgencies2016ytd/Food_Costs.csv")
keeps2 <- c("State.Agency.or.Indian.Tribal.Organization","Cumulative.Cost")
Food_Costs <- Food_Costs[keeps2]
Food_Costs <- Food_Costs %>%
  dplyr::rename(Name=State.Agency.or.Indian.Tribal.Organization)


est16us <- read.csv("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/est13_16us/est16us.csv", stringsAsFactors=FALSE)
labs <- est16us[1,]
est16us <- est16us %>% janitor::row_to_names(row_number = 1)
keeps3 <- c("State FIPS Code", "Postal Code", "Name", "Poverty Estimate, All Ages", "Poverty Percent, All Ages", "Poverty Estimate, Age 0-17", "Poverty Percent, Age 0-17", "Median Household Income", "Poverty Estimate, Age 0-4", "Poverty Percent, Age 0-4")
est16us_1 <- est16us[keeps3]
est16us_1 <- est16us_1 %>%
  dplyr::rename(PovPctAllAges="Poverty Percent, All Ages",
                PovPct0_17="Poverty Percent, Age 0-17",
                PovPct0_4="Poverty Percent, Age 0-4",
                PC="Postal Code",
                MedInc="Median Household Income")


df2 <- inner_join(Children, Food_Costs, by="Name")
df2 <- na.omit(df2)
df2 <- inner_join(est16us_1, df2, by="Name")
df2$PovPctAllAges <- as.numeric(as.character(df2$PovPctAllAges))
df2$PovPct0_17 <- as.numeric(as.character(df2$PovPct0_17))
df2$PovPct0_4 <- as.numeric(as.character(df2$PovPct0_4))
df2$MedInc <- as.numeric(as.character(df2$MedInc))
df2 <- df2 %>%
  dplyr::rename(fips="State FIPS Code")

ll <- min(df2$PovPctAllAges)
ul <- max(df2$PovPct0_4)



# 2 - Poverty by State, all ages
plot_usmap(regions = "states", data = df2, values = "PovPctAllAges") +
  scale_fill_gradient(name="Poverty %, All Ages (2016)", low="#99FF99", high="#990000", limits=c(ll, ul)) +
  theme_void() +
  theme(legend.position = "bottom") +
  labs(caption = "- US Definition of Poverty: an individual with income less than $36 per day or a family of four with income less than $72 per day", size = 2.5, colour = "black")


# 3 - Poverty by state, ages 0-4
plot_usmap(regions = "states", data = df2, values = "PovPct0_4") +
  scale_fill_gradient(name="Poverty %, Ages 0-4 (2016)", low="#99FF99", high="#990000", limits=c(ll, ul)) +
  theme_void() +
  theme(legend.position = "bottom") +
  labs(caption = "- US Definition of Poverty: an individual with income less than $36 per day or a family of four with income less than $72 per day", size = 2.5, colour = "black")


Avg_Cost <- read.csv("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/WICAgencies2016ytd/Average_Food_Cost_Per_Person.csv", stringsAsFactors=FALSE)
keeps4 <- c("State.Agency.or.Indian.Tribal.Organization", "Cumulative.Average")
Avg_Cost <- Avg_Cost[keeps4]
Avg_Cost <- Avg_Cost %>%
  dplyr::rename(Name=State.Agency.or.Indian.Tribal.Organization)

df2 <- inner_join(df2, Avg_Cost, by="Name")
df2 <- na.omit(df2)

gini <- read.csv("https://datacenter.prb.org/download/usdata/indicator/gini/csv", skip=3)
gini <- gini %>%
  dplyr::filter(TimeFrame == "2014-2018")

df3 <- inner_join(df2, gini, by="Name")
df3 <- df3 %>%
  dplyr::rename(Gini="Data")



# 4 - Median Income vs. Average SNAP Benefit per Child by State
ggplot() +
  geom_point(data=df3, aes(x=MedInc, y=Cumulative.Average, color=Gini), size=3, alpha=0.8) +
  geom_text(data=df3, aes(x=MedInc, y=Cumulative.Average, label=ifelse(Gini == max(Gini) | Gini == min(Gini), as.character(Name),'')), vjust=1.5) +
  scale_colour_gradient(low = "lightblue", high = "#443010") +
  xlab("Median Income (USD)") +
  ylab("Average SNAP Cost per Child (USD)") +
  scale_x_continuous(labels=scales::dollar_format()) +
  scale_y_continuous(labels=scales::dollar_format()) +
  ggtitle("SNAP Cost per Child vs. Median Income by State (2016)", subtitle = "Sources: US Census Bureau, USDA, datacenter.prb.org") +
  theme_bill()



library(ggrepel)


df6 <- read.csv("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/df6.csv")
pop16_50 <- sum(df6$POPESTIMATE2016)


TotParticip <- read.csv("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/WICAgencies2016ytd/Total_Number_of_Participants.csv")
TotParticip <- TotParticip[complete.cases(TotParticip), ]
keeps5 <- c("State.Agency.or.Indian.Tribal.Organization","Average.Participation")
TotParticip <- TotParticip[keeps5]
TotParticip <- TotParticip %>%
  dplyr::rename(Name=State.Agency.or.Indian.Tribal.Organization)


# source: http://navajotimes.com/news/2012/0112/012612census.php
reservation_percentage <- 0.22
# source: https://www.census.gov/newsroom/facts-for-features/2017/aian-month.html#:~:text=6.7%20million,the%20total%20population%20in%202016.
# native population living on reservations (approx.)
nativepop16 <- 6700000 * reservation_percentage


# source: https://www.ncsl.org/Portals/1/Documents/magazine/articles/2018/SL_0118-Stats.pdf
territoriespop16 <- 3789851
territories <- c("Guam", "American Samoa", "Northern Marianas", "Puerto Rico", "Virgin Islands")
territoriesParticip <- TotParticip[TotParticip$Name %in% territories,]
territoriesParticip <- sum(territoriesParticip$Average.Participation)


states <- df6$STNAME
# Mountain Plains is part of a SNAP-Ed program to get children and adults in mountain region states to eat healthier
# includes some American Indians living on reservations
# I estimated this using the 3% American Indian participation times 22% of overall American Indians that live on reservations
# I account for this after transforming the data
# source: https://community-nutrition-education.extension.org/wp-content/uploads/2020/09/MPR-Impact-Report_Print-Ready.pdf
levels(states) <- c(levels(states),as.factor("Mountain Plains"))
nativeParticip <- TotParticip[TotParticip$Name %in% territories == FALSE & TotParticip$Name %in% states == FALSE,]
nativeParticip <- nativeParticip %>%
  dplyr::filter(Name != "Mountain Plains")
nativeParticip <- sum(nativeParticip$Average.Participation)


TotParticip <- TotParticip[complete.cases(TotParticip), ]
statesParticip <- TotParticip %>%
  dplyr::filter(Name %in% states)
statesParticip <- sum(statesParticip$Average.Participation)


MtnPlns <- TotParticip %>%
  dplyr::filter(Name == "Mountain Plains")
MtnPlnsParticip <- as.numeric(MtnPlns$Average.Participation)


totPop16 <- pop16_50 + territoriespop16 + nativepop16
totParticip16 <- statesParticip + territoriesParticip + nativeParticip + MtnPlnsParticip


MtnPlnsUS <- MtnPlnsParticip * (1 - reservation_percentage) * (1 - 0.03)
MtnPlnsRes <- MtnPlnsParticip - MtnPlnsUS


df7 <- data.frame(
  category=c("50 States + DC", "US Territories", "American Indian Reservations"),
  Population=c(pop16_50/totPop16, territoriespop16/totPop16, nativepop16/totPop16),
  Population_label=c(scales::label_percent(accuracy=0.001)(pop16_50/totPop16), scales::label_percent(accuracy=0.001)(territoriespop16/totPop16), scales::label_percent(accuracy=0.001)(nativepop16/totPop16)),
  Participation=c((statesParticip+MtnPlnsUS)/totParticip16, territoriesParticip/totParticip16, (nativeParticip+MtnPlnsRes)/totParticip16),
  Participation_label=c(scales::label_percent(accuracy=0.001)((statesParticip+MtnPlnsUS)/totParticip16), scales::label_percent(accuracy=0.001)(territoriesParticip/totParticip16), scales::label_percent(accuracy=0.001)((nativeParticip+MtnPlnsRes)/totParticip16))
  #Rate=c(scales::label_percent(accuracy=0.001)(statesParticip/pop16_50), scales::label_percent(accuracy=0.001)(territoriesParticip/territoriespop16), scales::label_percent(accuracy=0.001)(nativeParticip/nativepop16))
)


require(reshape)
df7 <- reshape::melt(df7, id=c("category", "Population_label", "Participation_label"))
for (i in 1:length(df7$Population_label)){
  if (df7$variable[i] != "Population"){
    df7$Population_label[i] <- " "
  }
}
for (i in 1:length(df7$Participation_label)){
  if (df7$variable[i] != "Participation"){
    df7$Participation_label[i] <- " "
  }
}
df7$label <- rep(0, length(df7$variable))
for (i in 1:length(df7$label)){
  if (is.na(df7$Population_label[i])){
    df7$label[i] <- as.character(df7$Participation_label[i])
  }
  if (is.na(df7$Participation_label[i])){
    df7$label[i] <- as.character(df7$Population_label[i])
  }
}
df7 <- df7[c("category", "variable", "value", "label")]



# 6 - SNAP Participation in 50 States + DC vs. US Territories vs. Indian Reservations
ggplot(df7, aes(
  x=variable,
  y=value,
  group=category,
  label=label
)) +
  geom_col(aes(fill=category)) +
  coord_flip() +
  coord_polar("y") +
  scale_y_continuous(labels=scales::percent_format()) +
  ggtitle("SNAP Participation Makeup (Outer) vs. \nUS Population Makeup (Inner) - 2016", subtitle = "Sources: US Census Bureau, USDA, navajotimes.com, \nwww.ncsl.org, community-nutrition-education.extension.org") +
  theme_bill() +
  ggrepel::geom_label_repel(box.padding = 1, label.padding = 0.3, label.size = 0.3, point.padding = .1, color="#111111", alpha=0.6, position = position_stack()) +
  theme(axis.title.x=element_blank(),
        axis.title.y=element_blank()) +
  labs(caption = "- US Territories: Puerto Rico, Guam, Virgin Islands, \nAmerican Samoa, and Northern Marianas.", size = 2.5, colour = "black")



library(readxl)
library(dplyr)
library(stringr)
# source: https://www.ers.usda.gov/media/10674/trends.xlsx
df8 <- read_excel("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/trends.xlsx", sheet=1, col_names=TRUE, skip=1)
df8 <- as.data.frame(na.omit(df8))
names(df8) <- str_replace_all(names(df8), c(" " = ""))
df8 <- df8 %>%
  dplyr::rename(Food_Insecure='Foodinsecurity(includeslowandverylowfoodsecurity)',
         Very_Insecure=Verylowfoodsecurity)
df8$Year <- as.Date(df8$Year, format = "%Y")


df1$Year <- as.Date(df1$Year, format = "%Y")
df8.1 <- inner_join(df1, df8, by="Year")
df8.1$Year <- substr(df8.1$Year, 1, 4)
df8.1$Food_Insecure <- as.numeric(df8.1$Food_Insecure)/100
df8.1$Very_Insecure <- as.numeric(df8.1$Very_Insecure)/100



# 7 - Hunger vs. SNAP Funding, 1995-2019
ggplot(data=df8.1, aes(x=Average.Benefit.Per.Person_adj, y=Food_Insecure, label=ifelse(as.numeric(Year) %% 5 == 0 | Year == max(Year), as.character(Year), ""))) +
  geom_point(size=4, color="red", alpha=0.4) +
  geom_segment(data=df8.1, color="red",
                aes(
                    xend=c(tail(Average.Benefit.Per.Person_adj, n=-1), NA),
                    yend=c(tail(Food_Insecure, n=-1), NA)
                  ),
                  arrow=arrow(length=unit(0.4, "cm"))
      ) +
  annotate("rect", xmin = 122, xmax = 150, ymin = .1445, ymax = .148, colour = "grey30", alpha = 0.2) +
  annotate("label", x = 118, y = .145, label = "2008-09: \nGreat Recession") +
  geom_text_repel(box.padding=2, alpha=0.5) +
  theme_bill() +
  scale_x_continuous(labels=scales::dollar_format()) +
  scale_y_continuous(labels=scales::percent_format()) +
  xlab("Average Monthly Benefit per Person (2020 USD)") +
  ylab("% of Americans Who are Food Insecure") +
  ggtitle("Food Insecurity vs. Average SNAP Benefit per Person, 1995-2019", subtitle="Sources: US Census Bureau, USDA") +
  labs(caption = "- The USDA defines food insecurity as a lack of consistent access to enough food for an active, healthy life.", size = 2.5, colour = "black")



df9 <- df8.1 %>%
  dplyr::filter(Year == 2016)
df9 <- df9[c("Total.Benefits.M.","Other.Costs")]
df9$Total.Benefits.M. <- as.numeric(str_replace_all(df9$Total.Benefits.M., c("," = "")))
df9$Other.Costs <- as.numeric(str_replace_all(df9$Other.Costs, c("," = "")))
df9 <- df9 %>%
  dplyr::rename("Total Benefits" = "Total.Benefits.M.",
                "Other Costs" = "Other.Costs")


valid <- c("Total Benefits", "Other Costs")
# source: https://fns-prod.azureedge.net/sites/default/files/snap/FY16-State-Activity-Report.pdf
df9$'Household Errors' <- 421.934288
df9$'Agency Errors' <- 188.859846
df9$'Fraud Claims' <- 73.403758

df9 <- as.data.frame(t(df9))
colnames(df9) <- "Cost_millions"
df9$category <- rep("Fraud", length(df9$Cost_millions))
df9$Cause <- rownames(df9)


rownames(df9) <- NULL

for (i in 1:5){
    if (df9$Cause[i] %in% valid){
      df9$category[i] <- "Valid"
}
}



# 8 - Total cost of SNAP vs. Fraud costs, 2016
ggplot(data=df9, aes(x=category, y=Cost_millions, group=Cause, label=Cost_millions)) +
  geom_col(aes(fill=Cause)) +
  theme_bill() +
  xlab("Total Costs vs. Fraud") +
  ylab("Cost (Millions)") +
  ggtitle("SNAP Program Costs vs. Fraud Expenses - 2016", subtitle = "Sources: US Census Bureau, USDA, fns-prod.azureedge.net") +
  scale_y_continuous(labels=scales::dollar_format()) +
  theme(legend.position = "bottom") +
  coord_flip() +
  theme(legend.title = element_text(size = 10),
        legend.text = element_text(size = 8))



# source: https://fred.stlouisfed.org/series/UNRATE
df10 <- read.csv("https://fred.stlouisfed.org/graph/fredgraph.csv?bgcolor=%23e1e9f0&chart_type=line&drp=0&fo=open%20sans&graph_bgcolor=%23ffffff&height=450&mode=fred&recession_bars=on&txtcolor=%23444444&ts=12&tts=12&width=1168&nt=0&thu=0&trc=0&show_legend=yes&show_axis_titles=yes&show_tooltip=yes&id=UNRATE&scale=left&cosd=1948-01-01&coed=2021-04-01&line_color=%234572a7&link_values=false&line_style=solid&mark_type=none&mw=3&lw=2&ost=-99999&oet=99999&mma=0&fml=a&fq=Annual&fam=avg&fgst=lin&fgsnd=2020-02-01&line_index=1&transformation=lin&vintage_date=2021-05-17&revision_date=2021-05-17&nd=1948-01-01")
df10$DATE <- substring(df10$DATE, 1, 4)
df10 <- df10 %>%
  dplyr::rename(Year=DATE)
df10 <- as.data.frame(inner_join(df8.1, df10, by="Year"))
df10$UNRATE <- as.numeric(as.character(df10$UNRATE)) / 100
df10$Year <- as.numeric(as.character(df10$Year))


colors <- c("Unemployment Rate" = "darkblue", "Low Food Security" = "red", "Very Low Food Security" = "maroon")



# 9 - hunger vs. unemployment
ggplot() +
  geom_line(data=df10, aes(x=Year, y=UNRATE, color="Unemployment Rate"), size=2) +
  geom_line(data=df10, aes(x=Year, y=Food_Insecure, color="Low Food Security"), size=2) +
  geom_line(data=df10, aes(x=Year, y=Very_Insecure, color="Very Low Food Security"), size=2) +
  labs(y="", color = "Legend:", caption="- Low Food Security includes Very Low Food Security.", size = 2.5, colour = "black") +
  scale_color_manual(values = colors) +
  theme_bill() +
  scale_y_continuous(labels=scales::percent_format(), limits=c(0, 0.15)) +
  ggtitle("Hunger vs. Unemployment Rate, 1995-2019", subtitle="Sources: US Census Bureau, USDA, fred.stlouisfed.org")



# source: https://data.worldbank.org/indicator/SP.POP.GROW
df11 <- read_excel("C:/Users/Bill's PC/Desktop/School Work/PPOL 646-3/final/data/API_SP.POP.GROW_DS2_en_excel_v2_2253989.xls", skip=2, col_names = TRUE)
df11 <- as.data.frame(df11)
df11 <- df11 %>%
  dplyr::filter(df11$'Country Code' == "USA")
df11 <- t(df11)
df11 <- na.omit(df11)
colnames(df11) <- 'PopGrowthRate'
df11 <- df11[5:length(df11)]
df11$PopGrowthRat <- as.numeric(df11) / 100
df11$Year <- rep(0, length(df11$PopGrowthRat))

for (i in 1961:2019){
  df11$Year[i-1960] <- i
}

df11 <- as.data.frame(cbind(df11$Year, df11$PopGrowthRat))
colnames(df11) <- c("Year","PopGrowthRate")


colors2 <- c("Population Growth" = "darkgreen", "Low Food Security" = "red")



# 10 - Population growth vs. hunger
ggplot() +
  geom_line(data=df10, aes(x=Year, y=Food_Insecure, color="Low Food Security"), size=2) +
  geom_line(data=df11, aes(x=Year, y=PopGrowthRate, color="Population Growth"), size=1) +
  labs(y="", color = "Legend:") +
  scale_color_manual(values = colors2) +
  theme_bill() +
  scale_x_continuous(limits=c(1994, 2020)) +
  scale_y_continuous(labels=scales::percent_format(), limits=c(0, 0.15)) +
  ggtitle("Population Growth Rate vs. Hunger, 1995-2019", subtitle="Sources: US Census Bureau, USDA, World Bank")

