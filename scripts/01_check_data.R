persons <- read.csv("data/pslm_person_subset.csv")
households <- read.csv("data/pslm_hh_subset.csv")
combined <- merge(persons, households[, c("hhid", "hhweight", "prov_code", "urban_rural")], by="hhid")
earners <- subset(combined, prov_code == 4 & urban_rural == 2 & age >= 15 & age <= 64 & is.finite(earn_annual) & earn_annual > 0 & is.finite(hhweight) & hhweight > 0)
weighted_quantile <- function(x, w, p) {
  o <- order(x); x <- x[o]; w <- w[o]
  x[which(cumsum(w) / sum(w) >= p)[1]]
}
cat("Eligible earners:", nrow(earners), "\n")
cat("Unweighted median:", median(earners$earn_annual), "\n")
cat("Weighted median:", weighted_quantile(earners$earn_annual, earners$hhweight, .5), "\n")
