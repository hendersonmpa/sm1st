## for population data
## use data after May 20th when arg was moved from the cit MRM channel 
query_population <- "select date(sm1.createdate) as date, sm1.instrument as sm1_instrument, aaac.instrument AS aaac_instrument, sm1.sample as sample, sm1.result as sm1st, aaac.result as aaac
from sm1st as sm1
left join aaac on sm1.sample = aaac.sample
where sm1.analyte = ?
and aaac.analyte = ?
and sm1.result <= ?
and aaac.result <= ?
and sm1.sampletype = 'OBS'
and sm1.sample like 'N%'
and date(sm1.createdate) between '2025-06-01' and '2025-09-16'
and date(sm1.createdate) not in ('2025-07-15', '2025-07-16', '2025-07-17')
and sm1.plate not in ('SM1ST2025010079', 'SM1ST2025010080', 'SM1ST2025010082', 'SM1ST2025010084', 'SM1ST2025010085', 'SM1ST2025010105', 'SM1ST2025010043', 'SM1ST2025010044', 'SM1ST2025010258', 'SM1ST2025010259', 'SM1ST2025010260')"


## for linearity materials
## query_linearity <- "select date(sm1.createdate) as date, sm1.instrument as sm1_instrument, aaac.instrument AS aaac_instrument, sm1.sample as sample, sm1.analyte as analyte, 
## sm1.result as sm1st, aaac.result as aaac
## from sm1st as sm1
## join aaac on regexp_substr(sm1.sample, 'CDClin[[:digit:]]+') = regexp_substr(aaac.sample, 'CDClin[[:digit:]]+') 
## and date(sm1.createdate) = date(aaac.createdate) 
## and sm1.analyte = ?
## and aaac.analyte = ?
## and sm1.result <= ?
## and aaac.result <= ?
## and date(sm1.createdate) not in ('2025-07-15', '2025-07-16', '2025-07-17')
## and sm1.plate not in ('SM1ST2025010079', 'SM1ST2025010080', 'SM1ST2025010082', 'SM1ST2025010084', 'SM1ST2025010085', 'SM1ST2025010105', 'SM1ST2025010043', 'SM1ST2025010044', 'SM1ST2025010258', 'SM1ST2025010259', 'SM1ST2025010260')"


query_linearity <- "select distinct date(sm1.createdate) as date, sm1.instrument as sm1_instrument, aaac.instrument AS aaac_instrument, regexp_substr(aaac.sample, 'CDClin[[:digit:]]+') as sample,  
sm1.result as sm1st, aaac.result as aaac
from sm1st as sm1
join aaac on regexp_substr(sm1.sample, 'CDClin[[:digit:]]+') = regexp_substr(aaac.sample, 'CDClin[[:digit:]]+') 
and week(sm1.createdate) = week(aaac.createdate) 
and sm1.analyte = ?
and aaac.analyte = ?
and sm1.result <= ?
and aaac.result <= ?
and date(sm1.createdate)  between '2025-06-01' and '2025-09-16'
and date(sm1.createdate) not in ('2025-07-15', '2025-07-16', '2025-07-17')
and sm1.plate not in ('SM1ST2025010079', 'SM1ST2025010080', 'SM1ST2025010082', 'SM1ST2025010084', 'SM1ST2025010085', 'SM1ST2025010105', 'SM1ST2025010043', 'SM1ST2025010044', 'SM1ST2025010258', 'SM1ST2025010259', 'SM1ST2025010260')"


## for qc
## create views
## create view smqc as select date(createdate) as date, sampletype as type, REGEXP_REPLACE(sample, 'SM1-', '') as sample,  analyte , avg(result) as mean from sm1st
## where sampletype = 'LQC'
## and analyte in ('Ala' ,'Arg', 'ASA', 'Cit', 'Leu', 'Met', 'Phe', 'Tyr', 'SUAC', 'GUAC', 'C0', 'C2', 'C3', 'C5', 'C5DC_C6OH', 'C5:1', 'C6', 'C8', 'C10', 'C14:1', 'C16', 'C16OH', 'C18')
## group by date(createdate), sample, analyte

## create view aaacqc as select date(createdate) as date, sampletype as type, sample,  analyte , avg(result) as mean from aaac
## where sampletype = 'LQC'
## and analyte in ('Ala' ,'Arg', 'ASA', 'Cit', 'Leu', 'Met', 'Phe', 'Tyr', 'SUAC', 'GUAC', 'C0', 'C2', 'C3', 'C5', 'C5DC', 'C5:1', 'C6', 'C8', 'C10', 'C14:1', 'C16', 'C16OH', 'C18')
## group by date(createdate), sample, analyte

