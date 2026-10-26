persons <- read.csv("data/pslm_person_subset.csv")
households <- read.csv("data/pslm_hh_subset.csv")
combined <- merge(persons, households[, c("hhid", "hhweight", "prov_code", "urban_rural")], by="hhid")
earners <- subset(combined, prov_code == 4 & urban_rural == 2 & age >= 15 & age <= 64 & is.finite(earn_annual) & earn_annual > 0 & is.finite(hhweight) & hhweight > 0)
weighted_quantile <- function(x, w, p) {
  o <- order(x); x <- x[o]; w <- w[o]
  x[which(cumsum(w) / sum(w) >= p)[1]]
}
library(ggplot2)
logearn <- log10(earners$earn_annual)
breaks <- seq(4, 7, by = .1)
med <- weighted_quantile(earners$earn_annual, earners$hhweight, .5)
p10 <- weighted_quantile(earners$earn_annual, earners$hhweight, .1)
p90 <- weighted_quantile(earners$earn_annual, earners$hhweight, .9)
cat("N:", nrow(earners), "\nUnweighted median:", median(earners$earn_annual), "\nWeighted P10:", p10, "\nWeighted median:", med, "\nWeighted P90:", p90, "\nP90/P10:", p90/p10, "\nOutside plotted range:", sum(logearn < 4 | logearn > 7), "\n")
p <- ggplot(earners, aes(x=log10(earn_annual), weight=hhweight)) + geom_histogram(aes(y=after_stat(count / sum(count) / 0.1)), breaks=breaks, colour="white") + geom_vline(xintercept=log10(med), linetype="dashed") + geom_vline(xintercept=log10(p90), linetype="dotted") + scale_x_continuous(breaks=seq(4,7,.5), labels=function(x) format(10^x, big.mark=",", scientific=FALSE)) + labs(title="Distribution of positive annual earnings — urban Balochistan", x="Annual earnings (rupees; log-scaled axis)", y="Weighted density per log10 unit") + theme_minimal()
dir.create("figures", showWarnings=FALSE); ggsave("figures/q2_histogram.svg", p, width=10, height=5.8)
