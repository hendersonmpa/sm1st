### This script uses data from sm1st and aaac tables in the sm database
### Results from SM1ST run on Bill was compared to AAAC run on Larry, Joe and Jenna Jr
### Results from patient samples, CDC linearity materials and qualitity control materials are used to span a range of values relevant to newborns screening

library("tidyverse")

instrument_name <- "Joe" ## used to set figures subdirectory in "functions"

source("./functions.r")
source("./queries.r")

## ## Amino acids
## # aa_primary <- c("Ala","Arg","Asa","Cit","Met","Phe","Tyr","SUAC","GUAC") Leu

## #Ala
## alapop <- get_csv_data("Ala", 600, instrument_name, pop_csv_query)
## alalin <- get_csv_data("Ala", 600, instrument_name, linearity_csv_query)
## alaqc <- get_csv_viewdata("Ala", instrument_name, qc_csv_query)
## alarrf <- find_rrf(alapop, alalin)
## make_plots("Ala", alapop, alalin, alarrf, 300, 100 )
## combined_data <- rbind(alapop, alalin)
## alamoi <- get_csv_viewdata("Ala", instrument_name, moi_csv_query)
## make_ts("Ala", alaqc,alamoi, alarrf)

## ## Arg
## argpop <- get_csv_data("Arg", 200, instrument_name, pop_csv_query)
## arglin <- get_csv_data("Arg", 200, instrument_name, linearity_csv_query)
## argrrf <- find_rrf(argpop, arglin)
## make_plots("Arg", argpop, arglin, argrrf, 100, 25 )
## argqc <- get_csv_viewdata("Arg", instrument_name, qc_csv_query)
## argmoi <- get_csv_viewdata("Arg", instrument_name, moi_csv_query)
## make_ts("Arg", argqc,argmoi, argrrf)


## ## ASA
## ## asapop <- get_csv_data("ASA", 100, instrument_name, pop_csv_query)
## ## asalin <- get_csv_data("ASA", 100, instrument_name, linearity_csv_query)
## ## asarrf <- find_rrf(asapop, asalin)
## ## make_plots("ASA", asapop, asalin, asarrf, 0, 0 )
## ## asaqc <- get_csv_viewdata("ASA", instrument_name, qc_csv_query)
## ## asamoi <- get_csv_viewdata("ASA", instrument_name, moi_csv_query)
## ## make_ts("ASA", asaqc, asamoi, asarrf)

## ## Cit
## citpop <- get_csv_data("Cit", 100, instrument_name, pop_csv_query)
## citlin <- get_csv_data("Cit", 100, instrument_name, linearity_csv_query)
## citrrf <- find_rrf(citpop, citlin)
## make_plots("Cit", citpop, citlin, citrrf, 50, 25 )
## citqc <- get_csv_viewdata("Cit", instrument_name, qc_csv_query)
## citmoi <- get_csv_viewdata("Cit", instrument_name, moi_csv_query)
## make_ts("Cit", citqc, citmoi, citrrf)

## ## Leu
## params = list('Leu', 400, 400, instrument_name)
## leupop <- with_con(make_csv_query("Xleu", pop_csv_query), params)
## leulin <- with_con(make_csv_query("Xleu", linearity_csv_query) , params)
## leurrf <- find_rrf(leupop, leulin)
## make_plots("Leu", leupop, leulin, leurrf, 200, 50)
## view_params <- list('Leu', instrument_name)
## leuqc <- with_con(make_csv_query("Leu", qc_csv_query) , view_params)
## leumoi <- with_con(make_csv_query("Leu", moi_csv_query) , view_params)
## make_ts("Leu", leuqc, leumoi, leurrf)


## ## Met
## metpop <- get_csv_data("Met", 100, instrument_name, pop_csv_query)
## metlin <- get_csv_data("Met", 100, instrument_name, linearity_csv_query)
## metrrf <- find_rrf(metpop, metlin)
## make_plots("Met", metpop, metlin, metrrf, 50, 25 )
## metqc <- get_csv_viewdata("Met", instrument_name, qc_csv_query)
## metmoi <- get_csv_viewdata("Met", instrument_name, moi_csv_query)
## make_ts("Met", metqc, metmoi, metrrf)


