
# 1. In each cohort do SNP QC first to get a set of high quality common (MAF > 1%) SNPs, which will then be used for sample QC.
# a. Exclude non-biallelic variants
# b. Exclude variants with MAF < 1%
# c. Exclude variants with SNP call-rate < 95%
# d. HWE < 1e-8

for i in {1..22}; do plink --bfile chr${i} --keep gusto.txt --snps-only --biallelic-only strict --maf --geno 0.05 --hwe 1e-8 --make-bed --out gusto_chr${i}_SNP_QCed; done 
for i in {1..22}; do plink --bfile chr${i} --keep helios.txt --snps-only --biallelic-only strict --maf --geno 0.05 --hwe 1e-8 --make-bed --out helios_chr${i}_SNP_QCed; done 
for i in {1..22}; do plink --bfile chr${i} --keep mec.txt --snps-only --biallelic-only strict --maf --geno 0.05 --hwe 1e-8 --make-bed --out mec_chr${i}_SNP_QCed; done 
for i in {1..22}; do plink --bfile chr${i} --keep prism.txt --snps-only --biallelic-only strict --maf --geno 0.05 --hwe 1e-8 --make-bed --out prism_chr${i}_SNP_QCed; done 
for i in {1..22}; do plink --bfile chr${i} --keep ttsh.txt --snps-only --biallelic-only strict --maf --geno 0.05 --hwe 1e-8 --make-bed --out ttsh_chr${i}_SNP_QCed; done 
for i in {1..22}; do plink --bfile chr${i} --keep seed.txt --snps-only --biallelic-only strict --maf --geno 0.05 --hwe 1e-8 --make-bed --out seed_chr${i}_SNP_QCed; done 

# extract number of variants passing QC from log file
for i in {1..22}; do grep 'pass filters and QC' gusto_chr${i}_SNP_QCed.log >> gusto_QC_stats.txt; done
for i in {1..22}; do grep 'pass filters and QC' helios_chr${i}_SNP_QCed.log >> helios_QC_stats.txt; done
for i in {1..22}; do grep 'pass filters and QC' mec_chr${i}_SNP_QCed.log >> mec_QC_stats.txt; done
for i in {1..22}; do grep 'pass filters and QC' prism_chr${i}_SNP_QCed.log >> prism_QC_stats.txt; done
for i in {1..22}; do grep 'pass filters and QC' ttsh_chr${i}_SNP_QCed.log >> ttsh_QC_stats.txt; done
for i in {1..22}; do grep 'pass filters and QC' seed_chr${i}_SNP_QCed.log >> seed_QC_stats.txt; done

# combine seperate chrs into one file
for i in {1..22}; do plink --bfile gusto_chr${i}_SNP_QCed --recode vcf --out gusto_chr${i}_SNP_QCed; done
for i in {1..22}; do plink --bfile helios_chr${i}_SNP_QCed --recode vcf --out helios_chr${i}_SNP_QCed; done
for i in {1..22}; do plink --bfile mec_chr${i}_SNP_QCed --recode vcf --out mec_chr${i}_SNP_QCed; done
for i in {1..22}; do plink --bfile prism_chr${i}_SNP_QCed --recode vcf --out prism_chr${i}_SNP_QCed; done
for i in {1..22}; do plink --bfile ttsh_chr${i}_SNP_QCed --recode vcf --out ttsh_chr${i}_SNP_QCed; done
for i in {1..22}; do plink --bfile seed_chr${i}_SNP_QCed --recode vcf --out seed_chr${i}_SNP_QCed; done

bcftools concat -f gusto_chr_merge_list.txt -o gusto_all_chr_SNP_QCed.vcf -O v
bcftools concat -f helios_chr_merge_list.txt -o helios_all_chr_SNP_QCed.vcf -O v
bcftools concat -f mec_chr_merge_list.txt -o mec_all_chr_SNP_QCed.vcf -O v
bcftools concat -f prism_chr_merge_list.txt -o prism_all_chr_SNP_QCed.vcf -O v
bcftools concat -f ttsh_chr_merge_list.txt -o ttsh_all_chr_SNP_QCed.vcf -O v
bcftools concat -f seed_chr_merge_list.txt -o seed_all_chr_SNP_QCed.vcf -O v

