### This script uses data from sm1st and aaac tables in the sm database
### Results from SM1ST run on Bill was compared to AAAC run on Larry, Joe and Jenna Jr
### Results from patient samples, CDC linearity materials and qualitity control materials are used to span a range of values relevant to newborns screening

library("tidyverse")

instrument_name <- "Joe" ## used to set figures subdirectory in "functions"

source("./functions.r")
source("./queries.r")

## Amino acids
# aa_primary <- c("Ala","Arg","Asa","Cit","Met","Phe","Tyr","SUAC","GUAC") Leu

#Ala
alapop <- get_csv_data("Ala", 600, instrument_name, pop_csv_query)
alalin <- get_csv_data("Ala", 600, instrument_name, linearity_csv_query)
alaqc <- get_csv_viewdata("Ala", instrument_name, qc_csv_query)
alarrf <- find_rrf(alapop, alalin)
make_plots("Ala", alapop, alalin, alarrf, 300, 100 )
combined_data <- rbind(alapop, alalin)
alamoi <- get_csv_viewdata("Ala", instrument_name, moi_csv_query)
make_ts("Ala", alaqc,alamoi, alarrf)

## Arg
argpop <- get_csv_data("Arg", 200, instrument_name, pop_csv_query)
arglin <- get_csv_data("Arg", 200, instrument_name, linearity_csv_query)
argrrf <- find_rrf(argpop, arglin)
make_plots("Arg", argpop, arglin, argrrf, 100, 25 )
argqc <- get_csv_viewdata("Arg", instrument_name, qc_csv_query)
argmoi <- get_csv_viewdata("Arg", instrument_name, moi_csv_query)
make_ts("Arg", argqc,argmoi, argrrf)


## ASA
## asapop <- get_csv_data("ASA", 100, instrument_name, pop_csv_query)
## asalin <- get_csv_data("ASA", 100, instrument_name, linearity_csv_query)
## asarrf <- find_rrf(asapop, asalin)
## make_plots("ASA", asapop, asalin, asarrf, 0, 0 )
## asaqc <- get_csv_viewdata("ASA", instrument_name, qc_csv_query)
## asamoi <- get_csv_viewdata("ASA", instrument_name, moi_csv_query)
## make_ts("ASA", asaqc, asamoi, asarrf)

## Cit
citpop <- get_csv_data("Cit", 100, instrument_name, pop_csv_query)
citlin <- get_csv_data("Cit", 100, instrument_name, linearity_csv_query)
citrrf <- find_rrf(citpop, citlin)
make_plots("Cit", citpop, citlin, citrrf, 50, 25 )
citqc <- get_csv_viewdata("Cit", instrument_name, qc_csv_query)
citmoi <- get_csv_viewdata("Cit", instrument_name, moi_csv_query)
make_ts("Cit", citqc, citmoi, citrrf)

## Leu
params = list('Leu', 400, 400, instrument_name)
leupop <- with_con(make_csv_query("Xleu", pop_csv_query), params)
leulin <- with_con(make_csv_query("Xleu", linearity_csv_query) , params)
leurrf <- find_rrf(leupop, leulin)
make_plots("Leu", leupop, leulin, leurrf, 200, 50)
view_params <- list('Leu', instrument_name)
leuqc <- with_con(make_csv_query("Leu", qc_csv_query) , view_params)
leumoi <- with_con(make_csv_query("Leu", moi_csv_query) , view_params)
make_ts("Leu", leuqc, leumoi, leurrf)


## Met
metpop <- get_csv_data("Met", 100, instrument_name, pop_csv_query)
metlin <- get_csv_data("Met", 100, instrument_name, linearity_csv_query)
metrrf <- find_rrf(metpop, metlin)
make_plots("Met", metpop, metlin, metrrf, 50, 25 )
metqc <- get_csv_viewdata("Met", instrument_name, qc_csv_query)
metmoi <- get_csv_viewdata("Met", instrument_name, moi_csv_query)
make_ts("Met", metqc, metmoi, metrrf)