## ## Phe
## phepop <- get_csv_data("Phe", 200, instrument_name, pop_csv_query)
## phelin <- get_csv_data("Phe", 200, instrument_name, linearity_csv_query)
## pherrf <- find_rrf(phepop, phelin)
## make_plots("Phe", phepop, phelin, pherrf, 50, 25 )
## pheqc <- get_csv_viewdata("Phe", instrument_name, qc_csv_query)
## phemoi <- get_csv_viewdata("Phe", instrument_name, moi_csv_query)
## make_ts("Phe", pheqc, phemoi, pherrf)


## ## Tyr
## tyrpop <- get_csv_data("Tyr", 200, instrument_name, pop_csv_query)
## tyrlin <- get_csv_data("Tyr", 200, instrument_name, linearity_csv_query)
## tyrrrf <- find_rrf(tyrpop, tyrlin)
## make_plots("Tyr", tyrpop, tyrlin, tyrrrf, 50, 25 )
## tyrqc <- get_csv_viewdata("Tyr", instrument_name, qc_csv_query)
## tyrmoi <- get_csv_viewdata("Tyr", instrument_name, moi_csv_query)
## make_ts("Tyr", tyrqc, tyrmoi, tyrrrf)

## ## SUAC 
## suacpop <- get_csv_data("SUAC", 10, instrument_name, pop_csv_query)
## suaclin <- get_csv_data("SUAC", 10, instrument_name, linearity_csv_query)
## suacrrf <- find_rrf(suacpop, suaclin)
## make_plots("SUAC", suacpop, suaclin, suacrrf, 4, 25 )
## suacqc <- get_csv_viewdata("SUAC", instrument_name, qc_csv_query)
## suacmoi <- get_csv_viewdata("SUAC", instrument_name, moi_csv_query)
## make_ts("SUAC", suacqc, suacmoi, suacrrf)

## ## GUAC 
## guacpop <- get_csv_data("GUAC", 10, instrument_name, pop_csv_query)
## guaclin <- get_csv_data("GUAC", 10, instrument_name, linearity_csv_query)
## guacrrf <- find_rrf(guacpop, guaclin)
## make_plots("GUAC", guacpop, guaclin, guacrrf, 4, 2 )
## guacqc <- get_csv_viewdata("GUAC", instrument_name, qc_csv_query)
## guacmoi <- get_csv_viewdata("GUAC", instrument_name, moi_csv_query)
## make_ts("GUAC", guacqc, guacmoi, guacrrf)


## ## AC
## #ac_primary <- c("C0","C2","C3","C5","C6","C8","C10","C14:1","C16OH") C5DC

## ## C0
## c0pop <- get_csv_data("C0", 150, instrument_name, pop_csv_query)
## c0lin <- get_csv_data("C0", 150, instrument_name, linearity_csv_query)
## c0rrf <- find_rrf(c0pop, c0lin)
## make_plots("C0", c0pop, c0lin, c0rrf, 75, 20 )
## c0qc <- get_csv_viewdata("C0", instrument_name, qc_csv_query)
## c0moi <- get_csv_viewdata("C0", instrument_name, moi_csv_query)
## make_ts("C0", c0qc, c0moi, c0rrf)

## ## C2
## c2pop <- get_csv_data("C2", 150, instrument_name, pop_csv_query)
## c2lin <- get_csv_data("C2", 150, instrument_name, linearity_csv_query)
## c2rrf <- find_rrf(c2pop, c2lin)
## make_plots("C2", c2pop, c2lin, c2rrf, 75, 20 )
## c2qc <- get_csv_viewdata("C2", instrument_name, qc_csv_query)
## c2moi <- get_csv_viewdata("C2", instrument_name, moi_csv_query)
## make_ts("C2", c2qc, c2moi, c2rrf)


