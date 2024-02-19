## This is Rscript-NPM-5mC-06-meta-v1.R
# file names and locations have been removed


# meta analysis libraries
library(meta)
library(dplyr)

datatometa <- all
fileoutname <- "All_adults"

dtmfileout <- paste(prefix, fileoutname, "meta.results", sep="-")

meta_df <- plyr::adply(
        .data = datatometa,
        .margins = 1,
        .fun = function(rowOne_df){

                est <- rowOne_df[grep("B",colnames(rowOne_df))] %>% as.numeric

                direction <- paste(
                        ifelse(
                                is.na(est), ".",
                                ifelse(est > 0, "+", "-")
                        ), collapse = "")

                se <- rowOne_df[grep("SE",colnames(rowOne_df))] %>% as.numeric
                cohort <- gsub("_SE","",grep("SE",colnames(rowOne_df), value=T))
                rowOne_reform_df <- data.frame(
                        cohort = cohort,
                        est = est,
                        se = se,
                        stringsAsFactors = FALSE
                )

                # add try
                f <- try(metagen(
                        TE = est,
                        seTE = se,
                        data = rowOne_reform_df,
                        prediction = TRUE
                        )
                )

                if(is(f, "try-error")==FALSE){

                tibble::tibble(
                        CpG = rowOne_df$CpG,
                        meta_B = f$TE.fixed,
                        meta_SE = f$seTE.fixed,
                        meta_pVal.fixed = f$pval.fixed,
                        meta_pVal.random = f$pval.random,
                        meta_pValQ = f$pval.Q,
                        direction = direction,
                        tau = f$tau,
                        Isq = f$I^2,
                        H = f$H
                        )
                }
        }, .progress = "time",
        .parallel = TRUE,
        .id = NULL
)


## create final pVal
meta_df$meta_pVal.final <- ifelse(
        meta_df$meta_pValQ > 0.05, meta_df$meta_pVal.fixed, meta_df$meta_pVal.random
)

## fdr
meta_df$meta_fdr <- p.adjust(meta_df$meta_pVal.final, method = "fdr")

## order meta_df
meta_final_df <- meta_df[,c(grep("_",colnames(meta_df),invert=T),
                        grep("_",colnames(meta_df),invert=F))
                        ]

meta_final_ordered_df <- meta_final_df[order(meta_final_df$meta_pVal.final),]



# write out results
write.table(
        meta_final_ordered_df %>% as.data.frame(),
        dtmfileout, row.names=FALSE)



sessionInfo()