## Phe
phepop <- get_csv_data("Phe", 200, instrument_name, pop_csv_query)
phelin <- get_csv_data("Phe", 200, instrument_name, linearity_csv_query)
pherrf <- find_rrf(phepop, phelin)
make_plots("Phe", phepop, phelin, pherrf, 50, 25 )
pheqc <- get_csv_viewdata("Phe", instrument_name, qc_csv_query)
phemoi <- get_csv_viewdata("Phe", instrument_name, moi_csv_query)
make_ts("Phe", pheqc, phemoi, pherrf)


## Tyr
tyrpop <- get_csv_data("Tyr", 200, instrument_name, pop_csv_query)
tyrlin <- get_csv_data("Tyr", 200, instrument_name, linearity_csv_query)
tyrrrf <- find_rrf(tyrpop, tyrlin)
make_plots("Tyr", tyrpop, tyrlin, tyrrrf, 50, 25 )
tyrqc <- get_csv_viewdata("Tyr", instrument_name, qc_csv_query)
tyrmoi <- get_csv_viewdata("Tyr", instrument_name, moi_csv_query)
make_ts("Tyr", tyrqc, tyrmoi, tyrrrf)

## SUAC 
suacpop <- get_csv_data("SUAC", 10, instrument_name, pop_csv_query)
suaclin <- get_csv_data("SUAC", 10, instrument_name, linearity_csv_query)
suacrrf <- find_rrf(suacpop, suaclin)
make_plots("SUAC", suacpop, suaclin, suacrrf, 4, 25 )
suacqc <- get_csv_viewdata("SUAC", instrument_name, qc_csv_query)
suacmoi <- get_csv_viewdata("SUAC", instrument_name, moi_csv_query)
make_ts("SUAC", suacqc, suacmoi, suacrrf)

## GUAC 
guacpop <- get_csv_data("GUAC", 10, instrument_name, pop_csv_query)
guaclin <- get_csv_data("GUAC", 10, instrument_name, linearity_csv_query)
guacrrf <- find_rrf(guacpop, guaclin)
make_plots("GUAC", guacpop, guaclin, guacrrf, 4, 2 )
guacqc <- get_csv_viewdata("GUAC", instrument_name, qc_csv_query)
guacmoi <- get_csv_viewdata("GUAC", instrument_name, moi_csv_query)
make_ts("GUAC", guacqc, guacmoi, guacrrf)

### AA secondary

## Gly
glypop <- get_csv_data("Gly", 1000, instrument_name, pop_csv_query)
glylin <- get_csv_data("Gly", 1000, instrument_name, linearity_csv_query)
glyrrf <- find_rrf(glypop, glylin)
make_plots("Gly", glypop, glylin, glyrrf, 50, 25 )
glyqc <- get_csv_viewdata("Gly", instrument_name, qc_csv_query)
glymoi <- get_csv_viewdata("Gly", instrument_name, moi_csv_query)
make_ts("Gly", glyqc, glymoi, glyrrf)

## Orn
ornpop <- get_csv_data("Orn", 300, instrument_name, pop_csv_query)
ornlin <- get_csv_data("Orn", 300, instrument_name, linearity_csv_query)
ornrrf <- find_rrf(ornpop, ornlin)
make_plots("Orn", ornpop, ornlin, ornrrf, 50, 25 )
ornqc <- get_csv_viewdata("Orn", instrument_name, qc_csv_query)
ornmoi <- get_csv_viewdata("Orn", instrument_name, moi_csv_query)
make_ts("Orn", ornqc, ornmoi, ornrrf)

## Val
valpop <- get_csv_data("Val", 400, instrument_name, pop_csv_query)
vallin <- get_csv_data("Val", 400, instrument_name, linearity_csv_query)
valrrf <- find_rrf(valpop, vallin)
make_plots("Val", valpop, vallin, valrrf, 50, 25 )
valqc <- get_csv_viewdata("Val", instrument_name, qc_csv_query)
valmoi <- get_csv_viewdata("Val", instrument_name, moi_csv_query)
make_ts("Val", valqc, valmoi, valrrf)

## AC
#ac_primary <- c("C0","C2","C3","C5","C6","C8","C10","C14:1","C16OH") C5DC

