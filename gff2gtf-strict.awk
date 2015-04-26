#!/usr/bin/awk

# GFF should be sorted: genes -> mRNA -> exons/CDS

BEGIN{
	FS="\t";
	OFS="\t";
	i = 0;
}

{
	if ($0 ~ /#/)
	{
		next;
	}
	if ($3 ~ /RNA/)
	{
		subname = "transcript";
	}
	else
	{
		subname = $3;
	}
	str = $9;
	sub(".*ID=", "", str);
	sub(";.*", "", str);
	annot[subname"_id"] = str;
	annot["gene_id"] = str;
	annot["transcript_id"] = str;
	str = $9;
	sub(".*Name=", "", str);
	sub(";.*", "", str);
	annot[subname"_name"] = str;

	gsub("Note=", "note \"", $9);
	gsub(";", "\"; ", $9);
	gsub("=", " \"", $9);
	if ($9 !~ ".*; $" )
		$9 = $9"\"; ";
	sub("ID", subname"_id", $9);
	sub("Name", subname"_name", $9);

	if ($3 == "gene")
	{
		strand = $7;
		en = 0;
		$9 = "gene_id \""annot["gene_id"]"\"; "
		print;	
	}
	else if ($3 == "mRNA")
	{
		$9 = "gene_id \""annot["gene_id"]"\"; transcript_id \""annot["transcript_id"]"\"; "
		print;	
	}
	else if ($3 == "CDS")
	{
		$9 = "gene_id \""annot["gene_id"]"\"; transcript_id \""annot["transcript_id"]"\"; ";
		$9 = $9"gene_name \""annot["gene_name"]"\"; transcript_name \""annot["transcript_name"]"\"; ";
		print;	
	}
	else if ($3 == "exon")
	{
		$9 = "gene_id \""annot["gene_id"]"\"; transcript_id \""annot["transcript_id"]"\"; exon_number \""++en"\"; gene_name \""annot["gene_name"]"\"; transcript_name \""annot["transcript_name"]"\"; "
		print;	
	}
	else if ($3 == "three_prime_UTR")
	{
		$9 = "gene_id \""annot["gene_id"]"\"; transcript_id \""annot["transcript_id"]"\"; "
		print;
	}
	else if ($3 == "five_prime_UTR")
	{
		$9 = "gene_id \""annot["gene_id"]"\"; transcript_id \""annot["transcript_id"]"\"; "
		print;
	}
	else if ($3 == "protein")
	{
		$9 = "gene_id \""annot["gene_id"]"\"; transcript_id \""annot["transcript_id"]"\"; gene_name \""annot["gene_name"]"\"; transcript_name \""annot["transcript_name"]"\";";
		print;
	}

}

# complex and useless numeration of exons
#		i = 0;
#		while (en[++i] > 0)
#		{
#			if (en[i] == $4)
#			{
#				break;
#			}
#			else if (strand == "+" && en[i] > $4)
#			{
#				for (j = EXON_NUM; j > i; j--)
#				{
#					en[j] = en[j - 1];
#				}
#				en[i] = $4;
#				break;			
#			} 
#			else if (strand == "-" && en[i] < $4)
#			{
#				for (j = EXON_NUM; j > i; j--)
#				{
#					en[j] = en[j - 1];
#				}
#				en[i] = $4;
#				break;
#			}		
#		}
#		if (en[i] == 0)
#			en[i] = $4;
