<p align="center">
  <a href="https://www.npm.sg/">
    <img src="https://www.npm.sg/images/Collaborate/Partners/partnerlogo2.png" alt="SG10K logo" width="200" height="255">
  </a>
</p>

<h3 align="center">National Precision Medicine - SG10K Health </h3>

<p align="center">
  A SG10K Health Study, investigating the associations of various epigenetic clocks on ageing, in a multi-ethnic Singaporean cohort.
  <br>
  <a href="https://pubmed.ncbi.nlm.nih.gov/36658435/"><strong>Explore the Singapore National Precision Medicine Strategy »</strong></a>
  <br>
  <br>
  <a href="placeholder">Report bug</a>
  ·
  <a href="https://www.a-star.edu.sg/gis/our-science/precision-medicine-and-population-genomics/npm">Request data</a>
  ·
  <a href="placeholder">Themes</a>
  ·
  <a href="placeholder">Blog</a>
  <br>
  <br>
  Principal Investigators (SG10K Health Aging Study)
  <br>
  <a href="https://sg.linkedin.com/in/neerjakarnani">Neerja Karnani</a>
  .
  <a href="https://sg.linkedin.com/in/joannengeow">Joanne Ngeow Yuen Yie</a>
  .
  <a href="https://sg.linkedin.com/in/brian-kennedy-69777318">Brian Kennedy</a>
  <br>
  <br>
</p>


## NPM Aging Study Github Code Dump
<br>

Singapore's National Precision Medicine (NPM) strategy seeks to acceleration biomedical research, improve health outcomes, and enhance opportunities for economic value across sectors through a decade long roadmap. The first phase of this strategy is a "proof of concept", through the SG10K health study - primarily generating a genomic reference database of 10,000 healthy Singaporeans, demonstrating the feasibility of large-scale genomic data generation. As part of SG10K health study, this study investigates the Ageing-related clinical phenotypes, alongside genetic, epigenetic, telomere length, and epigenetic clocks, to provide a comprehensive overview of the molecular landscape of Age-related phenotypes in an Asian multiethnic cohort.

This git repository houses the codes used for the analysis of the NPM Aging Study. 

placeholder for link to manuscript.
<br>
<br>


