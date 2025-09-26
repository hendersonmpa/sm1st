#!/bin/bash


# Options
shopt -s -o nounset  # reports undefined variables
shopt -s extglob # extended globbing

# Global Declarations

declare -r script=${0##*/}  # SCRIPT is the name of this script
declare -r src="./src"
declare -r reports="../reports"
declare -r today=$(date +"%F-%H-%M") ## YYYY-MM-DD-HH-MM
declare -a org_file_name="comp_rrf_report.org"
declare -a primary_aa=("Ala" "Arg" "Cit" "Leu" "Met" "Phe" "Tyr" "SUAC" "GUAC")
declare -a primary_ac=("C0" "C2" "C3" "C5" "C5DC_C6OH" "C6" "C8" "C10" "C141" "C16" "C16OH" "C18")
declare -a low_aa=("SUAC" "GUAC")
declare -a low_ac=("C5" "C5DC_C6OH" "C6" "C8" "C141" "C16OH")
declare -a cdc=("SUAC")
declare -a secondary_aa=("Gly" "Orn" "Val" "Cre")
declare -a secondary_ac=("C4" "C51" "C3DC_C4OH" "C4DC_C5OH" "C81" "C101" "C121" "C12" "C142" "C14" "C14OH" "C161OH" "C182" "C181" "C181OH")

echo -n " Enter the instrument name and press [ENTER]:  "
read instrument


# Sanity Checks

if [ -z "$BASH" ] ; then
    printf "$SCRIPT:$LINENO: please run this script with the BASH shell\n" >&2
    exit 192
fi


# Clear the file if it exists, or create it
if [ -f "$org_file_name" ]; then
    echo "File '$org_file_name' exists. Deleting..."
    rm "$org_file_name" # Delete the file
else
    echo "File '$org_file_name' does not exist."
    echo "Creating new file '$org_file_name'..."
    touch "$org_file_name" # Create an empty file
fi


cat <<EOF >> "$org_file_name"
#+TITLE:   ${instrument} SM1ST method comparison and RRF adjustment 
#+AUTHOR:    Brittany Wong, Nate McIntosh, Matthew Henderson
#+DATE:      \today
EOF

echo "#+INCLUDE: ./${instrument}_summary.org"  >> "$org_file_name"

echo "* Primary Analytes" >> "$org_file_name"
echo "** Population and linearity based RRF" >> "$org_file_name"


# Amino acids
echo "*** Primary Amino Acids" >> "$org_file_name"
for analyte in "${primary_aa[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_pop" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"
    
    echo "#+CAPTION[]:${analyte} QC and MOI time series population based RRF" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_ts" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_ts.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done
echo "" >> "$org_file_name"

# Acylcarnitines
echo "*** Primary Acylcarnitines" >> "$org_file_name"
for analyte in "${primary_ac[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_pop" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "#+CAPTION[]:${analyte} QC and MOI timeseries with population based RRF" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_ts" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_ts.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done



echo "** QC and linearity material based RRF" >> "$org_file_name"

# Amino acids
echo "*** Low concentration primary amino acids" >> "$org_file_name"
for analyte in "${low_aa[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} QC and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_QC_pop" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_QC.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"
    
    echo "#+CAPTION[]:${analyte} QC and MOI time series with QC and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_QC_ts" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_QC_ts.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done



echo "" >> "$org_file_name"
# Acylcarnitines
echo "*** Low concentration primary acylcarnitines" >> "$org_file_name"
for analyte in "${low_ac[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_QC_pop" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_QC.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "#+CAPTION[]:${analyte} QC and MOI time series with QC and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_QC_ts" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_QC_ts.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done

echo "** SM1ST and AAAC comparison" >> "$org_file_name"

# Amino acids
echo "*** Primary Amino Acids" >> "$org_file_name"
for analyte in "${primary_aa[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} SM1ST and AAAC regression after RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_reg" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_regression.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"
    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done
echo "" >> "$org_file_name"


echo "*** Primary Acylcarnitines" >> "$org_file_name"
for analyte in "${primary_ac[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} SM1ST and AAAC regression after RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_reg" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_regression.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"
    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done
echo "" >> "$org_file_name"



echo "* Secondary Analyte" >> "$org_file_name"
echo "** Population and linearity based RRF" >> "$org_file_name"

# Secondary Amino acids
echo "*** Secondary Amino Acids" >> "$org_file_name"
for analyte in "${secondary_aa[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_pop" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"
    
    echo "#+CAPTION[]:${analyte} QC and MOI time series population based RRF" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_ts" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_ts.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done
echo "" >> "$org_file_name"

echo "*** Secondary Acylcarnitines" >> "$org_file_name"
for analyte in "${secondary_ac[@]}"; do
    echo "**** $analyte" >> "$org_file_name"
    echo "#+CAPTION[]:${analyte} population and linearity based RRF adjustment" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_pop" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"
    
    echo "#+CAPTION[]:${analyte} QC and MOI time series population based RRF" >> "$org_file_name"
    echo "#+NAME: fig:${analyte}_ts" >> "$org_file_name"
    echo "#+ATTR_LaTeX: :width 1\textwidth"  >> "$org_file_name"
    echo "[[file:../figures/${instrument}/${analyte}_ts.pdf]]" >> "$org_file_name"
    echo "" >> "$org_file_name"

    echo "\clearpage" >> "$org_file_name"
    echo "Text written to $org_file_name"
done
echo "" >> "$org_file_name"



## Create the PDF report, rename and move

emacs -u "$(id -un)" \
      --batch \
      --eval '(load user-init-file)' \
      ${org_file_name}\
      -f org-latex-export-to-pdf 
mv ${org_file_name%.*}.pdf ${reports}/${instrument}_${org_file_name%.*}_${today}.pdf