## ## C3
## c3pop <- get_csv_data("C3", 15, instrument_name, pop_csv_query)
## c3lin <- get_csv_data("C3", 15, instrument_name, linearity_csv_query)
## c3rrf <- find_rrf(c3pop, c3lin)
## make_plots("C3", c3pop, c3lin, c3rrf, 2, 2 )
## c3qc <- get_csv_viewdata("C3", instrument_name, qc_csv_query)
## c3moi <- get_csv_viewdata("C3", instrument_name, moi_csv_query)
## make_ts("C3", c3qc, c3moi, c3rrf)

## ## C5
## c5pop <- get_csv_data("C5", 1, instrument_name, pop_csv_query)
## c5lin <- get_csv_data("C5", 1, instrument_name, linearity_csv_query)
## c5rrf <- find_rrf(c5pop, c5lin)
## make_plots("C5", c5pop, c5lin, c5rrf, 0.5 , 0.1)
## c5qc <- get_csv_viewdata("C5", instrument_name, qc_csv_query)
## c5moi <- get_csv_viewdata("C5", instrument_name, moi_csv_query)
## make_ts("C5", c5qc, c5moi, c5rrf)

## ## C5DC
## params = list('C5DC', 0.5, 0.5, instrument_name)
## c5dcpop <- with_con(make_csv_query("C5DC_C6OH", pop_csv_query), params)
## c5dclin <- with_con(make_csv_query("C5DC_C6OH", linearity_csv_query) , params)
## c5dcrrf <- find_rrf(c5dcpop, c5dclin)
## make_plots("C5DC", c5dcpop, c5dclin, c5dcrrf, 0.3, 0.1)
## view_params <- list('C5DC', instrument_name)
## c5dcqc <- with_con(make_csv_query("C5DC",qc_csv_query) , view_params)
## c5dcmoi <- with_con(make_csv_query("C5DC",moi_csv_query) , view_params)
## make_ts("C5DC", c5dcqc, c5dcmoi, c5dcrrf)


## ## C6
## c6pop <- get_csv_data("C6", 0.5, instrument_name, pop_csv_query)
## c6lin <- get_csv_data("C6", 0.5, instrument_name, linearity_csv_query)
## c6rrf <- find_rrf(c6pop, c6lin)
## make_plots("C6", c6pop, c6lin, c6rrf, 0.2, 0.7 )
## c6qc <- get_csv_viewdata("C6", instrument_name, qc_csv_query)
## c6moi <- get_csv_viewdata("C6", instrument_name, moi_csv_query)
## make_ts("C6", c6qc, c6moi, c6rrf)

## ## C8
## c8pop <- get_csv_data("C8", 1, instrument_name, pop_csv_query)
## c8lin <- get_csv_data("C8", 1, instrument_name, linearity_csv_query)
## c8rrf <- find_rrf(c8pop, c8lin)
## make_plots("C8", c8pop, c8lin, c8rrf, 0.5, 0.2)
## c8qc <- get_csv_viewdata("C8", instrument_name, qc_csv_query)
## c8moi <- get_csv_viewdata("C8", instrument_name, moi_csv_query)
## make_ts("C8", c8qc, c8moi, c8rrf)


## ## C10
## c10pop <- get_csv_data("C10", 1, instrument_name, pop_csv_query)
## c10lin <- get_csv_data("C10", 1, instrument_name, linearity_csv_query)
## c10rrf <- find_rrf(c10pop, c10lin)
## make_plots("C10", c10pop, c10lin, c10rrf, 0.4, 0.4 )
## c10qc <- get_csv_viewdata("C10", instrument_name, qc_csv_query)
## c10moi <- get_csv_viewdata("C10", instrument_name, moi_csv_query)
## make_ts("C10", c10qc, c10moi, c10rrf)

