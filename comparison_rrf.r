### This script uses data from sm1st and aaac tables in the sm database
### Results from SM1ST run on Bill was compared to AAAC run on Larry, Joe and Jenna Jr
### Results from patient samples, CDC linearity materials and qualitity control materials are used to span a range of values relevant to newborns screening

library("tidyverse")

instrument = "Bill" ## used to set figures subdirectory in "functions"
source("./functions.r")

## Bill queries
source("./queries.r")
## Larry and Joe queries 
## TODO


## Amino acids
# aa_primary <- c("Ala","Arg","Asa","Cit","Met","Phe","Tyr","SUAC","GUAC") Leu

#Ala
alapop <- get_data("Ala", 600, query_population)
alalin <- get_data("Ala", 600, query_linearity)
alaqc <- get_viewdata("Ala", query_qc)
alarrf <- find_rrf(alapop, alalin)
make_plots("Ala", alapop, alalin, alarrf, 300, 100 )
alamoi <- get_viewdata("Ala", query_moi)
make_ts("Ala", alaqc,alamoi, alarrf)

## Arg
argpop <- get_data("Arg", 200, query_population)
argpopsub <- subset(argpop, date <= "2025-06-15") ##prior to bad RRF adjustment in mid June
arglin <- get_data("Arg", 200, query_linearity)
argrrf <- find_rrf(argpopsub, arglin)
make_plots("Arg", argpopsub, arglin, argrrf, 100, 25 )
argqc <- get_viewdata("Arg", query_qc)
argmoi <- get_viewdata("Arg", query_moi)
make_ts("Arg", argqc,argmoi, argrrf)


## ASA
asapop <- get_data("ASA", 100, query_population)
asalin <- get_data("ASA", 100, query_linearity)
asarrf <- find_rrf(asapop, asalin)
make_plots("ASA", asapop, asalin, asarrf, 0, 0 )
asaqc <- get_viewdata("ASA", query_qc)
asamoi <- get_viewdata("ASA", query_moi)
make_ts("ASA", asaqc, asamoi, asarrf)

## Cit
citpop <- get_data("Cit", 100, query_population)
citlin <- get_data("Cit", 100, query_linearity)
citrrf <- find_rrf(citpop, citlin)
make_plots("Cit", citpop, citlin, citrrf, 50, 25 )
citqc <- get_viewdata("Cit", query_qc)
citmoi <- get_viewdata("Cit", query_moi)
make_ts("Cit", citqc, citmoi, citrrf)

## Leu
params = list('Xleu', 'Leu', 400, 400)
leupop <- with_con(query_population , params)
leulin <- with_con(query_linearity , params)
leurrf <- find_rrf(leupop, leulin)
make_plots("Leu", leupop, leulin, leurrf, 200, 50)
view_params <- list('Xleu', 'Leu')
leuqc <- with_con(query_qc , view_params)
qcparams <- list('Xleu', 'Leu')
leumoi <- with_con(query_moi , view_params)
make_ts("Leu", leuqc, leumoi, leurrf)


## Met
metpop <- get_data("Met", 100, query_population)
metlin <- get_data("Met", 100, query_linearity)
metrrf <- find_rrf(metpop, metlin)
make_plots("Met", metpop, metlin, metrrf, 50, 25 )
metqc <- get_viewdata("Met", query_qc)
metmoi <- get_viewdata("Met", query_moi)
make_ts("Met", metqc, metmoi, metrrf)


## Phe
phepop <- get_data("Phe", 200, query_population)
phelin <- get_data("Phe", 200, query_linearity)
pherrf <- find_rrf(phepop, phelin)
make_plots("Phe", phepop, phelin, pherrf, 50, 25 )
pheqc <- get_viewdata("Phe", query_qc)
phemoi <- get_viewdata("Phe", query_moi)
make_ts("Phe", pheqc, phemoi, pherrf)


## Tyr
tyrpop <- get_data("Tyr", 200, query_population)
tyrpopsub <- subset(tyrpop, date >= "2025-05-15") ## change is SM1 results
tyrlin <- get_data("Tyr", 200, query_linearity)
tyrrrf <- find_rrf(tyrpopsub, tyrlin)
make_plots("Tyr", tyrpop, tyrlin, tyrrrf, 50, 25 )
tyrqc <- get_viewdata("Tyr", query_qc)
tyrmoi <- get_viewdata("Tyr", query_moi)
make_ts("Tyr", tyrqc, tyrmoi, tyrrrf)

## SUAC 
suacpop <- get_data("SUAC", 10, query_population)
suaclin <- get_data("SUAC", 10, query_linearity)
suacrrf <- find_rrf(suacpop, suaclin)
make_plots("SUAC", suacpop, suaclin, suacrrf, 4, 25 )
suacqc <- get_viewdata("SUAC", query_qc)
suacmoi <- get_viewdata("SUAC", query_moi)
make_ts("SUAC", suacqc, suacmoi, suacrrf)

## GUAC 
guacpop <- get_data("GUAC", 10, query_population)
guaclin <- get_data("GUAC", 10, query_linearity)
guacrrf <- find_rrf(guacpop, guaclin)
make_plots("GUAC", guacpop, guaclin, guacrrf, 4, 2 )
guacqc <- get_viewdata("GUAC", query_qc)
guacmoi <- get_viewdata("GUAC", query_moi)
make_ts("GUAC", guacqc, guacmoi, guacrrf)


## AC
#ac_primary <- c("C0","C2","C3","C5","C6","C8","C10","C14:1","C16OH") C5DC

