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

get_viewdata <- function(analyte, query){
    params <- list(analyte, analyte)
    data <- with_con(query , params)
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

make_plots <- function(analyte, population_data, linearity_data, rrf, xcor,  ycor){

    analyte_str <- str_remove(analyte, "[:-[:space:]]")
    figure_pathname <- paste0("../figures/", analyte_str, ".pdf")
    title_str <- paste0(analyte_str," RRF: ", round(rrf, digits = 3))
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

make_ts <- function(analyte, qcdata, moidata, rrf) {
    analyte_str <- str_remove(analyte, "[:-[:space:]]")
    title_str <- paste0(analyte_str," RRF: ", round(rrf, digits = 3))
    figure_pathname <- paste0("../figures/", analyte_str, "_ts.pdf")

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


make_mcr <- function(analyte, population, linearity,qc, rrf_list = primary_analytes){
## TODO set plot axis zero and max value in combined data set
    rrf <- rrf_list[[analyte]]
    analyte_str <- str_remove(analyte, "[:-[:space:]]")
    figure_pathname <- paste0("../figures/", analyte_str, "_regression.pdf")
    title_str <- paste0(analyte_str," RRF: ", round(rrf, digits = 3))


    population$sm1strrf <- population$sm1st * rrf
    population2 <- population[c("sm1st", "sm1strrf", "aaac")]

    linearity$sm1strrf <- linearity$sm1st * rrf
    linearity2 <- linearity[c("sm1st","sm1strrf", "aaac")]

    qc$sm1strrf <- qc$sm1st * rrf
    qc2 <- qc[c("sm1st","sm1strrf", "aaac")]

    combined_data <- rbind(population2, linearity2, qc2)
    #combined_data$sm1strrf <- combined_data$sm1st * rrf

    model <- lm(sm1st ~ aaac, data = combined_data)
    ## rounded coefficients for better output
    cf <- round(coef(model), 2)
    c <- round(cor(combined_data$aaac, combined_data$sm1st)^2, 3)
    #cor <- cor(aaac, sm1strrf, data = combined_data)^2

    ## sign check to avoid having plus followed by minus for negative coefficients
    eq <- paste0("y = ",
                 ifelse(sign(cf[2])==1, "", " - "), abs(cf[2]), "x",
                 ifelse(sign(cf[1])==1, " + ", " - "), abs(cf[1]),
                 ",  R^2 = ", c)

    ## after RRF adjustment
    adj_model <- lm(sm1strrf ~ aaac, data = combined_data)
    ## rounded coefficients for better output
    adj_cf <- round(coef(adj_model), 2)
    adj_c <- round(cor(combined_data$aaac, combined_data$sm1strrf)^2, 3)
    #cor <- cor(aaac, sm1strrf, data = combined_data)^2

    ## sign check to avoid having plus followed by minus for negative coefficients
    adj_eq <- paste0(analyte," RRF = ", round(rrf,3),"\n",
                 "y = ",
                 ifelse(sign(adj_cf[2])==1, "", " - "), abs(adj_cf[2]), "x",
                 ifelse(sign(adj_cf[1])==1, " + ", " - "), abs(adj_cf[1]),
                 ",  R^2 = ", adj_c)

    xmax <- max(combined_data$sm1st)
    ymax <- max(combined_data$aaac)
    
    
    pdf(file = figure_pathname)
    par(mfrow = c(1,2))
    plot(x = linearity$aaac,  y = linearity$sm1st, xlim =c(0, xmax), ylim = c(0, ymax),  pch = 16, cex = 1.3, col = "black",
         main = eq,
         xlab = "AAAC",
         ylab = "SM1ST")
    points(x = population$aaac,  y = population$sm1st, pch = 16, cex = 1.3, col = alpha("blue", 0.3))
    points(x = qc$aaac,  y = qc$sm1st, pch = 16, cex = 1.3, col = "red")
    abline(model, lty = 1)
    abline(a = 0, b = 1, col = "red", lty = 2)
    legend("topleft",
           legend = c("Population", "CDC Linearity", "QC material",
                      "OLS regression",
                      "Identity"),
           bty = "n",
           col = c(alpha("blue", 0.4), "black", "red", "black", "red"),
           lty = c(NA, NA,  NA, 1, 2),
           pch = c(16, 16, 16, NA, NA))

    plot(x = linearity$aaac,  y = linearity$sm1strrf, xlim =c(0, xmax), ylim = c(0, ymax), pch = 16, cex = 1.3, col = "black",
         main = adj_eq,
         xlab = "AAAC",
         ylab = "RRF adjusted SM1ST")
    points(x = population$aaac,  y = population$sm1strrf, pch = 16, cex = 1.3, col = alpha("blue", 0.3))
    points(x = qc$aaac,  y = qc$sm1strrf, pch = 16, cex = 1.3, col = "red")
    abline(adj_model, lty = 1)
    abline(a = 0, b = 1, col = "red", lty = 2)
    par(mfrow = c(1,1))
    dev.off()   
}


