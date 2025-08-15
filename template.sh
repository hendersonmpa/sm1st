#!/bin/bash

# Define the output file
declare -a FILE_NAME="comp_rrf_report.org"
declare -a INSTRUMENT="Bill"
declare -a primary_aa=("Ala" "Arg" "Cit" "Leu" "Met" "Phe" "Tyr" "SUAC" "GUAC")
declare -a primary_ac=("C0" "C2" "C3" "C5" "C5DC" "C6" "C8" "C10" "C141" "C16" "C16OH" "C18")
declare -a low_aa=("SUAC" "GUAC")
declare -a low_ac=("C5" "C5DC" "C6" "C8" "C141" "C16OH")
declare -a cdc=("SUAC")

# Clear the file if it exists, or create it
if [ -f "$FILE_NAME" ]; then
    echo "File '$FILE_NAME' exists. Deleting..."
    rm "$FILE_NAME" # Delete the file
else
    echo "File '$FILE_NAME' does not exist."
    echo "Creating new file '$FILE_NAME'..."
    touch "$FILE_NAME" # Create an empty file
fi

cat <<EOF >> "$FILE_NAME"
#+TITLE:   ${INSTRUMENT} SM1ST method comparison and RRF adjustment 
#+AUTHOR:    Brittany Wong, Nate McIntosh, Matthew Henderson
#+DATE:      \today
EOF

echo '#+INCLUDE: "./summary.org" :lines "4-"'  >> "$FILE_NAME"

echo "* Population and linearity based RRF" >> "$FILE_NAME"

# Amino acids
echo "** Primary Amino Acids" >> "$FILE_NAME"
for analyte in "${primary_aa[@]}"; do
    echo "*** $analyte" >> "$FILE_NAME"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_pop" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"
    
    echo "#+CAPTION[]:${analyte} QC and MOI time series population based RRF" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_ts" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_ts.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"

    echo "\clearpage" >> "$FILE_NAME"
    echo "Text written to $FILE_NAME"
done
echo "" >> "$FILE_NAME"

# Acylcarnitines
echo "** Primary Acylcarnitines" >> "$FILE_NAME"
for analyte in "${primary_ac[@]}"; do
    echo "*** $analyte" >> "$FILE_NAME"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_pop" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"

    echo "#+CAPTION[]:${analyte} QC and MOI timeseries with population based RRF" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_ts" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_ts.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"

    echo "\clearpage" >> "$FILE_NAME"
    echo "Text written to $FILE_NAME"
done

echo "* QC and linearity material based RRF" >> "$FILE_NAME"

# Amino acids
echo "** Low concentration primary amino acids" >> "$FILE_NAME"
for analyte in "${low_aa[@]}"; do
    echo "*** $analyte" >> "$FILE_NAME"
    echo "#+CAPTION[]:${analyte} QC and linearity based RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_QC_pop" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_QC.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"
    
    echo "#+CAPTION[]:${analyte} QC and MOI time series with QC and linearity based RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_QC_ts" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_QC_ts.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"

    echo "\clearpage" >> "$FILE_NAME"
    echo "Text written to $FILE_NAME"
done



echo "" >> "$FILE_NAME"
# Acylcarnitines
echo "** Low concentration primary acylcarnitines" >> "$FILE_NAME"
for analyte in "${low_ac[@]}"; do
    echo "*** $analyte" >> "$FILE_NAME"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_QC_pop" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_QC.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"

    echo "#+CAPTION[]:${analyte} QC and MOI time series with QC and linearity based RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_QC_ts" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_QC_ts.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"

    echo "\clearpage" >> "$FILE_NAME"
    echo "Text written to $FILE_NAME"
done

echo "* SM1ST and AAAC comparison" >> "$FILE_NAME"

# Amino acids
echo "** Primary Amino Acids" >> "$FILE_NAME"
for analyte in "${primary_aa[@]}"; do
    echo "*** $analyte" >> "$FILE_NAME"
    echo "#+CAPTION[]:${analyte} SM1ST and AAAC regression after RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_reg" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_regression.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"
    echo "\clearpage" >> "$FILE_NAME"
    echo "Text written to $FILE_NAME"
done
echo "" >> "$FILE_NAME"


echo "** Primary Acylcarnitines" >> "$FILE_NAME"
for analyte in "${primary_ac[@]}"; do
    echo "*** $analyte" >> "$FILE_NAME"
    echo "#+CAPTION[]:${analyte} SM1ST and AAAC regression after RRF adjustment" >> "$FILE_NAME"
    echo "#+NAME: fig:${analyte}_reg" >> "$FILE_NAME"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$FILE_NAME"
    echo "[[file:../figures/${analyte}_regression.pdf]]" >> "$FILE_NAME"
    echo "" >> "$FILE_NAME"
    echo "\clearpage" >> "$FILE_NAME"
    echo "Text written to $FILE_NAME"
done
echo "" >> "$FILE_NAME"
