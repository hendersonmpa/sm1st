library("tidyverse")

instrument_name <- "Bill" ## used to set figures subdirectory in "functions"
source("./functions.r")

## Bill queries
source("./queries.r")


asa_query <- "select * from sm1st 
where analyte in ('Arg INT', 'Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')"

#and date(createdate) > '2025-08-22'"

asa_data <- with_con(asa_query, params = c())

write.csv(asa_data, "../data/asa_data.csv")

asa_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('Arg INT', 'Arg IS INT', 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    ggplot(aes(x = result, colour = analyte)) +
    facet_wrap(facets = vars(analyte), scales = "free") +
    geom_density()

# , 'ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%

asa_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int','Asa[-H2O] IS Int')) %>%
    ggplot(aes(x = result, colour = analyte)) +
    geom_boxplot() 

asa_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    ggplot(aes(x = analyte, y = result, colour = analyte)) +
    geom_boxplot() 



asa_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('ASA INT', 'Asa IS nnInt', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    ggplot(aes(x = analyte, y = result, colour = analyte)) +
    geom_boxplot()


asa_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int')) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    ggplot(aes(x = `Asa IS Int`, y = `ASA INT`, colour = week(createdate))) +
    geom_point()



asa_data %>%
    filter(sampletype == 'OBS') %>%
    filter(analyte %in% c('Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    ggplot(aes(x = `Asa[-H2O] IS Int`, y = `Asa[-H2O] Int`, colour = week(createdate))) +
    geom_point()

asa_data %>%
    filter(sampletype == 'OBS') %>%
    select(sample, analyte, result) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(asa_is = `Asa IS Int`, asa = `ASA INT`, asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    pivot_longer(cols = -sample, names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = analyte, y = result,  colour = analyte)) 



d <- 16.13 ## dilution factor 

asa_data %>%
    filter(sampletype == 'OBS') %>%
    select(sample, analyte, result) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(asa_is = `Asa IS Int`, asa = `ASA INT`, asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d ) %>%
    select(sample, asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -sample, names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = analyte, y = result,  colour = analyte)) 


asa_data %>%
    filter(sampletype == 'OBS') %>%
    select(sample, analyte, result) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(asa_is = `Asa IS Int`, asa = `ASA INT`, asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    filter(asa_is >= 250 && asa_h2o_is >= 400) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d ) %>%
    select(sample,  asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -sample, names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = analyte, y = result,  colour = analyte)) +
    coord_cartesian(ylim = c(0, 50))

asa_data %>%
    filter(sampletype == 'OBS') %>%
    select(plate, sample, analyte, result) %>%
    filter(analyte %in% c('ASA INT', 'Asa IS Int', 'Asa[-H2O] Int', 'Asa[-H2O] IS Int')) %>%
    pivot_wider(names_from = analyte, values_from = result) %>%
    rename(asa_is = `Asa IS Int`, asa = `ASA INT`, asa_h2o_is = `Asa[-H2O] IS Int`, asa_h2o = `Asa[-H2O] Int`) %>%
    filter(asa_is >= 250 && asa_h2o_is >= 400) %>%
    transform(asa_r = asa/asa_is * d ,
              asa_h2o_r = asa_h2o/asa_h2o_is * d,
              asa_t_r = (asa + asa_h2o)/(asa_is +asa_h2o_is) * d ) %>%
    group_by(plate) %>%
    summarize(mean = mean(asa_t_r),
              sd = sd(asa_t_r))


    
    select(sample,  asa_r, asa_h2o_r, asa_t_r) %>%
    pivot_longer(cols = -sample, names_to = "analyte", values_to = "result") %>%
    ggplot() +
    geom_boxplot(aes(x = analyte, y = result,  colour = analyte)) +
    coord_cartesian(ylim = c(0, 50))
                                        # QC




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








