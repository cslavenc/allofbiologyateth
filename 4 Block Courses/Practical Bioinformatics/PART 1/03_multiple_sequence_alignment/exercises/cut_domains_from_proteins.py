#!/usr/bin/python3

## first, open the file containing the protein sequences:
input_file_handle = open ("mfs_domain_proteins.fa")

## this dictionary will store the protein sequences from the file:
protein_sequence_dict = {}

sequence = ""  #### Empty string

for line in input_file_handle: ## this loop is repeated for each line in the file

    l = line.strip()   ## remove any 'white space' characters at the end of the line

    if l.startswith(">"): ## selects the lines starting with ">"

        if sequence!= "":
            protein_sequence_dict[uniprot_identifier] = sequence

        identifier_line = l.split(" ")   ## splits the line containing the identifier into words.
        uniprot_identifier = identifier_line[0].strip(">")
        sequence = ""

    else:
        sequence = sequence + l.strip("\n") ## removes the newline character and joins the sequence without newline character for a particular protein

## For the last entry:
protein_sequence_dict[uniprot_identifier] = sequence

## ok, now we have read in all protein sequences, and stored them in a hash.

## next, open the file with the domain coordinates:
domain_input_file_handle = open ("domains_found.tsv")

for line in domain_input_file_handle:

    if not line.startswith("#"):  ###### removes the line starting with hash

        l = line.strip().split() ############# for each line, split it into the various words according to the file format

        target_name = l[0]; accession =  l[1];  tlen = l[2] ; query_name =l[3]; domain_accession = l[4];
        qlen = l[5]; e_value = l[6]; score = l[7] ; bias = l[8];
        index_nr = l[9]; index_of = l[10] ; c_evalue = l[11]; i_evalue = l[12];
        domain_score = l[13]; domain_bias = l[14]; hmm_from = l[15]; hmm_to = l[16];
        ali_from = l[17]; ali_to = l[18];env_from = l[19]; env_to = l[20] ;
        acc = l[21];

        corrected_evalue = float (c_evalue)

        if corrected_evalue <= 0.000001:  ## only report significant domain matches

        	full_sequence = protein_sequence_dict[target_name] ## retrieve the corresponding protein sequence from our hash
        	domain_start = int(env_from)
        	domain_stop = int(env_to)
        	domain_sequence = full_sequence[domain_start:domain_stop]
        	print(">" + target_name + "." + env_from)
        	print(domain_sequence)

## that's it, we're done.