## ## C14:1
## params = list('C14:1', 1, 1, instrument_name)
## c141pop <- with_con(make_csv_query("C141", pop_csv_query), params)
## c141lin <-  with_con(make_csv_query("C141", linearity_csv_query) , params)
## c141rrf <- find_rrf(c141pop, c141lin)
## make_plots("C141", c141pop, c141lin, c141rrf, 0.5, 0.2 )
## view_params <- list('C14:1', instrument_name)
## c141qc <- with_con(make_csv_query("C141",qc_csv_query) , view_params)
## c141moi <- with_con(make_csv_query("C141",moi_csv_query) , view_params)
## make_ts("C141", c141qc, c141moi, c141rrf)

## ## C16
## c16pop <- get_csv_data("C16", 10, instrument_name, pop_csv_query)
## c16lin <- get_csv_data("C16", 10, instrument_name, linearity_csv_query)
## c16rrf <- find_rrf(c16pop, c16lin)
## make_plots("C16", c16pop, c16lin, c16rrf, 0.6, 0.2 )
## c16qc <- get_csv_viewdata("C16", instrument_name, qc_csv_query)
## c16moi <- get_csv_viewdata("C16", instrument_name, moi_csv_query)
## make_ts("C16", c16qc, c16moi, c16rrf)


## ## C16OH
## c16ohpop <- get_csv_data("C16OH", 0.4, instrument_name, pop_csv_query)
## c16ohlin <- get_csv_data("C16OH", 0.4, instrument_name, linearity_csv_query)
## c16ohrrf <- find_rrf(c16ohpop, c16ohlin)
## make_plots("C16OH", c16ohpop, c16ohlin, c16ohrrf, 0.2, 0.6 )
## c16ohqc <- get_csv_viewdata("C16OH", instrument_name, qc_csv_query)
## c16ohmoi <- get_csv_viewdata("C16OH", instrument_name, moi_csv_query)
## make_ts("C16OH", c16ohqc, c16ohmoi, c16ohrrf)

## ## C18
## c18pop <- get_csv_data("C18", 5, instrument_name, pop_csv_query)
## c18lin <- get_csv_data("C18", 5, instrument_name, linearity_csv_query)
## c18rrf <- find_rrf(c18pop, c18lin)
## make_plots("C18", c18pop, c18lin, c18rrf, 3, 1 )
## c18qc <- get_csv_viewdata("C18", instrument_name, qc_csv_query)
## c18moi <- get_csv_viewdata("C18", instrument_name, moi_csv_query)
## make_ts("C18", c18qc, c18moi, c18rrf)

## ## ## QC and linearity based RRF adjustment

## ## suac
## suaclowqc <- subset(suacqc, sample != "APPOS1")
## suacqcrrf <- find_rrf(suaclowqc, suaclin)
## make_plots("SUAC_QC", suacpop, suaclin, suacqcrrf, 4, 25)
## make_ts("SUAC_QC", suacqc, suacmoi, suacqcrrf)


## ## GUAC
## guaclowqc <- subset(guacqc, sample != "APPOS1")
## guacqcrrf <- find_rrf(guacqc, guaclin)
## make_plots("GUAC_QC", guacpop, guaclin, guacqcrrf, 4, 2 )
## make_ts("GUAC_QC", guacqc, guacmoi, guacqcrrf)


## ## C5
## c5lowqc <- subset(c5qc, sample != "APPOS2")
## c5qcrrf <- find_rrf(c5lowqc, c5lin)
## make_plots("C5_QC", c5pop, c5lin, c5qcrrf, 0.2, 0.7 )
## make_ts("C5_QC", c5qc, c5moi,c5qcrrf)

## ## C5DC
## c5dclowqc <- subset(c5dcqc, sample != "APPOS2")
## c5dcqcrrf <- find_rrf(c5dclowqc, c5dclin)
## make_plots("C5DC_QC", c5dcpop, c5dclin, c5dcqcrrf, 0.3, 0.1)
## qcparams <- list('C5DC_C6OH', 'C5DC')
## make_ts("C5DC_QC", c5dcqc, c5dcmoi, c5dcqcrrf)

