# Analysis of Motif Data, Kaanju Ngaachi Indigenous Protected Area
# This script will call clean data from the 01-DataCleaning.R script, and produce
# a series of Figures to accompany the manuscript. Note images created
# Mick Morrison,  10 Oct 2022

# Clear the Global Environment if needed
rm(list = ls())

# Load the necessary packages

library(ggplot2)
library(dplyr)
library(tidyr)
library(grid)
library(gridExtra)
library(FactoMineR)
library(factoextra)
library(DescTools)
library(corrplot)
library(ca)
library(officer)
library(dummy)
library(viridis)
library(tidyverse)
library(kableExtra)
library(viridis)
library(tidyverse)


# load cleaned data from the 01-DataCleaning script -----------------------
data <- readRDS("data/cleandata")
paintings <- readRDS("data/paintings")

#subset the motifs per technique
engr <- data %>% filter(General.Technique == "Engraving")
paint <- data %>% filter(General.Technique == "Painting")

# Figure 5 - Summary of Specific Motifs according to General Tech and Genera Type --------

Figure04 <- ggplot(data = data, 
                   mapping = aes(x = General.Technique, y = ..count.., fill = General.Type)) +
  geom_bar(stat = "count", width = 0.95) +  # Adjust the width here
  labs(y = "Count", x = "General Technique", fill = "General Type") +
  scale_fill_viridis(discrete = TRUE, option = "H") +
  facet_grid(~Site) +
  theme(text = element_text(size = 10)) +
  scale_x_discrete(labels = function(x) sapply(x, function(y) paste(strwrap(y, width = 10), collapse = "\n")))  # Wrap X axis labels


print(Figure04)

# Save to file with specified dimensions and no spaces between bars
ggsave("Figure04.png",
       plot = last_plot(),
       path = "publication/",
       width = 8, height = 5, units = "in")

# Chi Square test for correspondence analysis ------------------------------------

gentype_paint <- table(paint$Site, paint$General.Type)
spectype_paint <- table(paint$Site, paint$Specific.Type)

gentype_engr <- table(engr$Site, engr$General.Type)
spectype_engr <- table(engr$Site, engr$Specific.Type)

prop_gt_paint <- (prop.table(table(paint$Site, paint$General.Type), 1))
prop_st_paint <- (prop.table(table(paint$Site, paint$Specific.Type), 1))

prop_gt_engr <- (prop.table(table(engr$Site, engr$General.Type), 1))
prop_st_engr <- (prop.table(table(engr$Site, engr$Specific.Type), 1))

# chisquare test for independence -
# are row and col variables independent?
# is the general motif type independent of site?
# is the specific motif type independent of site?
# Chisquare test

chi_gt_paint <- chisq.test(gentype_paint)
chi_gt_paint

# General.Type, paintings pearson's CHi-sq test produces p-value of 3.314 e-12  (0.0000000004554 which is well <0.05)
# There is a dependent relationship

chi_st_paint <- chisq.test(spectype_paint)
chi_st_paint

# spec type, paintings pearson's CHi-sq test produces p-value of 1.579 e-07
# There is a dependent relationship 

chi_gt_engr <- chisq.test(gentype_engr)
chi_gt_engr

# general type of engravings prodices p=value -.08935 not significant

chi_st_engr <- chisq.test(spectype_engr)
chi_st_engr
# general type of engravings prodices p=value -0.02459 not significant

# Create a list of chi-squared test results
chi_results <- list(chi_gt_paint, chi_st_paint, chi_gt_engr, chi_st_engr)

# Extract key information from chi_results to create a summary table
summary_table <- data.frame(
  Dataset = character(length(chi_results)),
  Statistic = numeric(length(chi_results)),
  DF = numeric(length(chi_results)),
  P_value = numeric(length(chi_results)),
  Significant = character(length(chi_results))
)

# Update the dataset names
dataset_names <- c("Paintings, General Type", "Paintings, Specific Type", "Engravings, General Type", "Engravings, Specific Type")