## New lot of QC material April 17th
query_qc <- "select sm.date, sm.sample, sm.analyte, sm.mean as sm1st, aaac.mean as aaac from smqc as sm
inner join aaacqc as aaac 
on sm.sample = aaac.sample
and sm.date = aaac.date
where sm.analyte = ?
and aaac.analyte = ?
and date(sm.date) > '2025-06-01'"

## for moi
## create views
## create view smmoi as select date(createdate) as date, sampletype as sample, analyte, avg(result) as mean from sm1st
## where sampletype = 'OBS'
## and sample like 'N%'
## and plate not in ('SM1ST2025010079', 'SM1ST2025010080', 'SM1ST2025010082', 'SM1ST2025010084', 'SM1ST2025010085', 'SM1ST2025010105', 'SM1ST2025010043', 'SM1ST2025010044', 'SM1ST2025010258', 'SM1ST2025010259', 'SM1ST2025010260')
## group by date(createdate), analyte

## create view aaacmoi as select date(createdate) as date, sampletype as sample, analyte, avg(result) as mean from aaac
## where sampletype = 'OBS'
## and sample like 'N%'
## group by date(createdate), analyte

query_moi <- "select sm.date, sm.analyte, sm.mean as sm1st, aaac.mean as aaac from smmoi as sm
inner join aaacmoi as aaac 
on sm.date = aaac.date
where sm.analyte = ?
and aaac.analyte = ?
and date(sm.date) > '2025-06-01'"


##### CSV table queries ####

pop_csv_query <- "select date(csv.createdate) as date, csv.instrument as sm1_instrument, aaac.instrument as aaac_instrument, csv.sample as sample, csv.ANALYTE as sm1st, aaac.result as aaac
from csv
left join aaac on csv.sample = aaac.sample
where aaac.analyte = ?
and csv.ANALYTE <= ?
and aaac.result <= ?
and csv.sample like 'N%'
and csv.instrument = ?"


#with_con(make_csv_query("Ala", pop_csv_query), params = c("Ala",1000,1000, "Joe"))

linearity_csv_query <- "select distinct date(csv.createdate) as date, csv.instrument as sm1_instrument, aaac.instrument AS aaac_instrument, regexp_substr(aaac.sample, 'CDClin[[:digit:]]+') as sample, csv.ANALYTE as sm1st, aaac.result as aaac
from csv
join aaac on regexp_substr(csv.sample, 'CDClin[[:digit:]]+') = regexp_substr(aaac.sample, 'CDClin[[:digit:]]+') 
and week(csv.createdate) = week(aaac.createdate)
where aaac.analyte = ?
and csv.ANALYTE <= ?
and aaac.result <= ?
and csv.instrument = ?"

#with_con(make_csv_query("Ala", linearity_csv_query), params = c("Ala",1000,1000, "Joe"))

## for qc
## create view csvqc as select csv.createdate as date, csv.instrument, REGEXP_REPLACE(sample, 'SM1-', '') as sample, avg(csv.Ala) as Ala, avg(csv.Arg) as Arg, avg(csv.Cit) as Cit, 
## avg(csv.Xleu) as Leu, avg(csv.Met) as Met, avg(csv.Phe) as Phe, avg(csv.Tyr) as Tyr, avg(csv.SUAC) as SUAC, avg(csv.GUAC) as GUAC, 
## avg(csv.C0) as C0, avg(csv.C2) as C2, avg(csv.C3) as C3, avg(csv.C5) as C5, avg(csv.C5DC_C6OH) as C5DC, avg(csv.C6) as C6, avg(csv.C8) as C8,
## avg(csv.C10) as C10, avg(csv.C141) as C141, avg(csv.C16) as C16, avg(csv.C16OH) as C16OH, avg(csv.C18) as C18 from csv
## where sample like 'SM1-%'
## group by csv.createdate, csv.instrument, csv.sample 

qc_csv_query <- "select csvqc.date, csvqc.sample, aaac.analyte, csvqc.ANALYTE as sm1st, aaac.mean as aaac from csvqc 
inner join aaacqc as aaac 
on csvqc.sample = aaac.sample
and csvqc.date = aaac.date
where aaac.analyte = ?
and csvqc.instrument = ?"


moi_csv_query <- "select csvmoi.date, aaac.analyte, csvmoi.ANALYTE as sm1st, aaac.mean as aaac from csvmoi 
inner join aaacmoi as aaac 
on csvmoi.date = aaac.date
where aaac.analyte = ?
and csvmoi.instrument = ?"



