library("tidyverse")
library("DBI")
library("RMariaDB")
library("svglite")

all_analytes <- c("Ala","Arg","Cit","XLeu","Met","Phe","Tyr","Val", "Cre","Crn","ASA","GUAC","Suac","dAdo","C0","C2","C3", "C3DC_C4OH", "C4","C4DC_C5OH","C5","C5DC_C6OH","C5:1", "C6","C6DC", "C8","C8:1","C10","C10:1","C10:2","C12","C12:1","C14","C14:1","C16","C16:1","C16:1OH_C17", "C16OH","C18","C20:0LPC","C22:0LPC","C24:0LPC","C26","C26:0LPC")

aa_primary <- c("Ala","Arg","ASA","Cit","XLeu","Met","Phe","Tyr","Suac", "GUAC", "dAdo")
ac_primary <- c("C0","C2","C3","C5","C5DC_C6OH","C6","C8","C10","C14:1","C16OH","C26:0LPC" )

with_con <- function(query){
    con <- dbConnect(
        drv = RMariaDB::MariaDB(),
        dbname = "sm",
        username = "mpah",
        password = "smjh13oo", 
        host = "localhost", 
        port = 3306,
        mysql = TRUE )
    
    request  <- dbSendQuery(con, query)
    data <- dbFetch(request)
    dbDisconnect(con)
    colnames(data) <- tolower(colnames(data))
    data
}


query <- "select instrument, analyte, sample, COUNT(result) as count, ROUND(AVG(result),2) as mean, ROUND(STDDEV(result),2) as sd from sm1st 
where sampletype in ('LQC' , 'BLK') and
analyte in ('Ala','Arg','Cit','XLeu','Met','Phe','Tyr','Val', 'Cre','Crn','ASA','GUAC','Suac','dAdo','C0','C2','C3', 'C3DC_C4OH', 'C4','C4DC_C5OH','C5','C5DC_C6OH','C5:1', 'C6','C6DC', 'C8','C8:1','C10','C10:1','C10:2','C12','C12:1','C14','C14:1','C16','C16:1','C16:1OH_C17', 'C16OH','C18','C20:0LPC','C22:0LPC','C24:0LPC','C26','C26:0LPC')
group by instrument, analyte, sample"

data <- with_con(query)

data$cv <- with(data, (sd/mean) * 100)
data$lower <- with(data, mean - sd)
data$upper <- with(data, mean + sd)

#     filter(analyte == "Suac" & sample %in% c("SM1-APNEG", "SM1-APPOS1", "SM1-APPOS2")) %>%
data %>%
    filter(mean <= 10, analyte %in% aa_primary & sample %in% c("SM1-APNEG", "SM1-APPOS1", "SM1-APPOS2")) %>%
    ggplot(aes(x = sample, y = mean, colour = analyte)) +
    geom_pointrange(aes(ymin = lower, ymax = upper), position = position_dodge(width = 1)) 

ggsave(filename = "./figures/low_aa_precision.svg", height = 2500, width = 5000, units = "px")

data %>%
    filter(mean > 10, analyte %in% aa_primary & sample %in% c("SM1-APNEG", "SM1-APPOS1", "SM1-APPOS2")) %>%
    ggplot(aes(x = sample, y = mean, colour = analyte)) +
    geom_pointrange(aes(ymin = lower, ymax = upper), position = position_dodge(width = 1)) 

ggsave(filename = "./figures/high_aa_precision.svg", height = 2500, width = 5000, units = "px")


data %>%
    filter(mean <= 1, analyte %in% ac_primary & sample %in% c("SM1-APNEG", "SM1-APPOS1", "SM1-APPOS2")) %>%
    ggplot(aes(x = sample, y = mean, colour = analyte)) +
    geom_pointrange(aes(ymin = lower, ymax = upper), position = position_dodge(width = 1)) 

ggsave(filename = "./figures/low_ac_precision.svg", height = 2500, width = 5000, units = "px")

data %>%
    filter(mean > 1, analyte %in% ac_primary & sample %in% c("SM1-APNEG", "SM1-APPOS1", "SM1-APPOS2")) %>%
    ggplot(aes(x = sample, y = mean, colour = analyte)) +
    geom_pointrange(aes(ymin = lower, ymax = upper), position = position_dodge(width = 1)) 

ggsave(filename = "./figures/high_ac_precision.svg", height = 2500, width = 5000, units = "px")

data %>%
    filter(analyte %in% aa_primary & sample %in% c("SM1-APNEG", "SM1-APPOS1", "SM1-APPOS2")) %>%
    ggplot(aes(x = mean, y = cv, colour = analyte)) +
    geom_point( position = position_dodge(width = 1)) 

ggsave(filename = "./figures/aa_cv.svg", height = 2500, width = 5000, units = "px")

data %>%
    filter(analyte %in% ac_primary & sample %in% c("SM1-APNEG", "SM1-APPOS1", "SM1-APPOS2")) %>%
    ggplot(aes(x = mean, y = cv, colour = analyte)) +
    geom_point( position = position_dodge(width = 1)) 

ggsave(filename = "./figures/ac_cv.svg", height = 2500, width = 5000, units = "px")
