library("tidyverse")

instrument_name <- "Bill" ## used to set figures subdirectory in "functions"
source("./functions.r")

## Bill queries
source("./queries.r")


int_query <- "select * from sm1st 
where analyte in ('Arg INT', 'Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int', 'CIT INT', 'Cit IS INT')
and date(createdate) > '2025-06-01'"

int_data <- with_con(int_query, params = c())

## write.csv(int_data, "../data/int_data.csv")
## int_data <- read.csv(file = "../data/int_data.csv") %>%
##     filter(date(createdate) >  '2025-06-01')


## IS variability
int_data %>%
##       filter(analyte %in% c('Arg INT', 'Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(sampletype == 'OBS') %>%
    group_by(instrument, plate, analyte) %>%
    summarize(median = median(result, na.rm = TRUE),
              sd = sd(result, na.rm = TRUE)) %>%
    gather(key = center, value = value , median:sd) %>%
    ggplot(aes(x = plate)) +
    geom_point(aes(y = value, colour = analyte, shape = center),alpha =  0.5 , size = 3) +
    geom_hline(yintercept = 1000, colour = "red", linetype = "dashed") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    ylab("uM") +
    xlab("Plate")


int_data %>%
##       filter(analyte %in% c('Arg INT', 'Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(sampletype == 'LQC') %>%
    group_by(instrument, plate, analyte) %>%
    summarize(median = median(result, na.rm = TRUE),
              sd = sd(result, na.rm = TRUE)) %>%
    gather(key = center , value = value , median:sd) %>%
    ggplot(aes(x = plate)) +
    geom_point(aes(y = value, colour = analyte, shape = center),alpha =  0.5 , size = 3) +
    geom_hline(yintercept = 1000, colour = "red", linetype = "dashed") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    ylab("uM") +
    xlab("Plate")


## Arg and CIT IS
int_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('Arg INT', 'Arg IS INT', 'CIT INT', 'Cit IS INT')) %>%
    group_by(instrument, plate, analyte) %>%
    summarize(median = median(result, na.rm = TRUE),
              sd = sd(result, na.rm = TRUE)) %>%
    gather(key = center , value = value , median:sd) %>%
    ggplot(aes(x = plate)) +
    geom_point(aes(y = value, colour = analyte, shape = center), alpha = 0.5, size = 3) +
    geom_hline(yintercept = 0.32, colour = "red", linetype = "dashed") +
    geom_hline(yintercept = 0.77, colour = "red", linetype = "dashed") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    ylab("uM") +
    xlab("Plate")


d <- 16.13 ## dilution factor 

int_data %>%
    filter(sampletype == 'OBS') %>%
    select(plate,sample, analyte, result) %>%
    filter(analyte %in% c('Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int', 'CIT INT', 'Cit IS INT')) %>%
    pivot_wider(id_cols = c(sample, plate),names_from = analyte, values_from = result) %>%
    rename(arg_is = `Arg IS INT`, asa_is = `Asa IS Int`, asa = `ASA INT`,
           asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`, cit_is = `Cit IS INT`) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d,
              asa_arg_r= asa/arg_is * d * 160,
              asa_t_arg_r= (asa + asa_h2o)/arg_is * d * 80,
              asa_cit_r= asa/cit_is * d * 10,
              asa_t_cit_r= (asa + asa_h2o)/cit_is * d * 10) %>%
    select(plate, sample, asa_t_cit_r, asa_cit_r, asa_t_arg_r, asa_arg_r, asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -c(plate,sample), names_to = "analyte", values_to = "result") %>%
    group_by(plate, analyte) %>%
    summarize(median = median(result, na.rm = TRUE),
              sd = sd(result, na.rm = TRUE)) %>%
    gather(key = center , value = value , median:sd) %>%        
    ggplot(aes(x = plate)) +
    geom_point(aes(y = value, colour = analyte, shape = center), alpha = 0.5, size = 3) +
    geom_hline(yintercept = 10, colour = "red", linetype = "dashed") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
    coord_cartesian(ylim = c(0, 50)) +
    ylab("uM") +
    xlab("Plate")


## QC
## New linearity materials with ASA-D introduced August 22
int_data %>%
    filter(date(createdate) >  '2025-08-22') %>%
    filter(sampletype == 'LQC') %>%
    select(plate, well, sample, analyte, result) %>%
    filter(analyte %in% c('Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    filter(str_detect(sample, "SM1-")) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(arg_is = `Arg IS INT`, asa_is = `Asa IS Int`, asa = `ASA INT`, asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d,
              asa_arg_r= asa/arg_is * d * 160,
              asa_t_arg_r= (asa + asa_h2o)/arg_is * d * 80 ) %>%
    select(plate, well, sample, asa_t_arg_r, asa_arg_r, asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -c(plate, well,sample), names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = sample, y = result,  colour = analyte))  



int_data %>%
    filter(date(createdate) >  '2025-08-22') %>%
    filter(sampletype == 'LQC') %>%
    select(plate, well, sample, analyte, result) %>%
    filter(analyte %in% c('Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int', 'CIT INT', 'Cit IS INT')) %>%
    filter(str_detect(sample, "SM1-")) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(arg_is = `Arg IS INT`, asa_is = `Asa IS Int`, asa = `ASA INT`,
           asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`, cit_is = `Cit IS INT`) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d,
              asa_arg_r= asa/arg_is * d * 160,
              asa_t_arg_r= (asa + asa_h2o)/arg_is * d * 80,
              asa_cit_r= asa/cit_is * d * 10,
              asa_t_cit_r= (asa + asa_h2o)/cit_is * d * 10) %>%
    #select(plate, well, sample, asa_t_cit_r, asa_cit_r, asa_t_arg_r, asa_arg_r, asa_r, asa_h2o_r, asa_t_r) %>%
    select(plate, well, sample, asa_t_cit_r, asa_t_arg_r, asa_t_r) %>%
    pivot_longer(cols = -c(plate, well,sample), names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = sample, y = result,  colour = analyte)) +
    coord_cartesian(ylim = c(0,50))





int_data %>%
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








