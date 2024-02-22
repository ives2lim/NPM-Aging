# RVTEST to execute single-SNP summary statistics and covariance matrices from each cohort required for the meta-analysis

for i in {ttsh,mec,prism,seed,helios}; do
for a in {chi,ind,mal}; do
for b in {1..22};do
rvtest --inVcf ${i}_${a}_chr${b}_cat2_snps.recode.vcf.gz \
--pheno ${i}_${a}.ped \
--covar ${i}_${a}.ped \
--pheno-name AA_G --covar-name SEX,PC1,PC2,PC3,PC4,PC5,PC6 \
--meta score,cov --inverseNormal --useResidualAsPhenotype \
--out ${i}_${a}_chr${b}_cat2_snps
done
done
done

# Raremetal to execute meta-analysis

raremetal --summaryFiles chi_chr1_cat2_snps_summary_files --covFiles chi_chr1_cat2_snps_cov_files --groupFile ttsh_chi_chr1_all_genes_marker_group \
 --SKAT --VT --burden --tabulateHits --hitsCutoff 1e-05 \
 --prefix chi_chr1_cat2_snps --hwe 1.0e-05 --callRate 0.95

