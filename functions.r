library("DBI")
library("RMariaDB")
library("patchwork")
## Functions

### Database connections
with_con <- function(query, params){
    con <- dbConnect(
        drv = RMariaDB::MariaDB(),
        dbname = "sm",
        username = "mpah",
        password = "smjh13oo", 
        host = "localhost", 
        port = 3306,
        mysql = TRUE )
    
    request  <- dbSendQuery(con, query, params = params)
    data <- dbFetch(request)
    dbDisconnect(con)
    colnames(data) <- tolower(colnames(data))
    data
}

get_data <- function(analyte, upper_limit, query){
    params <- list(analyte, analyte, upper_limit, upper_limit)
    data <- with_con( query , params)
}

make_csv_query <- function(analyte, query) {
    csv_query <- gsub("ANALYTE", analyte, query)
    return(csv_query)
}

get_csv_data <- function(analyte, upper_limit, instrument, query){
    csv_query <- make_csv_query(analyte, query)
    #print(csv_query)
    params <- list(analyte, upper_limit, upper_limit, instrument)
    data <- with_con(csv_query, params)
}


get_viewdata <- function(analyte, query){
    params <- list(analyte, analyte)
    data <- with_con(query , params)
}


get_csv_viewdata <- function(analyte, instrument, query){
    csv_query <- make_csv_query(analyte, query)
    params <- list(analyte, instrument)
    data <- with_con(csv_query , params)
}


find_rrf <- function(dataframe1, dataframe2){
    dataframe1_sub <- dataframe1[c("sm1st", "aaac")]
    dataframe2_sub <- dataframe2[c("sm1st", "aaac")]
    combined_data <- rbind(dataframe1_sub, dataframe2_sub)
    ## determine slope and transform data
    model <- lm(sm1st ~ aaac  , data = combined_data)
    slope = model$coefficients[['aaac']]
    rrf = 1/slope
    return(rrf)
}

make_plots <- function(analyte, population_data, linearity_data, rrf, xcor,  ycor, instrument = instrument_name){

    analyte_str <- str_remove(analyte, "[:-[:space:]]")
    figure_pathname <- paste0("../figures/", instrument, "/", analyte_str, ".pdf")
    title_str <- paste0(analyte_str," RRF: ", round(rrf, digits = 2))
    combined_data <- rbind(population_data, linearity_data)
    combined_data$sm1strrf <- combined_data$sm1st * rrf
    population_data$sm1strrf <- population_data$sm1st * rrf

    ## population
    pop_scatter <- ggplot(population_data, aes(x = aaac, y = sm1st, colour = aaac_instrument)) +
        geom_point(alpha = 0.2) +
        geom_smooth(method = lm, se = FALSE) +
        geom_abline(slope = 1, intercept = 0, colour = "black", lty = 2) +
        labs(title = "Population", x ="AAAC", y = "SM1ST") 

    pop_dens <- ggplot(population_data) +
        geom_density(aes(x = aaac, colour = aaac_instrument)) +
        geom_density(aes(x = sm1st)) +
        labs(title = "Population", x ="uM") 
                                     
    ## linearity
    lin_scatter <- ggplot(linearity_data, aes(x = aaac, y = sm1st, colour = aaac_instrument)) +
        geom_point(alpha = 0.2) +
        geom_smooth(method = lm, se = FALSE) +
        geom_abline(slope = 1, intercept = 0, colour = "black", lty = 2) +
        labs(title = "Linearity", x ="AAAC", y = "SM1ST") 

   ## combined rrf adjusted
    rrf_combi_scatter <- ggplot(combined_data, aes(x = aaac, y = sm1strrf, colour = aaac_instrument)) +
        geom_point(alpha = 0.2) +
        geom_smooth(method = lm, se = FALSE) +
        geom_abline(slope = 1, intercept = 0, colour = "black", lty = 2) +
        annotate("text", x = xcor, y = ycor, label = paste0("RRF = ", round(rrf, 3))) +
        labs(title = "RRF combined", x ="AAAC", y = "SM1ST") 

    rrf_pop_dens <- ggplot(population_data) +
        geom_density(aes(x = aaac, colour = aaac_instrument)) +
        geom_density(aes(x = sm1strrf)) +
        labs(title = "RRF population", x ="uM") 
                                     
    p <- (pop_scatter | lin_scatter | rrf_combi_scatter)/ (pop_dens | rrf_pop_dens)
    p_anot <- p + plot_layout(guides = "collect") + plot_annotation(tag_levels = "I",
                                                                    title = title_str) # Uppercase roman numerics
    ggsave(filename = figure_pathname, plot = p_anot)
}

