
#!/usr/bin/env bash

Link="https://www.ncbi.nlm.nih.gov/pubmed/"

PMCLink="https://www.ncbi.nlm.nih.gov/pmc/articles/"

if [ -f NotFound.txt ] ; then
 rm NotFound.txt
fi

if [ -f Found.txt ] ; then
 rm Found.txt
fi

while read line
do
   
   echo $line

   for f in $line;
	
	do
	  PMCID=$(wget  --user-agent="Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" \
	   -l1 --no-parent ${Link}${f} -O - 2>/dev/null | grep -Po 'PMC\d+' | head -n 1)
	    if [ $PMCID ]; then
	       wget  --user-agent="Mozilla/5.0 (Windows NT 5.2; rv:2.0.1) Gecko/20100101 Firefox/4.0.1" \
	            -l1 --no-parent -A.pdf ${PMCLink}${PMCID}/pdf/ -O ${f}.pdf 2>/dev/null

	       echo $line >> Found.txt
	    else
	       echo "No PMC ID for $f"
	       echo $line >> NotFound.txt
	    fi

	done

done < PMIDs.txt

echo "--------" >> NotFound.txt
echo "--------" >> Found.txt