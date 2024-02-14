## This is Rscript-NPM-5mC-01-QC-v1.R
# file names and locations have been removed


source("/home/ivesl/ives/BioTools/R/ENmix-R/nmode.mc.R")
#library(ENmix)

#------------------------------
# Create master CpG file
#------------------------------
cpglist <- matrix(NA, nrow=lineindex, ncol=9)
colnames(cpglist) <- c("CpG","Cohort","N","n","Mean","Median","Nmode","cenRange","SamplePres")

cpglist[,2] <- study

#-----------------------------
# Load 5mC file
#-----------------------------
# the full dataset is too big to load in R
# we must filter the dataset beforehand
# Get samplenames of cohort
samplenames <- as.matrix(read.table(paste0(methwd, study,"/", methfile), header=F, nrows=1))
length(samplenames)

for(l in 1:lineindex){

  line <- l

  meth <- read.table(paste0(methwd, study,"/", methfile), row.names=1, header=F, skip=line, nrows=1)
  #dim(meth)

  cpglist[l,"CpG"] <- rownames(meth)
  cpglist[l,"N"] <- length(meth[!is.na(meth)])
  cpglist[l,"n"] <- length(remove_outliers(meth)[!is.na(remove_outliers(meth))])

  cpglist[l,"Mean"] <- mean(unlist(meth), na.rm=T)
  cpglist[l,"Median"] <- median(unlist(meth), na.rm=T)

  cpglist[l, "Nmode"] <- nmode.mc(as.data.frame(matrix(truncate_outliers(unlist(meth)), nrow=1)), modedist=0.2)[[1]]
  cpglist[l, "cenRange"] <- as.numeric(quantile(meth, 0.975, na.rm=T)) - as.numeric(quantile(meth, 0.025, na.rm=T))
  cpglist[l, "SamplePres"] <- length(meth[!is.na(meth)])/length(meth)

  rm(line, meth)

  }

cpglist <- cpglist[!is.na(cpglist[,"CpG"]),]

setwd(paste0(savewd,study,"/"))
write.table(cpglist, paste0(prefix,"-",study,"-",fileindex,"-cpg_summary.txt"),
        row.names=FALSE, quote=FALSE, sep="\t", col.names=TRUE, na="NA")


sessionInfo()
