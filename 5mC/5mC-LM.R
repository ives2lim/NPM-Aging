## This is Rscript-NPM-5mC-04-AgeLM-v1.R
# file names and locations have been removed
# Rscript run by study/ethnicity/sex


#------------------------------
# Create results file
#------------------------------
results <- matrix(NA, nrow=lineindex, ncol=22)
colnames(results) <- c("CpG","Cohort","Ethnicity","Sex",
                                "N","n","Mean","Median","Max","Min","IQR","SamplePres",
                                "mod1_B","mod1_SE","mod1_L95","mod1_U95","mod1_P",
                                "mod2_B","mod2_SE","mod2_L95","mod2_U95","mod2_P")
results[,2] <- study
results[,3] <- ethnicity
results[,4] <- sex
results[,5] <- nrow(thisdata)


#-----------------------------
# Load 5mC file
#-----------------------------
# read sample ids as first row
IID <- as.vector(read.table(paste0(methwd, study,"/", methfile), nrows=1, header=F, na.strings=NA, sep=" "))
length(unique(IID))
IID[1:5]
IID <- t(IID)
colnames(IID) <- "IID"
dim(IID)
head(IID)


for(l in 1:lineindex){
#l <- 1
  line <- l

  meth <- read.table(paste0(methwd, study,"/", methfile), row.names=1, header=F, skip=line, nrows=1)
  dim(meth)
  cpgname <- rownames(meth)
  meth <- t(meth)
  dim(meth)
  meth <- cbind(IID, meth)
  head(meth)
  meth[,1] <- paste0("X",meth[,1])

  tmp <- merge(meth, thisdata, by.x="IID", by.y="map")
  head(tmp)
  colnames(tmp)[2] <- "meth"

  results[l,"Mean"] <- mean(as.numeric(as.character(tmp[,"meth"])), na.rm=T)
  results[l,"Median"] <- median(as.numeric(as.character(tmp[,"meth"])), na.rm=T)
  results[l,"n"] <- sum(!is.na(tmp[,"meth"]))
  results[l,"SamplePres"] <- as.numeric(results[l,"n"])/as.numeric(results[l,"N"])

  results[l,"Max"] <- max(as.numeric(as.character(tmp[,"meth"])))
  results[l,"Min"] <- min(as.numeric(as.character(tmp[,"meth"])))
  results[l,"IQR"] <- signif(quantile(as.numeric(as.character(tmp[,"meth"])), 0.75) -
                        quantile(as.numeric(as.character(tmp[,"meth"])), 0.25), 3)

  methnew <- tmp$meth
  meth_truncate <- scale(truncate_outliers(as.numeric(as.character(methnew))),center=T,scale=T)
  methnew <- scale(as.numeric(as.character(methnew)),center=T,scale=T)

  tmp <- cbind(tmp, methnew, meth_truncate)
  rm(methnew, meth_truncate)

  tmp$AGE <- scale(tmp$AGE,center=T,scale=T)


  #--------------------------------------
  # Run models here
  #--------------------------------------

  mod1 <- try(lm(methnew ~ AGE + as.factor(sentrix_id) + CD8T + CD4T + NK + Bcell + Mono + Gran,
                data=tmp))

  if(is(mod1, "try-error")==FALSE){
        if(!is.na(mod1$coef["AGE"])){
                smod1 <- summary(mod1)
                results[l, "mod1_B"] <- mod1$coef["AGE"]
                results[l, "mod1_SE"] <- smod1$coef["AGE","Std. Error"]
                results[l, "mod1_L95"] <- confint(mod1)["AGE","2.5 %"]
                results[l, "mod1_U95"] <- confint(mod1)["AGE","97.5 %"]
                results[l, "mod1_P"] <- smod1$coef["AGE","Pr(>|t|)"]
                rm(smod1)
        }
  }
  rm(mod1)


  mod2 <- try(lm(meth_truncate ~ AGE + as.factor(sentrix_id) + CD8T + CD4T + NK + Bcell + Mono + Gran,
                data=tmp))


  if(is(mod2, "try-error")==FALSE){
        if(!is.na(mod2$coef["AGE"])){
                smod2 <- summary(mod2)
                results[l, "mod2_B"] <- mod2$coef["AGE"]
                results[l, "mod2_SE"] <- smod2$coef["AGE","Std. Error"]
                results[l, "mod2_L95"] <- confint(mod2)["AGE","2.5 %"]
                results[l, "mod2_U95"] <- confint(mod2)["AGE","97.5 %"]
                results[l, "mod2_P"] <- smod2$coef["AGE","Pr(>|t|)"]
                rm(smod2)
        }
  }
  rm(mod2)

}

setwd(paste0(savewd,study,"/"))
write.table(results, paste(prefix,study,ethnicity,sex,fileindex,"-results.txt",sep="-"),
        row.names=FALSE, quote=FALSE, sep="\t", col.names=TRUE, na="NA")

sessionInfo()
