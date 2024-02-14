## This is Rscript-NPM-5mC-08-merge-v2.R
# file names and locations have been removed
# After full meta, LOO, load results and filter based on LOO findings
# filter by ewas sig, then by loo, then by direction

# read in only the main result dataset
passfiles <- metaresfilelist[c(4)]
passnames <- "All"
patterns <- "All_adults"

grepcols <- c("CpG","direction","tau","Isq","H","meta_B","meta_SE","meta_pVal.fixed",
                "meta_pVal.random","meta_pValQ","meta_pVal.final","meta_fdr")

cohorts <- c("HELIOS","MEC","PRISM","SEED","TTSH")

# merge with LOO results
i<-1
  datn <- passnames[i]
  #dataset <- unlist(stringr::str_split(passfiles[i],"//|/"))[11] %>% as.character()
  file <- read.table(passfiles[i], header=T, sep=" ", na.strings=c("","NA","<NA>",NA))
  filt <- file[,grepcols]

  for(j in 1:length(cohorts)){
    loofilepath <- list.files(paste0(loowd,"minus",cohorts[j]), pattern="meta.results", all.files=TRUE, recursive=TRUE, full.names=T)
    loofile <- read.table(loofilepath[grep(patterns[i],loofilepath)], header=T, sep=" ", na.strings=c("","NA","<NA>",NA))
    loofile <- loofile[,c("CpG","meta_fdr")]
    colnames(loofile) <- c("CpG", paste0("minus",cohorts[j],"_meta_fdr"))
    assign(paste(datn,paste0("loo",cohorts[j]), sep="_"), loofile)
    };rm(j,loofilepath,loofile)

  assign(datn, filt)

  listtomerge <- lapply(ls()[grep(datn,ls())], function(x) list(get(x)))
  fullresults <- Reduce(
                        function(x,y, ...) merge(x, y, by="CpG", all=T, ...),
                        listtomerge
                        )
  dim(fullresults)

  fullresults <- fullresults[!is.na(fullresults$meta_fdr),]
  pass1 <- fullresults[fullresults$meta_fdr < 5e-8,]
  dim(pass1)

  pass2 <- na.omit(pass1)
  pass2 <- pass2[pass2$minusHELIOS_meta_fdr < 5e-8 &
                pass2$minusMEC_meta_fdr < 5e-8 &
                pass2$minusPRISM_meta_fdr < 5e-8 &
                pass2$minusSEED_meta_fdr < 5e-8 &
                pass2$minusTTSH_meta_fdr < 5e-8 ,]
  dim(pass2)

  check <- as.matrix(str_split_fixed(pass2$direction,'',nchar(pass2$direction[1])))
  rownames(check) <- pass2$CpG
  head(check)

  check <- cbind(check, matrix(NA, nrow=nrow(check), ncol=7))
  colnames(check) <- c(1:24,"CF","CM","MF","MM","IF","IM","checksum")
                        #       "CFcheck","CMcheck","MFcheck","MMcheck","IFcheck","IMcheck")

  for(k in 1:nrow(check)){
  check[k,"CF"] <- ifelse(nchar(paste0(unique(check[k,c(1,4,7,8,11)]),collapse="")) == 1, 1, 0)
  check[k,"CM"] <- ifelse(nchar(paste0(unique(check[k,c(14,17,20,21,24)]),collapse="")) == 1, 1, 0)
  check[k,"MF"] <- ifelse(nchar(paste0(unique(check[k,c(3,6,10,13)]),collapse="")) == 1, 1, 0)
  check[k,"MM"] <- ifelse(nchar(paste0(unique(check[k,c(16,19,23)]),collapse="")) == 1, 1, 0)
  check[k,"IF"] <- ifelse(nchar(paste0(unique(check[k,c(2,5,9,12)]),collapse="")) == 1, 1, 0)
  check[k,"IM"] <- ifelse(nchar(paste0(unique(check[k,c(15,18,22)]),collapse="")) == 1, 1, 0)
  check[k,"checksum"] <- sum(as.numeric(check[k,25:30]))

  }; rm(k)

  # if any is a 1, pass, so, if checksum>=1, pass

  summary(pass1$CpG %in% rownames(check)[check[,"checksum"] >= 1])
  summary(pass2$CpG %in% rownames(check)[check[,"checksum"] >= 1])

  pass3 <- na.omit(pass2)
  pass3 <- pass3[pass3$CpG %in% rownames(check)[check[,"checksum"] >= 1],]
  dim(pass3)


  write.table(pass2, paste(prefix,"combined_meta_LOO-significant.results",sep="-"),
                row.names=FALSE, col.names=TRUE, sep="\t")




sessionInfo()
