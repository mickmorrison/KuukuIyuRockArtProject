# Rock Art Analysis Package -- Script 03: Create Figures & Perform Correspondence Analysis
# Author: Mick Morrison
# Version: 2.2 | Date: 2025-08-11

# Load required packages
pacman::p_load(
  ggplot2, dplyr, tidyr, FactoMineR, factoextra, corrplot, ca,
  officer, viridis, tidyverse, kableExtra, here, fs
)

# Output directories -------------------------------------------------------
OUT_ROOT <- here::here("outputs")
OUT_IMG  <- here::here("outputs", "images")
fs::dir_create(OUT_ROOT)
fs::dir_create(OUT_IMG)

# Helper to save figures consistently to outputs/images -------------------
save_plot <- function(plot, filename, width = 8, height = 5, units = "in", dpi = 300) {
  ggplot2::ggsave(
    filename = here::here("outputs", "images", filename),
    plot = plot,
    width = width, height = height, units = units, dpi = dpi, bg = "white"
  )
}

# Load cleaned and subset data --------------------------------------------
data  <- readRDS(here::here("data", "cleandata"))
paint <- readRDS(here::here("data", "paintings"))
engr  <- readRDS(here::here("data", "engravings"))

# Figure 4: Summary of Specific Motifs ------------------------------------
Figure04 <- ggplot(data, aes(x = General.Technique, y = after_stat(count), fill = General.Type)) +
  geom_bar(stat = "count", width = 0.95) +
  labs(y = "Count", x = "General Technique", fill = "General Type") +
  scale_fill_viridis(discrete = TRUE, option = "H") +
  facet_grid(~ Site) +
  theme(text = element_text(size = 10)) +
  scale_x_discrete(labels = function(x) sapply(x, function(y) paste(strwrap(y, width = 10), collapse = "\n")))
print(Figure04)
save_plot(Figure04, "Figure04_SpecificMotifs_byGenTechnique_GenType.png", width = 8, height = 5)

# Chi-square tests --------------------------------------------------------
gentype_paint <- table(paint$Site, paint$General.Type)
spectype_paint <- table(paint$Site, paint$Specific.Type)
gentype_engr <- table(engr$Site, engr$General.Type)
spectype_engr <- table(engr$Site, engr$Specific.Type)

chi_results <- list(
  chisq.test(gentype_paint, simulate.p.value = TRUE, B = 10000),
  chisq.test(spectype_paint, simulate.p.value = TRUE, B = 10000),
  chisq.test(gentype_engr, simulate.p.value = TRUE, B = 10000),
  chisq.test(spectype_engr, simulate.p.value = TRUE, B = 10000)
)

dataset_names <- c("Paintings, General Type", "Paintings, Specific Type", "Engravings, General Type", "Engravings, Specific Type")

summary_table <- data.frame(
  Dataset   = dataset_names,
  X_squared = sapply(chi_results, function(x) unname(x$statistic)),
  DF        = sapply(chi_results, function(x) unname(x$parameter)),
  P_value   = sapply(chi_results, function(x) x$p.value),
  Significant = sapply(chi_results, function(x) ifelse(x$p.value < 0.05, "Yes", "No"))
)
print(summary_table)

ChiTable <- summary_table %>%
  kable("html") %>%
  kable_styling(full_width = FALSE)

ChiTable

# Save chi-square results table to text file ------------------------------
chi_text_path <- here::here("outputs", "ChiSquare_Results.txt")

capture.output({
  cat("Chi-square Test Results Summary\n")
  cat("================================\n\n")
  print(summary_table, row.names = FALSE)
}, file = chi_text_path)

message("Chi-square results saved to: ", chi_text_path)



# Correspondence Analysis -------------------------------------------------
res.ca.gt.p <- CA(gentype_paint, graph = FALSE)
res.ca.st.p <- CA(spectype_paint, graph = FALSE)

dimdesc(res.ca.gt.p, axes = 1:2, proba = 0.05)
dimdesc(res.ca.st.p, axes = 1:2, proba = 0.05)

eig.val.gen.p <- get_eigenvalue(res.ca.gt.p)
eig.val.st.p  <- get_eigenvalue(res.ca.st.p)

options(ggrepel.max.overlaps = Inf)

# Figure 5 ----------------------------------------------------------------
Figure05 <- fviz_ca_biplot(res.ca.gt.p, repel = TRUE, arrow = c(TRUE, TRUE),
                           title = "", labelsize = 4, ggtheme = theme_gray()) +
  theme(text = element_text(size = 10), title = element_text(size = 10),
        axis.title = element_text(size = 10), axis.text = element_text(size = 10),
        legend.text = element_text(size = 10))
print(Figure05)
save_plot(Figure05, "Figure05_contribution_biplot_general_motif_type.png", width = 8, height = 5)

# Figure 7 ----------------------------------------------------------------
Figure07 <- fviz_ca_biplot(res.ca.st.p, repel = TRUE, arrow = c(TRUE, TRUE),
                           map = "colgreen", title = "", labelsize = 3, ggtheme = theme_gray()) +
  theme(text = element_text(size = 8), title = element_text(size = 10),
        axis.title = element_text(size = 10), axis.text = element_text(size = 10),
        legend.text = element_text(size = 10))
print(Figure07)
save_plot(Figure07, "Figure07_contribution_biplot_specific_motif_type.png", width = 8.27, height = 5)

# End of script