## ## C6
## c6qcrrf <- find_rrf(c6qc, c6lin)
## make_plots("C6_QC", c6pop, c6lin, c6qcrrf, 0.2, 0.7 )
## make_ts("C6_QC", c6qc, c6moi, c6qcrrf)

## ## C8
## c8lowqc <- subset(c8qc, sample != "APPOS1")
## c8qcrrf <- find_rrf(c8lowqc, c8lin)
## make_plots("C8_QC", c8pop, c8lin, c8qcrrf, 0.5, 0.2)
## make_ts("C8_QC", c8qc, c8moi, c8qcrrf)

## ## C14:1
## c141qcrrf <- find_rrf(c141qc, c141lin)
## make_plots("C141_QC", c141pop, c141lin, c141qcrrf, 0.5, 0.2 )
## make_ts("C141_QC", c141qc, c141moi, c141qcrrf)

## ## C16OH
## c16ohqcrrf <- find_rrf(c16ohqc, c16ohlin)
## make_plots("C16OH_QC", c16ohpop, c16ohlin, c16ohqcrrf, 0.2, 0.6 )
## make_ts("C16OH_QC", c16ohqc, c16ohmoi, c16ohqcrrf)

## primary_analytes <- c("Ala" = alarrf, "Arg" = argrrf, "Cit" = citrrf, "Leu" = leurrf, "Met" = metrrf, "Phe" = pherrf,
##                       "Tyr" = tyrrrf, "SUAC" = 1, "GUAC" = guacqcrrf, "C0" = c0rrf,  "C2"= c2rrf, "C3"= c3rrf,
##                       "C5"= c5rrf, "C5DC"= c5dcrrf, "C6"= c6qcrrf , "C8"= c8rrf, "C10"= c10rrf ,"C141"= c141qcrrf,
##                       "C16" = c16rrf, "C16OH" = c16ohqcrrf, "C18" = c18rrf)


## rrfs_list <- c(primary_analytes, secondary_analytes)
## rrf_file_name <- paste0("../data/", instrument_name, "_RRF.csv")
## write.csv(rrfs_list, file = rrf_file_name)

## ## Amino acids
## make_mcr("Ala", alapop, alalin, alaqc)
## make_mcr("Arg", argpop, arglin, argqc)
## make_mcr("Cit", citpop, citlin, citqc)
## make_mcr("Leu", leupop, leulin, leuqc)
## make_mcr("Met", metpop, metlin, metqc)
## make_mcr("Phe", phepop, phelin, pheqc)
## make_mcr("Tyr", tyrpop, tyrlin, tyrqc)
## make_mcr("SUAC", suacpop, suaclin, suacqc)
## make_mcr("GUAC", guacpop, guaclin, guacqc)


## ## Acylcarnitines
## make_mcr("C0", c0pop, c0lin, c0qc)
## make_mcr("C2", c2pop, c2lin, c2qc)
## make_mcr("C3", c3pop, c3lin, c3qc)
## make_mcr("C5", c5pop, c5lin, c5qc)
## make_mcr("C5DC", c5dcpop, c5dclin, c5dcqc)
## make_mcr("C6", c6pop, c6lin, c6qc)
## make_mcr("C8", c8pop, c8lin, c8qc)
## make_mcr("C10", c10pop, c10lin, c10qc)
## make_mcr("C141", c141pop, c141lin, c141qc)
## make_mcr("C16", c16pop, c16lin, c16qc)
## make_mcr("C16OH", c16ohpop, c16ohlin, c16ohqc)
## make_mcr("C18", c18pop, c18lin, c18qc)


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


## Cre
params = list('CRT', 1000, 1000, instrument_name)
crepop <- with_con(make_csv_query("Cre", pop_csv_query), params)
crelin <- with_con(make_csv_query("Cre", linearity_csv_query) , params)
crerrf <- find_rrf(crepop, crelin)
make_plots("Cre", crepop, crelin, crerrf, 50, 25)
view_params <- list('CRT', instrument_name)
creqc <- with_con(make_csv_query("Cre",qc_csv_query) , view_params)
cremoi <- with_con(make_csv_query("Cre",moi_csv_query) , view_params)
make_ts("Cre", creqc, cremoi, crerrf)


