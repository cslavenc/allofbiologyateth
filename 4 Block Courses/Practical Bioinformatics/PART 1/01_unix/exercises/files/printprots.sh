#!/bin/bash

for filename in *.fasta
do
	grep -v ">" *.fasta
	wc -l *.fasta
done
