## This is Rscript-NPM-5mC-08-merge-v3.R
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

  # all subcohorts same direction (option not used)
  pass3 <- na.omit(pass2)
  pass3 <- pass3[pass3$direction == paste0((rep("+", nchar(pass3$direction[1]))), collapse="") |
                pass3$direction == paste0((rep("-", nchar(pass3$direction[1]))), collapse=""), ]
  dim(pass3)

  # allowance of 1 (95% of subcohorts) same direction
  check <- as.matrix(str_split_fixed(pass2$direction,'',nchar(pass3$direction[1])))
  rownames(check) <- pass2$CpG
  head(check)

  check.plus <- rowSums(check == "+")
  check.minus <- rowSums(check == "-")

  check <- rbind(check.plus,check.minus)
  check[,1:4]
  check <- t(check)
  check <- data.frame(check)

  cut.95 <- check[check$check.plus >=23 | check$check.minus >=23,]
  head(cut.95)
  dim(cut.95)

  # allowance of 2 (90%) (option not used)
  cut.90 <- check[check$check.plus >=22 | check$check.minus >=22,]
  head(cut.90)
  dim(cut.90)

  pass4 <- na.omit(pass2)
  pass4 <- pass4[pass4$CpG %in% rownames(cut.95),]
  dim(pass4)

  pass5 <- na.omit(pass2)
  pass5 <- pass5[pass5$CpG %in% rownames(cut.90),]
  dim(pass5)

  write.table(fullresults, paste(prefix,"combined_meta_LOO-allcpgs.results",sep="-"),
                row.names=FALSE, col.names=TRUE, sep="\t")

  write.table(pass3, paste(prefix,"combined_meta_LOO-strict.results",sep="-"),
                row.names=FALSE, col.names=TRUE, sep="\t")

  write.table(pass4, paste(prefix,"combined_meta_LOO-general.results",sep="-"),
                row.names=FALSE, col.names=TRUE, sep="\t")

  write.table(pass5, paste(prefix,"combined_meta_LOO-loose.results",sep="-"),
                row.names=FALSE, col.names=TRUE, sep="\t")
                        


sessionInfo()