### AC secondary

## C4
c4pop <- get_csv_data("C4", 1, instrument_name, pop_csv_query)
c4lin <- get_csv_data("C4", 1, instrument_name, linearity_csv_query)
c4rrf <- find_rrf(c4pop, c4lin)
make_plots("C4", c4pop, c4lin, c4rrf, 0.5, 0.2)
c4qc <- get_csv_viewdata("C4", instrument_name, qc_csv_query)
c4moi <- get_csv_viewdata("C4", instrument_name, moi_csv_query)
make_ts("C4", c4qc, c4moi, c4rrf)

## C5:1
params = list('C5:1', 1, 1, instrument_name)
c51pop <- with_con(make_csv_query("C51", pop_csv_query), params)
c51lin <-  with_con(make_csv_query("C51", linearity_csv_query) , params)
c51rrf <- find_rrf(c51pop, c51lin)
make_plots("C51", c51pop, c51lin, c51rrf, 0.5, 0.2 )
view_params <- list('C5:1', instrument_name)
c51qc <- with_con(make_csv_query("C51",qc_csv_query) , view_params)
c51moi <- with_con(make_csv_query("C51",moi_csv_query) , view_params)
make_ts("C51", c51qc, c51moi, c51rrf)

## C3DC_C4OH
params = list('C4OH', 2.0, 2.0, instrument_name)
c3dcpop <- with_con(make_csv_query("C3DC_C4OH", pop_csv_query), params)
c3dclin <- with_con(make_csv_query("C3DC_C4OH", linearity_csv_query), params)
c3dcrrf <- find_rrf(c3dcpop, c3dclin)
make_plots("C3DC_C4OH", c3dcpop, c3dclin, c3dcrrf, 0.3, 0.1)
view_params <- list('C4OH', instrument_name)
c3dcqc <- with_con(make_csv_query("C4OH", qc_csv_query), view_params)
c3dcmoi <- with_con(make_csv_query("C4OH", moi_csv_query), view_params)
make_ts("C3DC_C4OH", c3dcqc, c3dcmoi, c3dcrrf)


## C4DC_C5OH
params = list('C5OH', 2.0, 2.0, instrument_name)
c4dcpop <- with_con(make_csv_query("C4DC_C5OH", pop_csv_query), params)
c4dclin <- with_con(make_csv_query("C4DC_C5OH", linearity_csv_query), params)
c4dcrrf <- find_rrf(c4dcpop, c4dclin)
make_plots("C4DC_C5OH", c4dcpop, c4dclin, c4dcrrf, 0.4, 0.1)
view_params <- list('C5OH', instrument_name)
c4dcqc <- with_con(make_csv_query("C5OH", qc_csv_query), view_params)
c4dcmoi <- with_con(make_csv_query("C5OH", moi_csv_query), view_params)
make_ts("C4DC_C5OH", c4dcqc, c4dcmoi, c4dcrrf)


## C8:1
params = list('C8:1', 1, 1, instrument_name)
c81pop <- with_con(make_csv_query("C81", pop_csv_query), params)
c81lin <-  with_con(make_csv_query("C81", linearity_csv_query) , params)
c81rrf <- find_rrf(c81pop, c81lin)
make_plots("C81", c81pop, c81lin, c81rrf, 0.5, 0.2 )
view_params <- list('C8:1', instrument_name)
c81qc <- with_con(make_csv_query("C81",qc_csv_query) , view_params)
c81moi <- with_con(make_csv_query("C81",moi_csv_query) , view_params)
make_ts("C81", c81qc, c81moi, c81rrf)