make_ts <- function(analyte, qcdata, moidata, rrf, instrument = instrument_name) {
    analyte_str <- str_remove(analyte, "[:-[:space:]]")
    title_str <- paste0(analyte_str," RRF: ", round(rrf, digits = 2))
    figure_pathname <- paste0("../figures/", instrument, "/", analyte_str, "_ts.pdf")

    qcdata$sm1strrf <- qcdata$sm1st * rrf
    long_qcdata <- qcdata %>% pivot_longer(cols = c(sm1st, aaac, sm1strrf), names_to = "method", values_to = "mean")

    moidata$sm1strrf <- moidata$sm1st * rrf
    moidata$sample <- "moi"
    
    long_moidata <- moidata %>% pivot_longer(cols = c(sm1st, aaac, sm1strrf), names_to = "method", values_to = "mean") 
    combined_data <- rbind(long_qcdata, long_moidata)

    ts <- ggplot(combined_data, aes(x = date, y = mean, colour = method)) +
        geom_line() +
        scale_x_date(date_labels = "%b-%y") +
        facet_grid(sample~., scales = "free_y") +
        ggtitle(title_str) +
        ylab("conc") +
        xlab("date")

    ggsave(filename = figure_pathname, plot = ts)
}


make_cdc <- function(linearity_data, cdc_data, instrument_name, analyte_str){
    cdc_merge <- merge(linearity_data, cdc_data, by= "sample")
    figure_pathname <- paste0("../figures/", instrument_name, "/", analyte_str, "_CDC_regression.pdf")
    mean_model <- lm(sm1st ~ mean  , data = cdc_merge)
    mean_slope = suac_mean_model$coefficients[['mean']]
    mean_rrf = 1/suac_mean_slope
    cdc_merge$sm1st_mean <- cdc_merge$sm1st* mean_rrf

    meanadj_model <- lm(sm1st_mean~ mean  , data = cdc_merge)
    mean_cf <- round(coef(mean_model), 2)
    mean_c <- round(cor(cdc_merge$sm1st, cdc_merge$sm1st)^2, 3)
    ## sign check to avoid having plus followed by minus for negative coefficients
    mean_eq <- paste0("RRF = ", round(suac_mean_rrf,3),"\n",
                      "y = ",
                      ifelse(sign(mean_cf[2])==1, "", " - "), abs(mean_cf[2]), "x",
                      ifelse(sign(mean_cf[1])==1, " + ", " - "), abs(mean_cf[1]),
                      ",  R^2 = ", mean_c)
  ### CDC spike value
  spike_model <- lm(sm1st ~ spike  , data = cdc_merge)
  spike_slope = spike_model$coefficients[['spike']]
  spike_rrf = 1/spike_slope

  spike_cf <- round(coef(suac_spike_model), 2)
  spike_c <- round(cor(suaccdc_merge$sm1st, suaccdc_merge$sm1st)^2, 3)
  ## sign check to avoid having plus followed by minus for negative coefficients
  spike_eq <- paste0("RRF = ", round(spike_rrf,3),"\n",
	       "y = ",
	       ifelse(sign(spike_cf[2])==1, "", " - "), abs(spike_cf[2]), "x",
	       ifelse(sign(spike_cf[1])==1, " + ", " - "), abs(spike_cf[1]),
	       ",  R^2 = ", spike_c)

  cdc_merge$sm1st_spike <- cdc_merge$sm1st* spike_rrf

  pdf(file = figure_pathname)
  par(mfrow=c(2,2))

  plot(x = cdc_merge$mean,  y = cdc_merge$sm1st, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
       main = mean_eq,
       xlab = "CDC mean value",
       ylab = "SM1ST")
  abline(mean_model, model, lty = 1)
  abline(a = 0, b = 1, col = "red", lty = 2)
  legend("topleft",
	 legend = c("CDC linearity materials",
		    "OLS regression",
		    "Identity"),
	 bty = "n",
	 col = c(alpha("blue", 0.4),  "black", "red"),
	 lty = c(NA, 1, 2),
	 pch = c(16, NA, NA))

  plot(x = cdc_merge$spike,  y = cdc_merge$sm1st, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
       main = spike_eq,
       xlab = "CDC spike value",
       ylab = "SM1ST")
  abline(spike_model, model, lty = 1)
  abline(a = 0, b = 1, col = "red", lty = 2)

  plot(x = cdc_merge$mean,  y = cdc_merge$sm1st_mean, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
       main = "Mean RRF applied",
       xlab = "CDC mean value",
       ylab = "SM1ST mean RRF")
  abline(a = 0, b = 1, col = "red", lty = 2)

  plot(x = cdc_merge$spike,  y = cdc_merge$sm1st_spike, pch = 16, cex = 1.3, col = alpha("blue", 0.3),
       main = "Spike RRF applied",
       xlab = "CDC spike value",
       ylab = "SM1ST spike RRF")
  abline(a = 0, b = 1, col = "red", lty = 2)
    par(mfrow=c(1,1))
    dev.off()

    return(mean_rrf)
    
}

