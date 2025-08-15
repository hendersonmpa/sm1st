source("./functions.r")
source("./queries.r")
## CDC adjustment
## SUAC
suacpop <- get_data("SUAC", 10, query_population)
suaclin <- get_data("SUAC", 10, query_linearity)
suacqc <- get_viewdata("SUAC", query_qc)
suacmoi <- get_viewdata("SUAC", query_moi)

suaccdc <- read.csv(file = "../data/SUAC_CDClin.csv")
suaccdc_comp <- merge(suaclin, suaccdc, by= "sample")

### CDC mean value
suac_mean_model <- lm(sm1st ~ mean  , data = suaccdc_comp)
suac_mean_slope = suac_mean_model$coefficients[['mean']]
suac_mean_rrf = 1/suac_mean_slope
suaccdc_comp$sm1st_mean <- suaccdc_comp$sm1st* suac_mean_rrf

suac_meanadj_model <- lm(sm1st_mean~ mean  , data = suaccdc_comp)
suac_mean_cf <- round(coef(suac_mean_model), 2)
suac_mean_c <- round(cor(suaccdc_comp$sm1st, suaccdc_comp$sm1st)^2, 3)
## sign check to avoid having plus followed by minus for negative coefficients
mean_eq <- paste0("RRF = ", round(suac_mean_rrf,3),"\n",
             "y = ",
             ifelse(sign(suac_mean_cf[2])==1, "", " - "), abs(suac_mean_cf[2]), "x",
             ifelse(sign(suac_mean_cf[1])==1, " + ", " - "), abs(suac_mean_cf[1]),
             ",  R^2 = ", suac_mean_c)

### Comparison after RRF adjustment

### CDC spike value
suac_spike_model <- lm(sm1st ~ spike  , data = suaccdc_comp)
suac_spike_slope = suac_spike_model$coefficients[['spike']]
suac_spike_rrf = 1/suac_spike_slope

suac_spike_cf <- round(coef(suac_spike_model), 2)
suac_spike_c <- round(cor(suaccdc_comp$sm1st, suaccdc_comp$sm1st)^2, 3)
## sign check to avoid having plus followed by minus for negative coefficients
spike_eq <- paste0("RRF = ", round(suac_spike_rrf,3),"\n",
             "y = ",
             ifelse(sign(suac_spike_cf[2])==1, "", " - "), abs(suac_spike_cf[2]), "x",
             ifelse(sign(suac_spike_cf[1])==1, " + ", " - "), abs(suac_spike_cf[1]),
             ",  R^2 = ", suac_spike_c)

suaccdc_comp$sm1st_spike <- suaccdc_comp$sm1st* suac_spike_rrf

pdf(file = "../figures/SUAC_CDC_regression.pdf")
par(mfrow=c(2,2))

plot(x = suaccdc_comp$mean,  y = suaccdc_comp$sm1st, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
     main = mean_eq,
     xlab = "CDC mean value",
     ylab = "SM1ST")
abline(suac_mean_model, model, lty = 1)
abline(a = 0, b = 1, col = "red", lty = 2)
legend("topleft",
       legend = c("CDC linearity materials",
                  "OLS regression",
                  "Identity"),
       bty = "n",
       col = c(alpha("blue", 0.4),  "black", "red"),
       lty = c(NA, 1, 2),
       pch = c(16, NA, NA))

plot(x = suaccdc_comp$spike,  y = suaccdc_comp$sm1st, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
     main = spike_eq,
     xlab = "CDC spike value",
     ylab = "SM1ST")
abline(suac_spike_model, model, lty = 1)
abline(a = 0, b = 1, col = "red", lty = 2)

plot(x = suaccdc_comp$mean,  y = suaccdc_comp$sm1st_mean, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
     main = "Mean RRF applied",
     xlab = "CDC mean value",
     ylab = "SM1ST mean RRF")
abline(a = 0, b = 1, col = "red", lty = 2)

plot(x = suaccdc_comp$spike,  y = suaccdc_comp$sm1st_spike, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
     main = "Spike RRF applied",
     xlab = "CDC spike value",
     ylab = "SM1ST spike RRF")
abline(a = 0, b = 1, col = "red", lty = 2)

dev.off()   

par(mfrow=c(1,1))

make_plots("SUAC_CDC", suacpop, suaclin, suac_mean_rrf, 4, 25 )
make_ts("SUAC_CDC", suacqc, suacmoi suac_mean_rrf)
make_mcr("SUAC", suacpop, suaclin, suacqc, c("SUAC" = suac_mean_rrf))