## C10:1
params = list('C10:1', 1, 1, instrument_name)
c101pop <- with_con(make_csv_query("C101", pop_csv_query), params)
c101lin <-  with_con(make_csv_query("C101", linearity_csv_query) , params)
c101rrf <- find_rrf(c101pop, c101lin)
make_plots("C101", C101pop, C101lin, C101rrf, 0.5, 0.2 )
view_params <- list('C10:1', instrument_name)
c101qc <- with_con(make_csv_query("C101",qc_csv_query) , view_params)
c101moi <- with_con(make_csv_query("C101",moi_csv_query) , view_params)
make_ts("C101", c101qc, c101moi, c101rrf)


## C12:1
params = list('C12:1', 1, 1, instrument_name)
c121pop <- with_con(make_csv_query("C121", pop_csv_query), params)
c121lin <-  with_con(make_csv_query("C121", linearity_csv_query) , params)
c121rrf <- find_rrf(c121pop, c121lin)
make_plots("C121", c121pop, c121lin, c121rrf, 0.5, 0.2 )
view_params <- list('C12:1', instrument_name)
c121qc <- with_con(make_csv_query("C121",qc_csv_query) , view_params)
c121moi <- with_con(make_csv_query("C121",moi_csv_query) , view_params)
make_ts("C121", c121qc, c121moi, c121rrf)


## C12
c12pop <- get_csv_data("C12", 1, instrument_name, pop_csv_query)
c12lin <- get_csv_data("C12", 1, instrument_name, linearity_csv_query)
c12rrf <- find_rrf(c12pop, c12lin)
make_plots("C12", c12pop, c12lin, c12rrf, 0.5, 0.2)
c12qc <- get_csv_viewdata("C12", instrument_name, qc_csv_query)
c12moi <- get_csv_viewdata("C12", instrument_name, moi_csv_query)
make_ts("C12", c12qc, c12moi, c12rrf)

## C142
params = list('C14:2', 1, 1, instrument_name)
c142pop <- with_con(make_csv_query("C142", pop_csv_query), params)
c142lin <-  with_con(make_csv_query("C142", linearity_csv_query) , params)
c142rrf <- find_rrf(c142pop, c142lin)
make_plots("C142", c142pop, c142lin, c142rrf, 0.5, 0.2 )
view_params <- list('C14:2', instrument_name)
c142qc <- with_con(make_csv_query("C142",qc_csv_query) , view_params)
c142moi <- with_con(make_csv_query("C142",moi_csv_query) , view_params)
make_ts("C142", c142qc, c142moi, c142rrf)


## C14
c14pop <- get_csv_data("C14", 1, instrument_name, pop_csv_query)
c14lin <- get_csv_data("C14", 1, instrument_name, linearity_csv_query)
c14rrf <- find_rrf(c14pop, c14lin)
make_plots("C14", c14pop, c14lin, c14rrf, 0.5, 0.2)
c14qc <- get_csv_viewdata("C14", instrument_name, qc_csv_query)
c14moi <- get_csv_viewdata("C14", instrument_name, moi_csv_query)
make_ts("C14", c14qc, c14moi, c14rrf)


## C14OH
c14ohpop <- get_csv_data("C14OH", 1, instrument_name, pop_csv_query)
c14ohlin <- get_csv_data("C14OH", 1, instrument_name, linearity_csv_query)
c14ohrrf <- find_rrf(c14ohpop, c14ohlin)
make_plots("C14OH", c14ohpop, c14ohlin, c14ohrrf, 0.5, 0.2)
c14ohqc <- get_csv_viewdata("C14OH", instrument_name, qc_csv_query)
c14ohmoi <- get_csv_viewdata("C14OH", instrument_name, moi_csv_query)
make_ts("C14OH", c14ohqc, c14ohmoi, c14ohrrf)

##C161OH 
params = list('C16:1OH', 1, 1, instrument_name)
c161ohpop <- with_con(make_csv_query("C161OH", pop_csv_query), params)
c161ohlin <-  with_con(make_csv_query("C161OH", linearity_csv_query) , params)
c161ohrrf <- find_rrf(c161ohpop, c161ohlin)
make_plots("C161OH", c161ohpop, c161ohlin, c161ohrrf, 0.5, 0.2 )
view_params <- list('C16:1OH', instrument_name)
c161ohqc <- with_con(make_csv_query("C161OH",qc_csv_query) , view_params)
c161ohmoi <- with_con(make_csv_query("C161OH",moi_csv_query) , view_params)
make_ts("C161OH", c161ohqc, c161ohmoi, c161ohrrf)