plink --vcf gusto_all_chr_SNP_QCed.vcf --make-bed --out gusto_all_chr_SNP_QCed
plink --vcf helios_all_chr_SNP_QCed.vcf --make-bed --out helios_all_chr_SNP_QCed
plink --vcf mec_all_chr_SNP_QCed.vcf --make-bed --out mec_all_chr_SNP_QCed
plink --vcf prism_all_chr_SNP_QCed.vcf --make-bed --out prism_all_chr_SNP_QCed
plink --vcf ttsh_all_chr_SNP_QCed.vcf --make-bed --out ttsh_all_chr_SNP_QCed
plink --vcf seed_all_chr_SNP_QCed.vcf --make-bed --out seed_all_chr_SNP_QCed

# 2. Use this set of high quality common SNPs to do sample QC in each cohort.
# a. Exclude samples with sample call-rates < 95%
plink --bfile gusto_all_chr_SNP_QCed --mind 0.05 --make-bed --out all_chr_SNP_QCed_gusto_miss
plink --bfile helios_all_chr_SNP_QCed --mind 0.05 --make-bed --out all_chr_SNP_QCed_helios_miss
plink --bfile mec_all_chr_SNP_QCed --mind 0.05 --make-bed --out all_chr_SNP_QCed_mec_miss
plink --bfile prism_all_chr_SNP_QCed --mind 0.05 --make-bed --out all_chr_SNP_QCed_prism_miss
plink --bfile ttsh_all_chr_SNP_QCed --mind 0.05 --make-bed --out all_chr_SNP_QCed_ttsh_miss
plink --bfile seed_all_chr_SNP_QCed --mind 0.05 --make-bed --out all_chr_SNP_QCed_seed_miss

# b. Exclude samples with extreme heterozygosity (+/- 3 SD)
plink --bfile all_chr_SNP_QCed_gusto_miss --het --out gusto_heterozygosity 
plink --bfile all_chr_SNP_QCed_helios_miss --het --out helios_heterozygosity 
plink --bfile all_chr_SNP_QCed_mec_miss --het --out mec_heterozygosity
plink --bfile all_chr_SNP_QCed_prism_miss --het --out prism_heterozygosity
plink --bfile all_chr_SNP_QCed_ttsh_miss --het --out ttsh_heterozygosity
plink --bfile all_chr_SNP_QCed_seed_miss --het --out seed_heterozygosity

# use R script to list indv that failed the het criteria
Rscript hetero_outlier.R

# remove indv that failed het criteria
plink --bfile all_chr_SNP_QCed_gusto_miss --remove fail-het-qc_gusto_indv.txt --make-bed --out all_chr_SNP_QCed_gusto_miss_het

sed 's/"// g' fail-het-qc_helios.txt | awk '{print$1, $2}'> fail-het-qc_helios_indv.txt
plink --bfile all_chr_SNP_QCed_helios_miss --remove fail-het-qc_helios_indv.txt --make-bed --out all_chr_SNP_QCed_helios_miss_het

sed 's/"// g' fail-het-qc_mec.txt | awk '{print$1, $2}'> fail-het-qc_mec_indv.txt
plink --bfile all_chr_SNP_QCed_mec_miss --remove fail-het-qc_mec_indv.txt --make-bed --out all_chr_SNP_QCed_mec_miss_het

sed 's/"// g' fail-het-qc_prism.txt | awk '{print$1, $2}'> fail-het-qc_prism_indv.txt
plink --bfile all_chr_SNP_QCed_prism_miss --remove fail-het-qc_prism_indv.txt --make-bed --out all_chr_SNP_QCed_prism_miss_het

# remove regions of high LD
# convert bfile to vcf to remove regions
plink --bfile all_chr_SNP_QCed_prism_miss_het --recode vcf --out all_chr_SNP_QCed_prism_miss_het
plink --bfile all_chr_SNP_QCed_mec_miss_het --recode vcf --out all_chr_SNP_QCed_mec_miss_het
plink --bfile all_chr_SNP_QCed_helios_miss_het --recode vcf --out all_chr_SNP_QCed_helios_miss_het
plink --bfile all_chr_SNP_QCed_gusto_miss_het --recode vcf --out all_chr_SNP_QCed_gusto_miss_het
plink --bfile all_chr_SNP_QCed_seed_miss --recode vcf --out all_chr_SNP_QCed_seed_miss
plink --bfile all_chr_SNP_QCed_ttsh_miss --recode vcf --out all_chr_SNP_QCed_ttsh_miss

