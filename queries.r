## for population data
## use data after May 20th when arg was moved from the cit MRM channel 
query_population <- "select date(sm1.createdate) as date, sm1.instrument as sm1_instrument, aaac.instrument AS aaac_instrument, sm1.sample as sample, sm1.analyte as analyte, sm1.result as sm1st, aaac.result as aaac
from sm1st as sm1
left join aaac on sm1.sample = aaac.sample
where sm1.analyte = ?
and aaac.analyte = ?
and sm1.result <= ?
and aaac.result <= ?
and sm1.sampletype = 'OBS'
and sm1.sample like 'N%'
and date(sm1.createdate) > '2025-05-20'
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


query_linearity <- "select date(sm1.createdate) as date, sm1.instrument as sm1_instrument, aaac.instrument AS aaac_instrument, regexp_substr(aaac.sample, 'CDClin[[:digit:]]+') as sample, sm1.analyte as analyte, 
sm1.result as sm1st, aaac.result as aaac
from sm1st as sm1
join aaac on regexp_substr(sm1.sample, 'CDClin[[:digit:]]+') = regexp_substr(aaac.sample, 'CDClin[[:digit:]]+') 
and week(sm1.createdate) = week(aaac.createdate) 
and sm1.analyte = ?
and aaac.analyte = ?
and sm1.result <= ?
and aaac.result <= ?
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
and date(sm.date) > '2025-04-17'"


## for moi
## create views
## create view smqc as select date(createdate) as date, sampletype as type, REGEXP_REPLACE(sample, 'SM1-', '') as sample,  analyte , avg(result) as mean from sm1st
## where sampletype = 'LQC'
## and analyte in ('Ala' ,'Arg', 'ASA', 'Cit', 'Xleu','Met', 'Phe', 'Tyr', 'SUAC', 'GUAC', 'C0', 'C2', 'C3', 'C5', 'C5DC_C6OH', 'C5:1', 'C6', 'C8', 'C10', 'C14:1', 'C16', 'C16OH', 'C18')
## and plate not in ('SM1ST2025010079', 'SM1ST2025010080', 'SM1ST2025010082', 'SM1ST2025010084', 'SM1ST2025010085', 'SM1ST2025010105', 'SM1ST2025010043', 'SM1ST2025010044', 'SM1ST2025010258', 'SM1ST2025010259', 'SM1ST2025010260')
## group by date(createdate), sample, analytep

## create view aaacqc as select date(createdate) as date, sampletype as type, sample,  analyte , avg(result) as mean from aaac
## where sampletype = 'LQC'
## and analyte in ('Ala' ,'Arg', 'ASA', 'Cit', 'Leu', 'Met', 'Phe', 'Tyr', 'SUAC', 'GUAC', 'C0', 'C2', 'C3', 'C5', 'C5DC', 'C5:1', 'C6', 'C8', 'C10', 'C14:1', 'C16', 'C16OH', 'C18')
## group by date(createdate), sample, analyte

query_moi <- "select sm.date, sm.analyte, sm.mean as sm1st, aaac.mean as aaac from smmoi as sm
inner join aaacmoi as aaac 
on sm.date = aaac.date
where sm.analyte = ?
and aaac.analyte = ?"
