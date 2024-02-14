gc.correct <-function(pvals, gcv=gc.value(pvals)) {
    pchisq(qchisq(pvals,df=1,lower.tail=F)/gcv,df=1,lower.tail=F);
  }
