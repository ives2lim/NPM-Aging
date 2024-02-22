 
# Start the METAL interactive command line
 ~/generic-metal/metal

# Describe headers of epacts result file
MARKERLABEL MARKER_ID
ALLELELABELS  RefAllele NonRefAllele
PVALUELABEL   PVALUE
EFFECTLABEL   BETA
WEIGHTLABEL     NS

# After setting the labels correctly, read each of the cohort input files
PROCESS prism_chi_all_maf_1pct_2
PROCESS gusto_chi_all_maf_1pct_2
PROCESS helios_chi_all_maf_1pct_2
PROCESS mec_chi_all_maf_1pct_2
PROCESS seed_chi_all_maf_1pct_2
PROCESS ttsh_chi_all_maf_1pct_2

ANALYZE HETEROGENEITY

