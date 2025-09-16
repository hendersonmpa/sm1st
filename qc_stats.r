library("tidyverse")
library("readxl")
source("./functions.r")


bill_rrf <- read.csv(file = "../data/Bill_RRF_20250916.csv") 

query_qc_stats <- "select sampletype as type, REGEXP_REPLACE(sample, 'SM1-', '') as sample,  analyte , count(sample) as count, avg(result) as mean, STDDEV_SAMP(result) as sd from sm1st
where sampletype = 'LQC'
and date(createdate) > '2025-06-01'
and analyte in ('Ala' ,'Arg', 'ASA', 'Cit', 'Xleu','Met', 'Phe', 'Tyr', 'SUAC', 'GUAC', 'C0', 'C2', 'C3', 'C5', 'C5DC_C6OH', 'C5:1', 'C6', 'C8', 'C10', 'C14:1', 'C16', 'C16OH', 'C18' , 'Gly', 'Orn' , 'Val')
and plate not in ('SM1ST2025010079', 'SM1ST2025010080', 'SM1ST2025010082', 'SM1ST2025010084', 'SM1ST2025010085', 'SM1ST2025010105', 'SM1ST2025010043', 'SM1ST2025010044', 'SM1ST2025010258', 'SM1ST2025010259', 'SM1ST2025010260')
group by sample, analyte
order by analyte, sample"

query_moi <- "select analyte, avg(result) as mean from sm1st
where sampletype = 'OBS'
and sample like 'N%'
and date(createdate) > '2025-06-01'
and plate not in ('SM1ST2025010079', 'SM1ST2025010080', 'SM1ST2025010082', 'SM1ST2025010084', 'SM1ST2025010085', 'SM1ST2025010105', 'SM1ST2025010043', 'SM1ST2025010044', 'SM1ST2025010258', 'SM1ST2025010259', 'SM1ST2025010260')
group by analyte"

qc_data <- with_con(query_qc_stats, params = c())

qc_merge <- merge(qc_data, bill_rrf, by= "analyte") %>%
    filter( sample %in% c('APNEG', 'APPOS1', 'APPOS2', 'NSOQC')) %>%
    transform(adjusted_mean = mean * rrf,
              adjusted_sd = sd * rrf)

write.csv(qc_merge, "../data/SM1ST_qc_stats.csv")

moi_data <- with_con(query_moi, params = c())

moi_merge <- merge(moi_data, bill_rrf, by= "analyte") %>%
    transform(adjusted_mean = mean * rrf)

write.csv(moi_merge, "../data/SM1ST_moi.csv")
