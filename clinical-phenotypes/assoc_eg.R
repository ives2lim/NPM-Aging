# Multiple Linear Regression Analysis

# ANOVA for categorical variables

# import file and data QC
data <- read.csv("2022-0428_mAge.csv")
data <- subset(data, AgeAccel!= "NA")
data <- subset(data, noMissingPerSample==0) 
data <- subset(data, flagged_samples== "N")
data <- subset(data, corSampleVSgoldstandard > 0.85)
data <- subset(data, genetic_ancestry!= "O")
data <- subset(data, genetic_sex!= "NA")
data$genetic_ancestry <- as.factor(data$genetic_ancestry)

# multivariable model comparisons
lm.b <- lm(AgeAccel ~ genetic_ancestry + genetic_sex + Cohort2, data)
lm.e <- lm(AgeAccel ~ genetic_sex + Cohort2, data)
lm.s <- lm(AgeAccel ~ genetic_ancestry + Cohort2, data)
lm.c <- lm(AgeAccel ~ genetic_ancestry + genetic_sex, data)
anova(lm.b,lm.e)
anova(lm.b,lm.s)
anova(lm.b,lm.c)

lm.ctp <- lm(AgeAccel ~ genetic_ancestry + genetic_sex + Cohort2 + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
anova(lm.b,lm.ctp)

lm.b <- lm(AgeAccel ~ genetic_ancestry + genetic_sex + Cohort + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
lm.e <- lm(AgeAccel ~ genetic_sex + Cohort + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
lm.s <- lm(AgeAccel ~ genetic_ancestry + Cohort + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
lm.c <- lm(AgeAccel ~ genetic_ancestry + genetic_sex + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
anova(lm.b,lm.e)
anova(lm.b,lm.s)
anova(lm.b,lm.c)

# checking for interactions between covariates (sex and ethnicity) 

fm.1 <-  lm(AgeAccel ~ genetic_ancestry*genetic_sex + Cohort + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
fm.2 <-  lm(AgeAccel ~ genetic_ancestry*genetic_sex + genetic_ancestry + genetic_sex + Cohort + CD8T + CD4T + NK + Bcell + Mono + Gran, data)

lm.es <-  lm(AgeAccel ~ genetic_ancestry + genetic_sex + Cohort + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
anova(fm.1,lm.es)
anova(fm.2,lm.es)

# checking for interactions between covariates (ethnicity and cell type proportions) 
fm.3 <- lm(AgeAccel ~ genetic_ancestry + genetic_sex + Cohort + genetic_ancestry*CD8T + genetic_ancestry*CD4T + genetic_ancestry*NK + genetic_ancestry*Bcell + genetic_ancestry*Mono + genetic_ancestry*Gran, data)
anova(fm.3,lm.es)

# checking for interactions between covariates (sex and cell type proportions) 
fm.4 <- lm(AgeAccel ~ genetic_ancestry + genetic_sex + Cohort + genetic_sex*CD8T + genetic_sex*CD4T + genetic_sex*NK + genetic_sex*Bcell + genetic_sex*Mono + genetic_sex*Gran, data)
anova(fm.4,lm.es)

lm.s <-  lm(AgeAccel ~ genetic_sex + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
fm.5 <- lm(AgeAccel ~ genetic_sex*CD8T + genetic_sex*CD4T + genetic_sex*NK + genetic_sex*Bcell + genetic_sex*Mono + genetic_sex*Gran, data)
anova(fm.5,lm.s)

# checking for interactions between covariates (ethnicity, sex and cell type proportions)
lm.es <-  lm(AgeAccel ~ genetic_sex + genetic_ancestry + CD8T + CD4T + NK + Bcell + Mono + Gran, data)
fm.6 <- lm(AgeAccel ~ genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T + genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell + genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, data)
anova(fm.6,lm.es)

# create results file
result <- data.frame("Covariate","N","Beta","SE","L95","U95","P")

# Run LM for clinical variables of interest for adult cohorts

# Subsetting input data to exclude pediatric cohort
adults <- subset(data, Cohort!= "GUSTO")

# HBA1C

lm.1 <- lm(AgeAccel ~ HBA1C + genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T + genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell + genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, adults)
summary(lm.1)
covar <- "HBA1C"
beta <- as.numeric(summary(lm.1)$coefficients["HBA1C","Estimate"])
se <- as.numeric(summary(lm.1)$coefficients["HBA1C","Std. Error"])
p <- as.numeric(summary(lm.1)$coefficients["HBA1C","Pr(>|t|)"])
l95 <- confint(lm.1)[2,"2.5 %"] 
u95 <- confint(lm.1)[2,"97.5 %"]
n <- dim(data)[1]
result[nrow(result) + 1,] = c(covar, n, beta, se, l95, u95, p)

#BMI

lm.1 <- lm(AgeAccel ~ BMI + genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T + genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell + genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, adults)
summary(lm.1)
covar <- "BMI"
beta <- as.numeric(summary(lm.1)$coefficients["BMI","Estimate"])
se <- as.numeric(summary(lm.1)$coefficients["BMI","Std. Error"])
p <- as.numeric(summary(lm.1)$coefficients["BMI","Pr(>|t|)"])
l95 <- confint(lm.1)[2,"2.5 %"] 
u95 <- confint(lm.1)[2,"97.5 %"]
n <- dim(data)[1]
result[nrow(result) + 1,] = c(covar, n, beta, se, l95, u95, p)

# LDL_CAL_MMOL_Ladj

lm.1 <- lm(AgeAccel ~ LDL_CAL_MMOL_Ladj + genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T +
genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell +
genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, adults)
summary(lm.1)
covar <- "LDL_CAL_MMOL_Ladj"
beta <- as.numeric(summary(lm.1)$coefficients["LDL_CAL_MMOL_Ladj","Estimate"])
se <- as.numeric(summary(lm.1)$coefficients["LDL_CAL_MMOL_Ladj","Std. Error"])
p <- as.numeric(summary(lm.1)$coefficients["LDL_CAL_MMOL_Ladj","Pr(>|t|)"])
l95 <- confint(lm.1)[2,"2.5 %"] 
u95 <- confint(lm.1)[2,"97.5 %"]
n <- dim(data)[1]
result[nrow(result) + 1,] = c(covar, n, beta, se, l95, u95, p)

# Total Cholesterol

lm.1 <- lm(AgeAccel ~ TC_MMOL_Ladj + genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T +
genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell +
genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, adults)
summary(lm.1)
covar <- "TC"
beta <- as.numeric(summary(lm.1)$coefficients["TC_MMOL_Ladj","Estimate"])
se <- as.numeric(summary(lm.1)$coefficients["TC_MMOL_Ladj","Std. Error"])
p <- as.numeric(summary(lm.1)$coefficients["TC_MMOL_Ladj","Pr(>|t|)"])
l95 <- confint(lm.1)[2,"2.5 %"] 
u95 <- confint(lm.1)[2,"97.5 %"]
n <- dim(data)[1]
result[nrow(result) + 1,] = c(covar, n, beta, se, l95, u95, p)

# Triglyceride level

lm.1 <- lm(AgeAccel ~ TG_MMOL_L + genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T +
genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell +
genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, adults)
summary(lm.1)
covar <- "TG"
beta <- as.numeric(summary(lm.1)$coefficients["TG_MMOL_L","Estimate"])
se <- as.numeric(summary(lm.1)$coefficients["TG_MMOL_L","Std. Error"])
p <- as.numeric(summary(lm.1)$coefficients["TG_MMOL_L","Pr(>|t|)"])
l95 <- confint(lm.1)[2,"2.5 %"] 
u95 <- confint(lm.1)[2,"97.5 %"]
n <- dim(data)[1]
result[nrow(result) + 1,] = c(covar, n, beta, se, l95, u95, p)

# Type 2 Diabetes status

lm.1 <- lm(AgeAccel ~ T2D + genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T +
genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell +
genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, adults)
summary(lm.1)
covar <- "T2D"
beta <- as.numeric(summary(lm.1)$coefficients["T2D","Estimate"])
se <- as.numeric(summary(lm.1)$coefficients["T2D","Std. Error"])
p <- as.numeric(summary(lm.1)$coefficients["T2D","Pr(>|t|)"])
l95 <- confint(lm.1)[2,"2.5 %"] 
u95 <- confint(lm.1)[2,"97.5 %"]
n <- dim(data)[1]
result[nrow(result) + 1,] = c(covar, n, beta, se, l95, u95, p)

# Telomere length

lm.1 <- lm(AgeAccel ~ telseq + genetic_ancestry*genetic_sex*CD8T + genetic_ancestry*genetic_sex*CD4T +
genetic_ancestry*genetic_sex*NK + genetic_ancestry*genetic_sex*Bcell +
genetic_ancestry*genetic_sex*Mono + genetic_ancestry*genetic_sex*Gran, adults)
summary(lm.1)
covar <- "telseq"
beta <- as.numeric(summary(lm.1)$coefficients["telseq","Estimate"])
se <- as.numeric(summary(lm.1)$coefficients["telseq","Std. Error"])
p <- as.numeric(summary(lm.1)$coefficients["telseq","Pr(>|t|)"])
l95 <- confint(lm.1)[2,"2.5 %"] 
u95 <- confint(lm.1)[2,"97.5 %"]
n <- dim(data)[1]
result[nrow(result) + 1,] = c(covar, n, beta, se, l95, u95, p)