## C0
c0pop <- get_data("C0", 150, query_population)
c0lin <- get_data("C0", 150, query_linearity)
c0rrf <- find_rrf(c0pop, c0lin)
make_plots("C0", c0pop, c0lin, c0rrf, 75, 20 )
c0qc <- get_viewdata("C0", query_qc)
c0moi <- get_viewdata("C0", query_moi)
make_ts("C0", c0qc, c0moi, c0rrf)

## C2
c2pop <- get_data("C2", 150, query_population)
c2lin <- get_data("C2", 150, query_linearity)
c2rrf <- find_rrf(c2pop, c2lin)
make_plots("C2", c2pop, c2lin, c2rrf, 75, 20 )
c2qc <- get_viewdata("C2", query_qc)
c2moi <- get_viewdata("C2", query_moi)
make_ts("C2", c2qc, c2moi, c2rrf)


## C3
c3pop <- get_data("C3", 15, query_population)
c3lin <- get_data("C3", 15, query_linearity)
c3rrf <- find_rrf(c3pop, c3lin)
make_plots("C3", c3pop, c3lin, c3rrf, 2, 2 )
c3qc <- get_viewdata("C3", query_qc)
c3moi <- get_viewdata("C3", query_moi)
make_ts("C3", c3qc, c3moi, c3rrf)

## C5
c5pop <- get_data("C5", 1, query_population)
c5lin <- get_data("C5", 1, query_linearity)
c5rrf <- find_rrf(c5pop, c5lin)
make_plots("C5", c5pop, c5lin, c5rrf, 0.5 , 0.1)
c5qc <- get_viewdata("C5", query_qc)
c5moi <- get_viewdata("C5", query_moi)
make_ts("C5", c5qc, c5moi, c5rrf)


## C5DC
params = list('C5DC_C6OH', 'C5DC', 1, 1)
c5dcpop <- with_con(query_population , params)
c5dclin <- with_con(query_linearity , params)
c5dcrrf <- find_rrf(c5dcpop, c5dclin)
make_plots("C5DC", c5dcpop, c5dclin, c5dcrrf, 0.3, 0.1)
view_params <- list('C5DC_C6OH', 'C5DC')
c5dcqc <- with_con(query_qc , view_params)
c5dcmoi <- with_con(query_moi , view_params)
make_ts("C5DC", c5dcqc, c5dcmoi, c5dcrrf)


## C6
c6pop <- get_data("C6", 0.5, query_population)
c6lin <- get_data("C6", 0.5, query_linearity)
c6rrf <- find_rrf(c6pop, c6lin)
make_plots("C6", c6pop, c6lin, c6rrf, 0.2, 0.7 )
c6qc <- get_viewdata("C6", query_qc)
c6moi <- get_viewdata("C6", query_moi)
make_ts("C6", c6qc, c6moi, c6rrf)

## C8
c8pop <- get_data("C8", 1, query_population)
c8lin <- get_data("C8", 1, query_linearity)
c8rrf <- find_rrf(c8pop, c8lin)
make_plots("C8", c8pop, c8lin, c8rrf, 0.5, 0.2)
c8qc <- get_viewdata("C8", query_qc)
c8moi <- get_viewdata("C8", query_moi)
make_ts("C8", c8qc, c8moi, c8rrf)


## C10
c10pop <- get_data("C10", 1, query_population)
c10lin <- get_data("C10", 1, query_linearity)
c10rrf <- find_rrf(c10pop, c10lin)
make_plots("C10", c10pop, c10lin, c10rrf, 0.4, 0.4 )
c10qc <- get_viewdata("C10", query_qc)
c10moi <- get_viewdata("C10", query_moi)
make_ts("C10", c10qc, c10moi, c10rrf)

## C14:1
c141pop <- get_data("C14:1", 1, query_population)
c141lin <- get_data("C14:1", 1, query_linearity)
c141rrf <- find_rrf(c141pop, c141lin)
make_plots("C141", c141pop, c141lin, c141rrf, 0.5, 0.2 )
c141qc <- get_viewdata("C14:1", query_qc)
c141moi <- get_viewdata("C14:1", query_moi)
make_ts("C141", c141qc, c141moi, c141rrf)

## C16
c16pop <- get_data("C16", 10, query_population)
c16lin <- get_data("C16", 10, query_linearity)
c16rrf <- find_rrf(c16pop, c16lin)
make_plots("C16", c16pop, c16lin, c16rrf, 0.6, 0.2 )
c16qc <- get_viewdata("C16", query_qc)
c16moi <- get_viewdata("C16", query_moi)
make_ts("C16", c16qc, c16moi, c16rrf)


## C16OH
c16ohpop <- get_data("C16OH", 0.4, query_population)
c16ohlin <- get_data("C16OH", 0.4, query_linearity)
c16ohrrf <- find_rrf(c16ohpop, c16ohlin)
make_plots("C16OH", c16ohpop, c16ohlin, c16ohrrf, 0.2, 0.6 )
c16ohqc <- get_viewdata("C16OH", query_qc)
c16ohmoi <- get_viewdata("C16OH", query_moi)
make_ts("C16OH", c16ohqc, c16ohmoi, c16ohrrf)

## C18
c18pop <- get_data("C18", 5, query_population)
c18lin <- get_data("C18", 5, query_linearity)
c18rrf <- find_rrf(c18pop, c18lin)
make_plots("C18", c18pop, c18lin, c18rrf, 3, 1 )
c18qc <- get_viewdata("C18", query_qc)
c18moi <- get_viewdata("C18", query_moi)
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
                      "C5"= c5qcrrf, "C5DC"= c5dcrrf, "C6"= c6qcrrf , "C8"= c8qcrrf, "C10"= c10rrf ,"C141"= c141qcrrf,
                      "C16" = c16rrf, "C16OH" = c16ohqcrrf, "C18" = c18rrf)


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