make_eq_str <- function(model){
    cf <- round(coef(model), 2)
    r_sq <- round(summary(model)$adj.r.squared, 3)
    eq_str<- paste0("y = ",
                    ifelse(sign(cf[2])==1, "", " - "), abs(cf[2]), "x",
                    ifelse(sign(cf[1])==1, " + ", " - "), abs(cf[1]),
                    ",  R^2 = ", r_sq)
    return(eq_str)
}

make_mcr <- function(analyte, population, linearity,qc, rrf_list = primary_analytes, instrument = instrument_name){
## TODO set plot axis zero and max value in combined data set
    rrf <- rrf_list[[analyte]]
    analyte_str <- str_remove(analyte, "[:-[:space:]]")
    figure_pathname <- paste0("../figures/", instrument, "/", analyte_str, "_regression.pdf")
    title_str <- paste0(analyte_str," RRF: ", round(rrf, digits = 3))


    population$sm1strrf <- population$sm1st * rrf
    population2 <- population[c("sm1st", "sm1strrf", "aaac")]

    linearity$sm1strrf <- linearity$sm1st * rrf
    linearity2 <- linearity[c("sm1st","sm1strrf", "aaac")]

    qc$sm1strrf <- qc$sm1st * rrf
    qc2 <- qc[c("sm1st","sm1strrf", "aaac")]

    combined_data <- rbind(population2, linearity2, qc2)

    model <- lm(sm1st ~ aaac, data = combined_data)
    ## after RRF adjustment
    ## combined data 
    adj_model <- lm(sm1strrf ~ aaac, data = combined_data)
    ## population data only
    adj_pop_model <- lm(sm1strrf ~ aaac, data = population)
        
    ymax <- max(combined_data$sm1strrf)
    xmax <- max(combined_data$aaac)
    
    
    pdf(file = figure_pathname)
    par(mfrow = c(1,2))
    plot(x = linearity$aaac,  y = linearity$sm1st, xlim =c(0, xmax), ylim = c(0, ymax),  pch = 16, cex = 1.3, col = alpha("darkgrey", 0.3),
         main = paste0(analyte_str, "\n", make_eq_str(model)),
         xlab = "AAAC",
         ylab = "SM1ST")
    points(x = population$aaac,  y = population$sm1st, pch = 16, cex = 1.3, col = alpha("cornflowerblue", 0.3))
    points(x = qc$aaac,  y = qc$sm1st, pch = 16, cex = 1.3, col = alpha("darkorchid", 0.3))
    abline(model, lty = 1)
    abline(a = 0, b = 1, col = "red", lty = 2)
    legend("topleft",
           legend = c("Population", "CDC Linearity", "QC material",
                      "OLS combined",
                      "Identity",
                      "OLS population"),
           bty = "n",
           col = c("cornflowerblue", "darkgrey", "darkorchid", "black", "red","cornflowerblue"),
           lty = c(NA, NA,  NA, 1, 2, 2),
           pch = c(16, 16, 16, NA, NA, NA))

    plot(x = linearity$aaac,  y = linearity$sm1strrf, xlim =c(0, xmax), ylim = c(0, ymax), pch = 16, cex = 1.3, col = alpha("darkgrey",0.3),
         main = paste0("RRF = ", round(rrf, 2), "\n", make_eq_str(adj_model)),
         xlab = "AAAC",
         ylab = "RRF adjusted SM1ST",
         sub = make_eq_str(adj_pop_model),
         col.sub = "cornflowerblue")
    points(x = population$aaac,  y = population$sm1strrf, pch = 16, cex = 1.3, col = alpha("cornflowerblue", 0.3))
    points(x = qc$aaac,  y = qc$sm1strrf, pch = 16, cex = 1.3, col = alpha("darkorchid",0.3))
    abline(adj_model, lty = 1)
    abline(adj_pop_model, lty = 2, col = "cornflowerblue")
    abline(a = 0, b = 1, col = "red", lty = 2)
    par(mfrow = c(1,1))
    dev.off()   
}