## C182
params = list('C18:2', 1, 1, instrument_name)
c182pop <- with_con(make_csv_query("C182", pop_csv_query), params)
c182lin <-  with_con(make_csv_query("C182", linearity_csv_query) , params)
c182rrf <- find_rrf(c182pop, c182lin)
make_plots("C182", c182pop, c182lin, c182rrf, 0.5, 0.2 )
view_params <- list('C18:2', instrument_name)
c182qc <- with_con(make_csv_query("C182",qc_csv_query) , view_params)
c182moi <- with_con(make_csv_query("C182",moi_csv_query) , view_params)
make_ts("C182", c182qc, c182moi, c182rrf)

## C181
params = list('C18:1', 4, 4, instrument_name)
c181pop <- with_con(make_csv_query("C181", pop_csv_query), params)
c181lin <-  with_con(make_csv_query("C181", linearity_csv_query) , params)
c181rrf <- find_rrf(c181pop, c181lin)
make_plots("C181", c181pop, c181lin, c181rrf, 0.5, 0.2 )
view_params <- list('C18:1', instrument_name)
c181qc <- with_con(make_csv_query("C181",qc_csv_query) , view_params)
c181moi <- with_con(make_csv_query("C181",moi_csv_query) , view_params)
make_ts("C181", c181qc, c181moi, c181rrf)


##C18OH 
c18ohpop <- get_csv_data("C18OH", 1, instrument_name, pop_csv_query)
c18ohlin <- get_csv_data("C18OH", 1, instrument_name, linearity_csv_query)
c18ohrrf <- find_rrf(c18ohpop, c18ohlin)
make_plots("C18OH", c18ohpop, c18ohlin, c18ohrrf, 0.5, 0.2)
c18ohqc <- get_csv_viewdata("C18OH", instrument_name, qc_csv_query)
c18ohmoi <- get_csv_viewdata("C18OH", instrument_name, moi_csv_query)
make_ts("C18OH", c18ohqc, c18ohmoi, c18ohrrf)


##C181OH 
params = list('C18:1OH', 1, 1, instrument_name)
c181ohpop <- with_con(make_csv_query("C181OH", pop_csv_query), params)
c181ohlin <-  with_con(make_csv_query("C181OH", linearity_csv_query) , params)
c181ohrrf <- find_rrf(c181ohpop, c181ohlin)
make_plots("C181OH", c181ohpop, c181ohlin, c181ohrrf, 0.5, 0.2 )
view_params <- list('C18:1OH', instrument_name)
c181ohqc <- with_con(make_csv_query("C181OH",qc_csv_query) , view_params)
c181ohmoi <- with_con(make_csv_query("C181OH",moi_csv_query) , view_params)
make_ts("C181OH", c181ohqc, c181ohmoi, c181ohrrf)


secondary_analytes <- c("Gly" = glyrrf, "Orn" = ornrrf, "Val" = valrrf, "Cre" = crerrf,
                        "C4" = c4rrf, "C51" = c51rrf , "C3DC_C4OH" = c3dcrrf, "C4DC_C5OH" = c4dcrrf, "C81" = c81rrf, "C101" = c101rrf,
                        "C121" = c121rrf, "C12" = c12rrf, "C142" = c142rrf, "C14" = c14rrf, "C14OH" = c14ohrrf, "C161OH" = c161ohrrf,
                        "C182" = c182rrf, "C181" = c181rrf, "C181OH" = c181ohrrf )
rrfs_list <- c(secondary_analytes)
rrf_file_name <- paste0("../data/", instrument_name, "_secondary_RRF.csv")
write.csv(rrfs_list, file = rrf_file_name)




