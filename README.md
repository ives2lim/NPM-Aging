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
</p>


## NPM Aging Study Github Code Dump
This is my first time using github. Please bear with me as I build this page.<br>

Singapore's National Precision Medicine (NPM) strategy seeks to acceleration biomedical research, improve health outcomes, and enhance opportunities for economic value across sectors through a decade long roadmap. The first phase of this strategy is a "proof of concept", through the SG10K health study - primarily generating a genomic reference database of 10,000 healthy Singaporeans, demonstrating the feasibility of large-scale genomic data generation. As part of SG10K health study, this study investigates the Ageing-related clinical phenotypes, alongside genetic, epigenetic, telomere length, and epigenetic clocks, to provide a comprehensive overview of the molecular landscape of Age-related phenotypes in an Asian multiethnic cohort.

This git repository houses the codes used for the analysis of the NPM Aging Study. 

placeholder for link to manuscript.


## Table of contents
- [Analysis Overview](#overview)
- [Study Cohorts](#cohorts)
- [EpiAge Estimates](#epiage)
- [DNA Methylation](#5mc)
- [Genomics](#genomics)
- [Telomere Length](#telomeres)
- [Status](#status)
- [Authors](#authors)

  
## Analysis Overview

placeholder text

## Study Cohorts

placeholder text

## EpiAge Estimates

placeholder text

## DNA Methylation

placeholder text

## Genomics

### Data production

- Whole Genome Sequencing of 10,323 healthy Singaporeans was performed.
- Single-sample gVCF files were obtained following GATK4 "germline short variant per-sample calling" reference implementation defined parameters and companion files (GATK resource bundle GRCh38).
- msVCF files were obtained by performing a joint-calling step.

### Sample QC & annotation

- 9,770 samples passed the initial genomic coverage requirements per study (see manuscript Supplementary Table 11).
- Variants failing VQSR filter were removed.
- Sex was imputed based on the mean depth ratio of chrX/chr20 and chrY/chr20 of each sample, and samples with abnormal ploidy were excluded.
- Samples with call rate < 95%, contamination rate > 2%, error rate > 1.5%, extreme heterozygosity (> 3SD) were excluded.
- Samples with cryptic relationships were excluded (pi-hat > 0.2).
- Samples showing evidence of admixture between ethnicities through PCA outliers were excluded.
- 5,575 samples pass QC and had available phenotypic data.

## Telomere length

placeholder text

## Status 

placeholder text





## Authors

**Ives Lim**

- <https://www.linkedin.com/in/ives-lim>