# use vcftools to remove MHC region (high LD)
# vcftools --vcf all_chr_SNP_QCed_prism_miss_het.vcf --exclude-bed mhc_hg38 --recode --out all_chr_SNP_QCed_prism_miss_het_mhc 
# the above gave error

# use plink to remove conserved region (high LD)
plink --bfile all_chr_SNP_QCed_prism_miss_het --exclude range conserved_regions --make-bed --out all_chr_SNP_QCed_prism_miss_het_LD
plink --bfile all_chr_SNP_QCed_mec_miss_het --exclude range conserved_regions --make-bed --out all_chr_SNP_QCed_mec_miss_het_LD
plink --bfile all_chr_SNP_QCed_helios_miss_het --exclude range conserved_regions --make-bed --out all_chr_SNP_QCed_helios_miss_het_LD
plink --bfile all_chr_SNP_QCed_gusto_miss_het --exclude range conserved_regions --make-bed --out all_chr_SNP_QCed_gusto_miss_het_LD
plink --bfile all_chr_SNP_QCed_seed_miss --exclude range conserved_regions --make-bed --out all_chr_SNP_QCed_seed_miss_LD
plink --bfile all_chr_SNP_QCed_ttsh_miss --exclude range conserved_regions --make-bed --out all_chr_SNP_QCed_ttsh_miss_LD

# c. Do additional LD pruning with the r sq 0.2 and then run relatedness checks and identify related individuals 
plink --bfile all_chr_SNP_QCed_prism_miss_het_LD --indep-pairwise 1500 150 0.2 --make-bed --out all_chr_SNP_QCed_prism_miss_het_LD_prune
plink --bfile all_chr_SNP_QCed_mec_miss_het_LD --indep-pairwise 1500 150 0.2 --make-bed --out all_chr_SNP_QCed_mec_miss_het_LD_prune
plink --bfile all_chr_SNP_QCed_helios_miss_het_LD --indep-pairwise 1500 150 0.2 --make-bed --out all_chr_SNP_QCed_helios_miss_het_LD_prune
plink --bfile all_chr_SNP_QCed_gusto_miss_het_LD --indep-pairwise 1500 150 0.2 --make-bed --out all_chr_SNP_QCed_gusto_miss_het_LD_prune
plink --bfile all_chr_SNP_QCed_seed_miss_LD --indep-pairwise 1500 150 0.2 --make-bed --out all_chr_SNP_QCed_seed_miss_het_LD_prune
plink --bfile all_chr_SNP_QCed_ttsh_miss_LD --indep-pairwise 1500 150 0.2 --make-bed --out all_chr_SNP_QCed_ttsh_miss_het_LD_prune

plink --bfile all_chr_SNP_QCed_prism_miss_het_LD --extract all_chr_SNP_QCed_prism_miss_het_LD_prune.prune.in --make-bed --out prism_pruneddata
plink --bfile all_chr_SNP_QCed_mec_miss_het_LD --extract all_chr_SNP_QCed_mec_miss_het_LD_prune.prune.in --make-bed --out mec_pruneddata
plink --bfile all_chr_SNP_QCed_helios_miss_het_LD --extract all_chr_SNP_QCed_helios_miss_het_LD_prune.prune.in --make-bed --out helios_pruneddata
plink --bfile all_chr_SNP_QCed_gusto_miss_het_LD --extract all_chr_SNP_QCed_gusto_miss_het_LD_prune.prune.in --make-bed --out gusto_pruneddata
plink --bfile all_chr_SNP_QCed_seed_miss_LD --extract all_chr_SNP_QCed_seed_miss_het_LD_prune.prune.in --make-bed --out seed_pruneddata
plink --bfile all_chr_SNP_QCed_ttsh_miss_LD --extract all_chr_SNP_QCed_ttsh_miss_het_LD_prune.prune.in --make-bed --out ttsh_pruneddata

