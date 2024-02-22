## Annotate VCF using SNPeff (Hg38 ref genome)

java -Xms18G -jar snpEff.jar eff -noStats -no-intergenic -canon -no-downstream -no-upstream -noHgvs -noShiftHgvs -noLof GRCh38.105 mec_chi_chr21_sample_QCed_dummy.recode.vcf > mec_chi_chr21_sample_QCed_dummy.snpeff.vcf

## Categorization of rare SNPs 
# SNP category: coding and loss of function SNPs

cat ttsh_chi_chr1_sample_QCed_dummy.snpeff.vcf | grep 'codon' >> ttsh_chi_chr1_cat2_snps
cat ttsh_chi_chr1_sample_QCed_dummy.snpeff.vcf | grep 'missense' >> ttsh_chi_chr1_cat2_snps
cat ttsh_chi_chr1_sample_QCed_dummy.snpeff.vcf | grep 'splice' >> ttsh_chi_chr1_cat2_snps
cat ttsh_chi_chr1_sample_QCed_dummy.snpeff.vcf | grep 'start' >> ttsh_chi_chr1_cat2_snps
cat ttsh_chi_chr1_sample_QCed_dummy.snpeff.vcf | grep 'stop' >> ttsh_chi_chr1_cat2_snps

for a in {mec,prism,seed,helios}; do
for i in {2..22}; do 
cat ${a}_chi_chr${i}_sample_QCed_dummy.snpeff.vcf | grep 'codon' >> ${a}_chi_chr${i}_cat2_snps
cat ${a}_chi_chr${i}_sample_QCed_dummy.snpeff.vcf | grep 'missense' >> ${a}_chi_chr${i}_cat2_snps
cat ${a}_chi_chr${i}_sample_QCed_dummy.snpeff.vcf | grep 'splice' >> ${a}_chi_chr${i}_cat2_snps
cat ${a}_chi_chr${i}_sample_QCed_dummy.snpeff.vcf | grep 'start' >> ${a}_chi_chr${i}_cat2_snps
cat ${a}_chi_chr${i}_sample_QCed_dummy.snpeff.vcf | grep 'stop' >> ${a}_chi_chr${i}_cat2_snps
done
done

# extract category specific SNPs
vcftools --gzvcf ttsh_chi_chr1_sample_QCed.vcf.gz --positions ttsh_chi_chr1_cat2_snps --recode --out ttsh_chi_chr1_cat2_snps