## C0
c0pop <- get_csv_data("C0", 150, instrument_name, pop_csv_query)
c0lin <- get_csv_data("C0", 150, instrument_name, linearity_csv_query)
c0rrf <- find_rrf(c0pop, c0lin)
make_plots("C0", c0pop, c0lin, c0rrf, 75, 20 )
c0qc <- get_csv_viewdata("C0", instrument_name, qc_csv_query)
c0moi <- get_csv_viewdata("C0", instrument_name, moi_csv_query)
make_ts("C0", c0qc, c0moi, c0rrf)

## C2
c2pop <- get_csv_data("C2", 150, instrument_name, pop_csv_query)
c2lin <- get_csv_data("C2", 150, instrument_name, linearity_csv_query)
c2rrf <- find_rrf(c2pop, c2lin)
make_plots("C2", c2pop, c2lin, c2rrf, 75, 20 )
c2qc <- get_csv_viewdata("C2", instrument_name, qc_csv_query)
c2moi <- get_csv_viewdata("C2", instrument_name, moi_csv_query)
make_ts("C2", c2qc, c2moi, c2rrf)


## C3
c3pop <- get_csv_data("C3", 15, instrument_name, pop_csv_query)
c3lin <- get_csv_data("C3", 15, instrument_name, linearity_csv_query)
c3rrf <- find_rrf(c3pop, c3lin)
make_plots("C3", c3pop, c3lin, c3rrf, 2, 2 )
c3qc <- get_csv_viewdata("C3", instrument_name, qc_csv_query)
c3moi <- get_csv_viewdata("C3", instrument_name, moi_csv_query)
make_ts("C3", c3qc, c3moi, c3rrf)

## C5
c5pop <- get_csv_data("C5", 1, instrument_name, pop_csv_query)
c5lin <- get_csv_data("C5", 1, instrument_name, linearity_csv_query)
c5rrf <- find_rrf(c5pop, c5lin)
make_plots("C5", c5pop, c5lin, c5rrf, 0.5 , 0.1)
c5qc <- get_csv_viewdata("C5", instrument_name, qc_csv_query)
c5moi <- get_csv_viewdata("C5", instrument_name, moi_csv_query)
make_ts("C5", c5qc, c5moi, c5rrf)

## C5DC
params = list('C5DC', 0.5, 0.5, instrument_name)
c5dcpop <- with_con(make_csv_query("C5DC_C6OH", pop_csv_query), params)
c5dclin <- with_con(make_csv_query("C5DC_C6OH", linearity_csv_query) , params)
c5dcrrf <- find_rrf(c5dcpop, c5dclin)
make_plots("C5DC", c5dcpop, c5dclin, c5dcrrf, 0.3, 0.1)
view_params <- list('C5DC', instrument_name)
c5dcqc <- with_con(make_csv_query("C5DC",qc_csv_query) , view_params)
c5dcmoi <- with_con(make_csv_query("C5DC",moi_csv_query) , view_params)
make_ts("C5DC", c5dcqc, c5dcmoi, c5dcrrf)


## C6
c6pop <- get_csv_data("C6", 0.5, instrument_name, pop_csv_query)
c6lin <- get_csv_data("C6", 0.5, instrument_name, linearity_csv_query)
c6rrf <- find_rrf(c6pop, c6lin)
make_plots("C6", c6pop, c6lin, c6rrf, 0.2, 0.7 )
c6qc <- get_csv_viewdata("C6", instrument_name, qc_csv_query)
c6moi <- get_csv_viewdata("C6", instrument_name, moi_csv_query)
make_ts("C6", c6qc, c6moi, c6rrf)

## C8
c8pop <- get_csv_data("C8", 1, instrument_name, pop_csv_query)
c8lin <- get_csv_data("C8", 1, instrument_name, linearity_csv_query)
c8rrf <- find_rrf(c8pop, c8lin)
make_plots("C8", c8pop, c8lin, c8rrf, 0.5, 0.2)
c8qc <- get_csv_viewdata("C8", instrument_name, qc_csv_query)
c8moi <- get_csv_viewdata("C8", instrument_name, moi_csv_query)
make_ts("C8", c8qc, c8moi, c8rrf)


