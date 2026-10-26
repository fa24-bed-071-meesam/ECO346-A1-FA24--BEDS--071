persons <- read.csv("data/pslm_person_subset.csv")
households <- read.csv("data/pslm_hh_subset.csv")
combined <- merge(persons, households[, c("hhid", "hhweight", "prov_code", "urban_rural")], by="hhid")
earners <- subset(combined, prov_code == 4 & urban_rural == 2 & age >= 15 & age <= 64 & is.finite(earn_annual) & earn_annual > 0 & is.finite(hhweight) & hhweight > 0)
weighted_quantile <- function(x, w, p) {
  o <- order(x); x <- x[o]; w <- w[o]
  x[which(cumsum(w) / sum(w) >= p)[1]]
}
library(ggplot2)
breaks <- seq(15, 65, by=5)
labels <- paste(seq(15,60,5), seq(19,64,5), sep="-")
earners$age_band <- cut(earners$age, breaks=breaks, right=FALSE, labels=labels)
summary <- do.call(rbind, lapply(levels(earners$age_band), function(b) { d <- subset(earners, age_band==b); data.frame(age_band=b, midpoint=as.numeric(sub("-.*","",b))+2, n_earners=nrow(d), weighted_mean_earnings=weighted.mean(d$earn_annual,d$hhweight)) }))
summary$thin <- summary$n_earners < 30
summary$weighted_mean_earnings <- round(summary$weighted_mean_earnings)
write.csv(summary,"figures/q3_age_band_table.csv",row.names=FALSE)
top <- summary[which.max(summary$weighted_mean_earnings),]
set.seed(346)
p <- ggplot(earners,aes(x=age,y=earn_annual)) + geom_point(position=position_jitter(width=.35,height=0),alpha=.22,size=1.3) + geom_line(data=summary,aes(x=midpoint,y=weighted_mean_earnings,group=1),inherit.aes=FALSE) + geom_point(data=summary,aes(x=midpoint,y=weighted_mean_earnings,shape=thin),inherit.aes=FALSE,size=3.5) + geom_label(data=top,aes(x=midpoint,y=weighted_mean_earnings*1.35,label=paste("Highest mean:",age_band)),inherit.aes=FALSE,size=3) + scale_x_continuous(breaks=seq(15,65,5)) + scale_y_log10(breaks=c(10000,100000,1000000,10000000),labels=function(x) format(x,big.mark=",",scientific=FALSE)) + coord_cartesian(ylim=c(10000,10000000)) + scale_shape_manual(values=c(16,1),labels=c("n ≥ 30","n < 30")) + labs(title="Annual earnings by age band — urban Balochistan",x="Age (years)",y="Annual earnings (rupees, log scale)",shape="Age-band sample size",caption="PSLM 2019–20; weighted means use hhweight; hollow markers indicate n < 30") + theme_minimal()
dir.create("figures",showWarnings=FALSE); ggsave("figures/q3_age_profile.svg",p,width=10,height=6)
print(summary,row.names=FALSE)
