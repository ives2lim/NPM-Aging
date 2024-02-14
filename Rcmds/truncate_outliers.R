truncate_outliers <- function(variable, IQRcutoff=2){
        temp <- variable
        temp.median <- quantile(temp , 0.5, na.rm=TRUE)
        temp.IQR <- quantile(temp , 0.75, na.rm=TRUE) - quantile(temp , 0.25, na.rm=TRUE)
        upperoutlier <- temp.median + abs(IQRcutoff)*temp.IQR
        loweroutlier <- temp.median - abs(IQRcutoff)*temp.IQR
        changeupper <- I(temp > upperoutlier)
        changelower <- I(temp < loweroutlier)
        max.nonoutlier <- max(temp[changelower==0&changeupper==0], na.rm=TRUE)
        min.nonoutlier <- min(temp[changelower==0&changeupper==0], na.rm=TRUE)
        temp[changeupper] <- max.nonoutlier
        temp[changelower] <- min.nonoutlier
        rm(temp.median, temp.IQR, upperoutlier, loweroutlier, changeupper, changelower, max.nonoutlier, min.nonoutlier)
        return(temp)
}