## C10
c10pop <- get_csv_data("C10", 1, instrument_name, pop_csv_query)
c10lin <- get_csv_data("C10", 1, instrument_name, linearity_csv_query)
c10rrf <- find_rrf(c10pop, c10lin)
make_plots("C10", c10pop, c10lin, c10rrf, 0.4, 0.4 )
c10qc <- get_csv_viewdata("C10", instrument_name, qc_csv_query)
c10moi <- get_csv_viewdata("C10", instrument_name, moi_csv_query)
make_ts("C10", c10qc, c10moi, c10rrf)

## C14:1
params = list('C14:1', 1, 1, instrument_name)
c141pop <- with_con(make_csv_query("C141", pop_csv_query), params)
c141lin <-  with_con(make_csv_query("C141", linearity_csv_query) , params)
c141rrf <- find_rrf(c141pop, c141lin)
make_plots("C141", c141pop, c141lin, c141rrf, 0.5, 0.2 )
view_params <- list('C14:1', instrument_name)
c141qc <- with_con(make_csv_query("C141",qc_csv_query) , view_params)
c141moi <- with_con(make_csv_query("C141",moi_csv_query) , view_params)
make_ts("C141", c141qc, c141moi, c141rrf)

## C16
c16pop <- get_csv_data("C16", 10, instrument_name, pop_csv_query)
c16lin <- get_csv_data("C16", 10, instrument_name, linearity_csv_query)
c16rrf <- find_rrf(c16pop, c16lin)
make_plots("C16", c16pop, c16lin, c16rrf, 0.6, 0.2 )
c16qc <- get_csv_viewdata("C16", instrument_name, qc_csv_query)
c16moi <- get_csv_viewdata("C16", instrument_name, moi_csv_query)
make_ts("C16", c16qc, c16moi, c16rrf)


## C16OH
c16ohpop <- get_csv_data("C16OH", 0.4, instrument_name, pop_csv_query)
c16ohlin <- get_csv_data("C16OH", 0.4, instrument_name, linearity_csv_query)
c16ohrrf <- find_rrf(c16ohpop, c16ohlin)
make_plots("C16OH", c16ohpop, c16ohlin, c16ohrrf, 0.2, 0.6 )
c16ohqc <- get_csv_viewdata("C16OH", instrument_name, qc_csv_query)
c16ohmoi <- get_csv_viewdata("C16OH", instrument_name, moi_csv_query)
make_ts("C16OH", c16ohqc, c16ohmoi, c16ohrrf)

## C18
c18pop <- get_csv_data("C18", 5, instrument_name, pop_csv_query)
c18lin <- get_csv_data("C18", 5, instrument_name, linearity_csv_query)
c18rrf <- find_rrf(c18pop, c18lin)
make_plots("C18", c18pop, c18lin, c18rrf, 3, 1 )
c18qc <- get_csv_viewdata("C18", instrument_name, qc_csv_query)
c18moi <- get_csv_viewdata("C18", instrument_name, moi_csv_query)
make_ts("C18", c18qc, c18moi, c18rrf)

## ## QC and linearity based RRF adjustment

## suac
suaclowqc <- subset(suacqc, sample != "APPOS1")
suacqcrrf <- find_rrf(suaclowqc, suaclin)
make_plots("SUAC_QC", suacpop, suaclin, suacqcrrf, 4, 25)
make_ts("SUAC_QC", suacqc, suacmoi, suacqcrrf)


## GUAC
guaclowqc <- subset(guacqc, sample != "APPOS1")
guacqcrrf <- find_rrf(guacqc, guaclin)
make_plots("GUAC_QC", guacpop, guaclin, guacqcrrf, 4, 2 )
make_ts("GUAC_QC", guacqc, guacmoi, guacqcrrf)


## C5
c5lowqc <- subset(c5qc, sample != "APPOS2")
c5qcrrf <- find_rrf(c5lowqc, c5lin)
make_plots("C5_QC", c5pop, c5lin, c5qcrrf, 0.2, 0.7 )
make_ts("C5_QC", c5qc, c5moi,c5qcrrf)

## C5DC
c5dclowqc <- subset(c5dcqc, sample != "APPOS2")
c5dcqcrrf <- find_rrf(c5dclowqc, c5dclin)
make_plots("C5DC_QC", c5dcpop, c5dclin, c5dcqcrrf, 0.3, 0.1)
qcparams <- list('C5DC_C6OH', 'C5DC')
make_ts("C5DC_QC", c5dcqc, c5dcmoi, c5dcqcrrf)

