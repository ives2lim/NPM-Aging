gc.value <- function(pvals) {
    qchisq(median(pvals,na.rm=T),df=1,lower.tail=F)/qchisq(.5,df=1,lower.tail=F);
  }
