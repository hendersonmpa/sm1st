library("tidyverse")

instrument_name <- "Bill" ## used to set figures subdirectory in "functions"
source("./functions.r")

## Bill queries
source("./queries.r")


## asa_query <- "select * from sm1st 
## where analyte in ('Arg INT', 'Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')"

## #and date(createdate) > '2025-08-22'"

## asa_data <- with_con(asa_query, params = c())

## write.csv(asa_data, "../data/asa_data.csv")
asa_data <- read.csv(file = "../data/asa_data.csv") %>%
    filter(date(createdate) >  '2025-06-01')


## IS variability
asa_data %>%
##       filter(analyte %in% c('Arg INT', 'Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    group_by(instrument, plate, analyte) %>%
    summarize(median = median(result, na.rm = TRUE),
              sd = sd(result, na.rm = TRUE)) %>%
    gather(key = center , value = value , median:sd) %>%
    ggplot(aes(x = plate)) +
    geom_point(aes(y = value, colour = analyte, shape = center)) +
    geom_hline(yintercept = 0.32, colour = "red", linetype = "dashed") +
    geom_hline(yintercept = 0.77, colour = "red", linetype = "dashed") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    ylab("uM") +
    xlab("Plate")

## Arg IS
asa_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('Arg INT', 'Arg IS INT')) %>%
    group_by(instrument, plate, analyte) %>%
    summarize(median = median(result, na.rm = TRUE),
              sd = sd(result, na.rm = TRUE)) %>%
    gather(key = center , value = value , median:sd) %>%
    ggplot(aes(x = plate)) +
    geom_point(aes(y = value, colour = analyte, shape = center)) +
    geom_hline(yintercept = 0.32, colour = "red", linetype = "dashed") +
    geom_hline(yintercept = 0.77, colour = "red", linetype = "dashed") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    ylab("uM") +
    xlab("Plate")


d <- 16.13 ## dilution factor 

asa_data %>%
    filter(sampletype == 'OBS') %>%
    select(plate,sample, analyte, result) %>%
    filter(analyte %in% c('Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    pivot_wider(id_cols = c(sample, plate),names_from = analyte, values_from = result) %>%
    rename(arg_is = `Arg IS INT`, asa_is = `Asa IS Int`, asa = `ASA INT`,
           asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d,
              asa_arg_r= asa/arg_is * d * 100,
              asa_t_arg_r= (asa + asa_h2o)/arg_is * d * 50 ) %>%
    select(plate, sample, asa_t_arg_r, asa_arg_r, asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -c(plate,sample), names_to = "analyte", values_to = "result") %>%
    group_by(plate, analyte) %>%
    summarize(median = median(result, na.rm = TRUE),
              sd = sd(result, na.rm = TRUE)) %>%
    gather(key = center , value = value , median:sd) %>%        
    ggplot(aes(x = plate)) +
    geom_point(aes(y = value, colour = analyte, shape = center)) +
    geom_hline(yintercept = 10, colour = "red", linetype = "dashed") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    coord_cartesian(ylim = c(0, 50)) +
    ylab("uM") +
    xlab("Plate")


## QC

asa_data %>%
    filter(sampletype == 'LQC') %>%
    select(plate, well, sample, analyte, result) %>%
    filter(analyte %in% c('Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(str_detect(sample, "SM1-")) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(arg_is = `Arg IS INT`, asa_is = `Asa IS Int`, asa = `ASA INT`, asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    transform(asa_r = asa/asa_is ,
              asa_h2o_r = asa_h2o/asa_h2o_is,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is),
              asa_arg = asa/arg_is,
              asa_t_arg = (asa + asa_h2o)/arg_is) %>%
    select(plate, well, sample, asa_t_arg, asa_arg, asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -c(plate, well,sample), names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = sample, y = result,  colour = analyte)) +
    facet_grid(rows = vars(analyte), scales = "free")



asa_data %>%
    filter(sampletype == 'LQC') %>%
    select(plate, well, sample, analyte, result) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(str_detect(sample, "SM1-")) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(asa_is = `Asa IS Int`, asa = `ASA INT`, asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d ) %>%
    select(sample, asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -sample, names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = sample, y = result,  colour = analyte)) 
    facet_grid(rows = vars(analyte), scales = "free")