# check relatedness
plink --bfile prism_pruneddata --genome --min 0.2 --out pihat_min0.2_prism_2
plink --bfile mec_pruneddata --genome --min 0.2 --out pihat_min0.2_mec_2
plink --bfile helios_pruneddata --genome --min 0.2 --out pihat_min0.2_helios_2
plink --bfile gusto_pruneddata --genome --min 0.2 --out pihat_min0.2_gusto_2
plink --bfile seed_pruneddata --genome --min 0.2 --out pihat_min0.2_seed_2
plink --bfile ttsh_pruneddata --genome --min 0.2 --out pihat_min0.2_ttsh_2

# remove one sample from the highly related pair
plink --bfile gusto_pruneddata --remove gusto_related_indv --make-bed --out gusto_pruneddata_rel
plink --bfile helios_pruneddata --remove helios_related_indv --make-bed --out helios_pruneddata_rel
plink --bfile mec_pruneddata --remove mec_related_indv --make-bed --out mec_pruneddata_rel
plink --bfile prism_pruneddata --remove prism_related_indv --make-bed --out prism_pruneddata_rel
plink --bfile seed_pruneddata --remove seed_rel_indv --make-bed --out seed_pruneddata_rel
plink --bfile ttsh_pruneddata --remove ttsh_rel_indv --make-bed --out ttsh_pruneddata_rel

# pca to generate eigenvalues for each of the cohort ethnic group (QC passed samples)
wd: /home/users/astar/bmsi/pchanmy/scratch/0806-2022
plink --bfile ../2305-2022/gusto_pruneddata_rel --keep gusto_chi --pca header tabs --out gusto_chi
plink --bfile ../2305-2022/gusto_pruneddata_rel --keep gusto_mal --pca header tabs --out gusto_mal
plink --bfile ../2305-2022/gusto_pruneddata_rel --keep gusto_ind --pca header tabs --out gusto_ind
plink --bfile ../2305-2022/helios_pruneddata_rel --keep helios_chi --pca header tabs --out helios_chi
plink --bfile ../2305-2022/helios_pruneddata_rel --keep helios_mal --pca header tabs --out helios_mal
plink --bfile ../2305-2022/helios_pruneddata_rel --keep helios_ind --pca header tabs --out helios_ind
plink --bfile ../2305-2022/mec_pruneddata_rel --keep mec_chi --pca header tabs --out mec_chi
plink --bfile ../2305-2022/mec_pruneddata_rel --keep mec_mal --pca header tabs --out mec_mal
plink --bfile ../2305-2022/mec_pruneddata_rel --keep mec_ind --pca header tabs --out mec_ind
plink --bfile ../2305-2022/prism_pruneddata_rel --keep prism_chi --pca header tabs --out prism_chi
plink --bfile ../2305-2022/prism_pruneddata_rel --keep prism_mal --pca header tabs --out prism_mal
plink --bfile ../2305-2022/prism_pruneddata_rel --keep prism_ind --pca header tabs --out prism_ind
plink --bfile ../2305-2022/seed_pruneddata_rel --keep seed_chi --pca header tabs --out seed_chi
plink --bfile ../2305-2022/seed_pruneddata_rel --keep seed_mal --pca header tabs --out seed_mal
plink --bfile ../2305-2022/seed_pruneddata_rel --keep seed_ind --pca header tabs --out seed_ind
plink --bfile ../2305-2022/ttsh_pruneddata_rel --keep ttsh_chi --pca header tabs --out ttsh_chi
plink --bfile ../2305-2022/ttsh_pruneddata_rel --keep ttsh_mal --pca header tabs --out ttsh_mal
plink --bfile ../2305-2022/ttsh_pruneddata_rel --keep ttsh_ind --pca header tabs --out ttsh_ind

# the PCA plots were visualized manually to identify admixed and misslabeled samples

# extract from original VCF5.3 sample passed QC, by ethnic gp and cohort, excluding non-biallelic SNPs with <95% callrate and HWE P value < 1E8 
for i in {1..22}; do plink --bfile ../2305-2022/chr${i} --keep gusto_mal --snps-only --biallelic-only strict --geno 0.05 --hwe 1e-8 --recode vcf-iid --out gusto_mal_chr${i}_SNP_sample_QCed; done 

for i in {1..22}; do plink --bfile ../2305-2022/chr${i} --keep gusto_ind --snps-only --biallelic-only strict --geno 0.05 --hwe 1e-8 --recode vcf-iid --out gusto_ind_chr${i}_SNP_sample_QCed; done 