## Table of contents
- [Study Cohorts](#cohorts)
- [DNA Methylation](#5mc)
- [Genomics](#genomics)
- [EpiAge Estimates](#epiage)
- [Telomere Length](#telomeres)
- [Analysis Overview](#overview)
- [Status](#status)
- [Authors](#authors)


<br>

## Study Cohorts

### GUSTO - Growing Up in Singapore Towards healthy Outcomes
A birth cohort comprising of one of the most carefully phenotyped parent-offspring study, enabling examination of the potential roles of fetal, developmental, and epigenetic factors in pathways to disease.

### HELIOS - Health for Life in Singapore
An adult cohort which aims to identify the genetic and environmental factors that underpin development of obesity, diabetes, cardiovascular disease and other complex diseases in Singapore.

### MEC - Singapore Multi-Ethnic Cohort
An adult cohort which aims to discover how lifestyle factors, physiological factors, genetic factors and their interactions impact the development of common health conditions, and to monitor risk factors in the population and gain insight into determinants of health-related behaviours.

### PRISM - SingHealth Duke-NUS Institute of PRecIsion Medicine 
An adult cohort, flagship initiative of the academic medical centre in precision medicine, a discipline where medical treatments and procedures are tailored to individual patients, based on their detailed genetic, molecular and clinical profiles.

### SEED - Singapore Epidemiology of Eye Diseases
An adult cohort which aims to provide novel knowledge in the population eye health to enable dissecting, detecting and preventing the eye diseases in Singapore and Asia, and to promote and improve global eye
health.

### TTSH - Tan Tock Seng Hospital Healthy Control Workgroup
An adult cohort collected between 2015 and 2016 in TTSH Health Screening Programmes to support health related studies at TTSH.


<br>

## DNA Methylation

### Data production

- Illumina EPIC Array pre-processing was performed by [Marie's Loh lab](mailto:Marie_LOH@gis.a-star.edu).
- Single-sample csv files per study were obtained following standard Type 1/Type 2 and Red/Green channel normalizations.

### Sample QC & annotation
#### Samples
- Independent of whole-genome sequencing (WGS) data, Marie's Lab incorporated a PCA-based ethnicity QC to determine population structure and stratify by ethnic groups. As genomic data supersedes epigenetic information, we do not apply Marie's ethnicity QCs and classifications. (They are very similar but not 100% identical. Also for samples that fail genomic QC, it does not make sense to superimpose epigenetic ethnicity classifications onto the subject; because they are not 100% identical.)
- QC parameters employed in this study include:
  - Sample call rates were removed (total CpGs passing QC per sample < 90%)
  - Sex QC 
  - Subject duplication
  - Age (is NA or not)
  - Kinship (cryptic relationships)
  - Cohort resolution
- 10,019 samples passed the initial QCs in Marie Loh's lab.
#### CpGs
- Multimodal CpGs were removed ([nmode.mc](https://github.com/ives2lim/NPM-Aging-Epiclock/blob/main/5mC/5mC-QC-nmode.R) (modedist=0.2) > 1) 
- Non-variable CpGs were removed (IQR < 0.05)
- CpGs failing marker call rates were removed (Det P > 0.01)
- Sex chromosomes were removed.
- CpGs with ethnic-specific (based on SG10K MAF <5%) within single-base extension were removed.
- Cross hybridizing probes and probes recommended to be removed under the Illumina EPIC manifest (v1_0_b5) were removed.
- 747,992 CpGs passed this QC.

<br>

## Genomics

### Data production

- Whole Genome Sequencing of 10,258 healthy Singaporeans was performed.
- Single-sample gVCF files were obtained following GATK4 "germline short variant per-sample calling" reference implementation defined parameters and companion files (GATK resource bundle GRCh38).
- msVCF files were obtained by performing a joint-calling step.

### [Sample QC](https://github.com/ives2lim/NPM-Aging/blob/main/GWAS/qc_eg.sh) & annotation

- 9,770 samples passed the initial genomic coverage requirements per study.
- Variants failing VQSR filter were removed.
- Sex was imputed based on the mean depth ratio of chrX/chr20 and chrY/chr20 of each sample, and samples with abnormal ploidy were excluded.
- Samples with call rate < 95%, contamination rate > 2%, error rate > 1.5%, extreme heterozygosity (> 3SD) were excluded.
- Only non-monomorphic autosomal biallelic SNPs in HWE (P < 10e-8) were included.
- Low complexity regions were excluded after LD pruning (r^2 > 0.2).
- Samples with cryptic relationships were excluded (pi-hat > 0.2).
- Samples showing evidence of admixture between ethnicities through PCA outliers were excluded.
- 8,118 samples passed this WGS QC.

<br>

## EpiAge Estimates

- Subjects passing WGS QCs (having WGS-derived ethnicity classifications) were combined with those passing DNA Methylation QCs. This gave us 6,240 unique subjects.
- Post QC DNA methylation betas were used in the generation of epigenetic ages.
- Age acceleration estimates were adjusted for chronological age.
- Three of the epigenetic age variants were obtained from the [DNA methylation Age Calculator](https://dnamage.genetics.ucla.edu/new) developed by Steve Horvath:
  - Horvath
  - PhenoAge
  - GrimAge
- Cell type proportions were obtained from AdvancedAnalysisBlood from the calculator.
- The output was also normalized by the calculator to make the data comparable between clocks.
- corSampleVSgoldstandard was also adopted under a < 0.8 threshold as recommended by the calculator.
- Zhang (Elastic Net) age estimates were calculated from [scripts available online](https://github.com/qzhang314/DNAm-based-age-predictor).
- Zhang Age acceleration values were obtained by regressing Zhang DNA methylation age on chronological age.

<br>

## [Telomere length](https://github.com/ives2lim/NPM-Aging-Epiclock/blob/main/telomeres/software-eg-script.ipynb)

### Data production

- TelSeq was conducted on SG10K genomic data passing genomic QC, evaluating the frequency of telomeric repeats (TTAGGG) with a default parameter of k=7.

### Sample QC & annotation

- TelSeq estimates were correlated with qPCR measured telomere lengths in a subset of the same study samples as well as other WGS based telomere length estimations (Telomerecat).
- Raw estimates were normalized through rank-based z-scores.
- 8,045 samples passed this QC.

<br>

## Analysis Overview

### Epigenetic age acceleration associations with metabolic health phenotypes and telomere length

- [Linear regression models](https://github.com/ives2lim/NPM-Aging/blob/main/clinical-phenotypes/assoc_eg.R) were employed, adjusting for cohort, ethnicity, sex, and cell type proportions.

<br>

### GWAS

- 5,497 unique adult samples had genetic and age acceleration (any one of the four) passing QC.
- Samples were stratified by cohort and ethnicity prior to analyses.
- Associations were adjusted for sex and genetic PCA PCs.
- For common SNPs,
  - [Linear Wald test analysis](https://github.com/ives2lim/NPM-Aging/blob/main/GWAS/EPACTS-eg.R) was conducted using Efficient and Parallelizable Association Container Toolbox (EPACTS v3.3.0)
  - Cohort-specific association summaries were meta-analyzed using a standard error approach in [METAL](https://github.com/ives2lim/NPM-Aging/blob/main/GWAS/METAL.cmd).
  - SNPs present in 3 or less (out of 5) of the cohorts, or having a VQSLOD < 0 were excluded from the meta-analysis.
- For rare SNPs,
  - autosomal, low frequency (MAF < 0.05), protein altering variants (as annotated by [SnpEff](https://github.com/ives2lim/NPM-Aging/blob/main/GWAS/annotate.sh)) present in at least 4 cohorts were analyzed under gene-based tests using [RAREMETAL](https://github.com/ives2lim/NPM-Aging/blob/main/GWAS/burden.sh) (SKAT method).
  - RVTEST was used to calculate the single-SNP summary statistics and covariance matrices from each cohort required for the meta-analysis.
  - Genes with < 5 aggregated SNPs in the SKAT test were omitted.

<br>

### EWAS

- To mitigate the influence of DNA methylation outliers, we [truncate outlier](https://github.com/ives2lim/NPM-Aging-Epiclock/blob/main/Rcmds/truncate_outliers.R) values beyond 2xIQR to the nearest value. [see [PMID: 34633450](https://pubmed.ncbi.nlm.nih.gov/34633450/)]
- To mitigate batch effects, we conduct [linear regression analyses](https://github.com/ives2lim/NPM-Aging-Epiclock/blob/main/5mC/5mC-LM.R) via study-specific ethnic and sex sub-cohorts (N>50), before combining the results via [meta-analysis under a standard error approach](https://pubmed.ncbi.nlm.nih.gov/31563865/). Per linear regression, we adjust for chip and cell type proportion. This gave us 112,472 EWAS significant CpGs.
- Subsequently, we conduct a leave-one-out (LOO) analysis and remove CpGs which do not pass LOO meta-EWAS significance or have mostly non-concordant effect size directionalities across all [LOOs](https://github.com/ives2lim/NPM-Aging-Epiclock/blob/main/5mC/5mC-mergeLOOs.R).
- This gave us 36,878 Age meta-EWAS significant CpGs.

<br>


### Telomere Length

- Linear regression was used to differentiate telomere length differences between datasets within the SG10K cohort, as well as associations with the various phenotypes, adjusting for cohort (where applicable), age, ethnicity, and sex.


<br>

## Status 

*Manuscript under review.*




<br>

## Authors

- **[Ives Lim](https://www.linkedin.com/in/ives-lim)**
- **[Penny Chan](https://sg.linkedin.com/in/penny-chan-3a60a751)**
- **[Trang Nguyen](https://www.linkedin.com/in/trangnguyen1503)**
- **[Rajkumar Dorajoo](https://sg.linkedin.com/in/rajkumar-dorajoo-22a6a6145)**