for (i in seq_along(chi_results)) {
  if (is.atomic(chi_results[[i]])) {
    summary_table[i, "Dataset"] <- "N/A"
    summary_table[i, "Statistic"] <- chi_results[[i]]
    summary_table[i, "DF"] <- "N/A"
    summary_table[i, "P_value"] <- "N/A"
    summary_table[i, "Significant"] <- "N/A"
  } else {
    summary_table[i, "Dataset"] <- dataset_names[i]
    summary_table[i, "Statistic"] <- chi_results[[i]]$statistic
    summary_table[i, "DF"] <- chi_results[[i]]$parameter
    summary_table[i, "P_value"] <- chi_results[[i]]$p.value
    if (chi_results[[i]]$p.value < 0.05) {
      summary_table[i, "Significant"] <- "Yes"
    } else {
      summary_table[i, "Significant"] <- "No"
    }
  }
}

# Rename the "Statistic" column to "X-squared"
colnames(summary_table)[colnames(summary_table) == "Statistic"] <- "X-squared"

# Print the summary table
print(summary_table)

ChiTable <- summary_table %>%
  kable("html") %>%
  kable_styling(full_width = FALSE)

ChiTable # generates HTML table of Chi data summary


#NOTe this may need to move to tables/app script

# Now to complete  Correspondence Analysis
# Omitting the 'Engravings' General Type class now as not a significant relationship

res.ca.gt.p <- CA(gentype_paint, graph = FALSE) #General  motif type paintings
res.ca.st.p <- CA(spectype_paint, graph = FALSE) #Specific motif type paintings

#res.ca.gt.e <- CA(gentype_engr, graph = FALSE) # General motif type engravings
#res.ca.st.e <- CA(spectype_engr, graph = FALSE) # Specific motif type engravings

#
# # Now extract the dimensions to identify row/column points most associated with principal dims
dimdesc(res.ca.gt.p, axes = c(1, 2), proba = 0.05)
dimdesc(res.ca.st.p, axes = c(1, 2), proba = 0.05)
#dimdesc(res.ca.gt.e, axes = c(1, 2), proba = 0.05)
#dimdesc(res.ca.st.e, axes = c(1, 2), proba = 0.05)

# calculate eigenvalues - the amount of information retained by each axis
# a good CA should aim for good dim reduction indicated when the first few dimensions
# cover most of the variability in the data

eig.val.gen.p <- get_eigenvalue(res.ca.gt.p)
eig.val.st.p <- get_eigenvalue(res.ca.st.p)
#eig.val.st.e <- get_eigenvalue(res.ca.st.e)


# Plotting these results as basic biplots
# and saving to file
# https://www.clres.com/ca/pdepca01a.html

# set max overlaps in biplots to Infinity for this session
options(ggrepel.max.overlaps = Inf)


# Figure 5: Contribution biplot, General Motif Type -  --------------------

fviz_ca_biplot(
  res.ca.gt.p,
  repel = TRUE,
  arrow = c(TRUE, TRUE),
  title = "",
  labelsize = 4,
  ggtheme = theme_gray()
)+
  theme(
    text = element_text(size = 10),
    title = element_text(size = 10),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 10),
    legend.text = element_text(size = 10)
  )
ggsave("Figure05.png",
       plot = last_plot(),
       path = "publication/",
       width = 8,height = 5, units = "in")

# Figure 7: Contribution biplot, Specific Motif Type
fviz_ca_biplot(
  res.ca.st.p,
  repel = TRUE,
  arrow = c(TRUE, TRUE),
  map = "colgreen",
  title = "",
  labelsize = 3,
  ggtheme = theme_gray(),
)+
  theme(
    text = element_text(size = 8),
    title = element_text(size = 10),
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 10),
    legend.text = element_text(size = 10)
  )

ggsave("Figure07.png",
       plot = last_plot(),
       path = "publication/",
       width = 8.27,height = 5, units = "in")



