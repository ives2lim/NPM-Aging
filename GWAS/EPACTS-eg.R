
# linear Wald Test analysis at the SNP level was performed using Efficient and Parallelizable Association Container Toolbox (EPACTS v3.3.0).   
# execute genome wide association tests chromosome by chromosome

epacts single --vcf chi_chr1.vcf.gz --ped pheno.ped --chr 22 --pheno AA_Z_EN --cov SEX --cov PC1 --cov PC2 --cov PC3 --cov PC4 --cov PC5 --cov PC6 --ref Homo_sapiens.GRCh38.dna_rm.primary_assembly.fa --test q.lm --out chi_chr1 --run 4

# combine all chromosome wise results for plotting into one plot
for i in {1..22}; do a=`zcat chi_chr${i}.epacts.gz | wc -l`; zcat chi_chr${i}.epacts.gz | tail -n $a > tmp${i}; done
cat tmp* > chi_all
epacts plot --in chi_all --ref Homo_sapiens.GRCh38.dna_rm.primary_assembly.fa --out chi_all

# calculate genomic inflation factor

# read data into R
library(data.table)
data <- fread("all_cohort_chi_5pct_stderrScheme_METAANALYSIS1.TBL")

gc.value <- function(pval) {
    qchisq(median(pval,na.rm=T),df=1,lower.tail=F)/qchisq(.5,df=1,lower.tail=F);
}
gc.value(data$Pvalue)