## C6
c6qcrrf <- find_rrf(c6qc, c6lin)
make_plots("C6_QC", c6pop, c6lin, c6qcrrf, 0.2, 0.7 )
make_ts("C6_QC", c6qc, c6moi, c6qcrrf)

## C8
c8lowqc <- subset(c8qc, sample != "APPOS1")
c8qcrrf <- find_rrf(c8lowqc, c8lin)
make_plots("C8_QC", c8pop, c8lin, c8qcrrf, 0.5, 0.2)
make_ts("C8_QC", c8qc, c8moi, c8qcrrf)

## C14:1
c141qcrrf <- find_rrf(c141qc, c141lin)
make_plots("C141_QC", c141pop, c141lin, c141qcrrf, 0.5, 0.2 )
make_ts("C141_QC", c141qc, c141moi, c141qcrrf)

## C16OH
c16ohqcrrf <- find_rrf(c16ohqc, c16ohlin)
make_plots("C16OH_QC", c16ohpop, c16ohlin, c16ohqcrrf, 0.2, 0.6 )
make_ts("C16OH_QC", c16ohqc, c16ohmoi, c16ohqcrrf)

primary_analytes <- c("Ala" = alarrf, "Arg" = argrrf, "Cit" = citrrf, "Leu" = leurrf, "Met" = metrrf, "Phe" = pherrf,
                      "Tyr" = tyrrrf, "SUAC" = 1, "GUAC" = guacqcrrf, "C0" = c0rrf,  "C2"= c2rrf, "C3"= c3rrf,
                      "C5"= c5rrf, "C5DC"= c5dcrrf, "C6"= c6qcrrf , "C8"= c8rrf, "C10"= c10rrf ,"C141"= c141qcrrf,
                      "C16" = c16rrf, "C16OH" = c16ohqcrrf, "C18" = c18rrf)


secondary_analytes <- c("Gly" = glyrrf, "Orn" = ornrrf, "Val" = valrrf)


rrfs_list <- c(primary_analytes, secondary_analytes)
rrf_file_name <- paste0("../data/", instrument_name, "_RRF.csv")
write.csv(rrfs_list, file = rrf_file_name)

## Amino acids
make_mcr("Ala", alapop, alalin, alaqc)
make_mcr("Arg", argpop, arglin, argqc)
make_mcr("Cit", citpop, citlin, citqc)
make_mcr("Leu", leupop, leulin, leuqc)
make_mcr("Met", metpop, metlin, metqc)
make_mcr("Phe", phepop, phelin, pheqc)
make_mcr("Tyr", tyrpop, tyrlin, tyrqc)
make_mcr("SUAC", suacpop, suaclin, suacqc)
make_mcr("GUAC", guacpop, guaclin, guacqc)


## Acylcarnitines
make_mcr("C0", c0pop, c0lin, c0qc)
make_mcr("C2", c2pop, c2lin, c2qc)
make_mcr("C3", c3pop, c3lin, c3qc)
make_mcr("C5", c5pop, c5lin, c5qc)
make_mcr("C5DC", c5dcpop, c5dclin, c5dcqc)
make_mcr("C6", c6pop, c6lin, c6qc)
make_mcr("C8", c8pop, c8lin, c8qc)
make_mcr("C10", c10pop, c10lin, c10qc)
make_mcr("C141", c141pop, c141lin, c141qc)
make_mcr("C16", c16pop, c16lin, c16qc)
make_mcr("C16OH", c16ohpop, c16ohlin, c16ohqc)
make_mcr("C18", c18pop, c18lin, c18qc)




## Reference intervals
sm1st.ri <-  pm.blood %>%
    select(-classification) %>%
    pivot_longer(!group, names_to = "analyte", values_to = "value") %>%
    drop_na(value) %>%
    group_by(analyte, group) %>%
    summarise(n = n(),
	      p025 = quantile(value,probs = c(0.025), type = 8, na.rm = TRUE),
	      m = median(value, na.rm = TRUE),
	      p975 = quantile(value,probs = c(0.975), type = 8, na.rm = TRUE)) %>%
  as.data.frame()

  write.csv(blood.ri, file="./data/pm_blood_aa_ac_ri.csv", row.names = FALSE)
