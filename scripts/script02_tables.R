# Rock Art Analysis Package -- Script 02 Create Tables and Appendices
# Author: Mick Morrison
# Version: 2.1 | Date: 2025-08-11

# Load packages
pacman::p_load(
  pivottabler, data.table, openxlsx, basictabler,
  flextable, officer, tidyverse, here, fs
)

# Optional: global flextable defaults for full-width tables
flextable::set_flextable_defaults(table_layout = "autofit", table_width = 1)

# Create output directory if needed
fs::dir_create(here::here("outputs"))

# Load cleaned and subset data from script01
data <- readRDS(here::here("data", "cleandata"))
ch01 <- readRDS(here::here("data", "CH01"))
ch02 <- readRDS(here::here("data", "CH02"))
wt01 <- readRDS(here::here("data", "WT01"))
engr <- readRDS(here::here("data", "engravings"))
paint <- readRDS(here::here("data", "paintings"))
infengr <- readRDS(here::here("data", "infilled_engravings"))

# Load classification schemes
techniques <- fread(here::here("data", "techniques.csv"))
contrast   <- fread(here::here("data", "contrast.csv"))
categories <- fread(here::here("data", "category.csv"))

# Helper functions --------------------------------------------------------
add_border <- function(ft) {
  flextable::border_outer(
    ft,
    border = officer::fp_border(style = "solid", width = 1, color = "black")
  )
}

enlarge_ft <- function(ft) {
  ft |>
    flextable::autofit() |>
    flextable::set_table_properties(layout = "autofit", width = 1) |>
    flextable::fontsize(size = 10, part = "all")
}

# -------------------------- Table 1 --------------------------------------
table01 <- PivotTable$new()
table01$addData(data)
table01$addColumnDataGroups("Site", totalCaption = "Total")
table01$defineCalculation(calculationName = "Count", summariseExpression = "n()", caption = "Count", visible = TRUE)
filterOverrides <- PivotFilterOverrides$new(table01, keepOnlyFiltersFor = "Count")
table01$defineCalculation(calculationName = "TOCTotal", filters = filterOverrides, summariseExpression = "n()", visible = FALSE)
table01$defineCalculation(calculationName = "PercentageAllMotifs", type = "calculation",
                          basedOn = c("Count", "TOCTotal"),
                          calculationExpression = "values$Count/values$TOCTotal*100",
                          format = "%.1f %%", caption = "Percent")
table01$addRowDataGroups("General.Technique")
table01$addRowDataGroups("Category", totalCaption = "Sub-total",
                         dataSortOrder = "custom",
                         customSortOrder = c("Figurative", "Track", "Non-Figurative", "Non-diagnostic"))
table01$theme <- "compact"
table01$renderPivot()
table01$evaluatePivot()

# -------------------------- Table 2 --------------------------------------
pigments <- subset(data, General.Technique != "Engraving")
table02 <- PivotTable$new()
table02$addData(pigments)
table02$addColumnDataGroups("Site", totalCaption = "Total")
table02$defineCalculation(calculationName = "Count", summariseExpression = "n()", caption = "Count", visible = TRUE)
filterOverrides <- PivotFilterOverrides$new(table02, keepOnlyFiltersFor = "Count")
table02$defineCalculation(calculationName = "TOCTotal", filters = filterOverrides, summariseExpression = "n()", visible = FALSE)
table02$defineCalculation(calculationName = "PercentageAllMotifs", type = "calculation",
                          basedOn = c("Count", "TOCTotal"),
                          calculationExpression = "values$Count/values$TOCTotal*100",
                          format = "%.1f %%", caption = "Percent")
table02$addRowDataGroups("General.Technique")
table02$addRowDataGroups("Colour.Primary", totalCaption = "Sub-total",
                         dataSortOrder = "custom",
                         customSortOrder = c("Brown", "Red", "Yellow", "Not applicable"))
table02$renderPivot()
table02$evaluatePivot()

# -------------------------- Table 3 --------------------------------------
table03 <- PivotTable$new()
table03$addData(data)
table03$addColumnDataGroups("Site", totalCaption = "Total")
table03$defineCalculation(calculationName = "Count", summariseExpression = "n()", caption = "Count", visible = TRUE)
filterOverrides <- PivotFilterOverrides$new(table03, keepOnlyFiltersFor = "Count")
table03$defineCalculation(calculationName = "TOCTotal", filters = filterOverrides, summariseExpression = "n()", visible = FALSE)
table03$defineCalculation(calculationName = "PercentageAllMotifs", type = "calculation",
                          basedOn = c("Count", "TOCTotal"),
                          calculationExpression = "values$Count/values$TOCTotal*100",
                          format = "%.1f %%", caption = "Percent")
table03$addRowDataGroups("General.Technique")
table03$addRowDataGroups("Specific.Technique", totalCaption = "Sub-total",
                         dataSortOrder = "custom",
                         customSortOrder = c("Abraded", "Pecked", "Infilled", "Outline", "Indeterminate"))
table03$renderPivot()
table03$evaluatePivot()

# -------------------------- Table 4 --------------------------------------
table04 <- PivotTable$new()
table04$addData(engr)
table04$addColumnDataGroups("Site", totalCaption = "Total")
table04$defineCalculation(calculationName = "Count", summariseExpression = "n()", caption = "Count", visible = TRUE)
filterOverrides <- PivotFilterOverrides$new(table04, keepOnlyFiltersFor = "Count")
table04$defineCalculation(calculationName = "TOCTotal", filters = filterOverrides, summariseExpression = "n()", visible = FALSE)
table04$defineCalculation(calculationName = "PercentageAllMotifs", type = "calculation",
                          basedOn = c("Count", "TOCTotal"),
                          calculationExpression = "values$Count/values$TOCTotal*100",
                          format = "%.1f %%", caption = "Percent")
table04$addRowDataGroups("Contrast.State", totalCaption = "Sub-total")
table04$renderPivot()
table04$evaluatePivot()

# -------------------------- Table 5 --------------------------------------
table05 <- PivotTable$new()
table05$addData(data)
table05$addColumnDataGroups("Site", totalCaption = "Total")
table05$defineCalculation(calculationName = "Count", summariseExpression = "n()", caption = "Count", visible = TRUE)
filterOverrides <- PivotFilterOverrides$new(table05, keepOnlyFiltersFor = "Count")
table05$defineCalculation(calculationName = "TOCTotal", filters = filterOverrides, summariseExpression = "n()", visible = FALSE)
table05$defineCalculation(calculationName = "PercentageAllMotifs", type = "calculation",
                          basedOn = c("Count", "TOCTotal"),
                          calculationExpression = "values$Count/values$TOCTotal*100",
                          format = "%.1f %%", caption = "Percent")
table05$addRowDataGroups("General.Technique")
table05$addRowDataGroups("General.Type", totalCaption = "Sub-total")
table05$renderPivot()

# -------------------------- Appendices -----------------------------------
appx01 <- flextable(techniques) |>
  width(j = "General", width = 1, unit = "in") |>
  width(j = "Specific", width = 1, unit = "in") |>
  width(j = "Description", width = 4, unit = "in") |>
  align(align = "center", part = "header") |>
  merge_v(j = "General") |>
  valign(valign = "top", part = "body") |>
  fontsize(size = 10, part = "all") |>
  font(part = "all", fontname = "Arial")

appx02 <- flextable(contrast) |>
  width(j = "Class", width = 1.5, unit = "in") |>
  width(j = "Definition", width = 5, unit = "in") |>
  align(align = "center", part = "header") |>
  align(align = "left", part = "body") |>
  fontsize(size = 10, part = "all") |>
  font(part = "all", fontname = "Arial")

appx03 <- flextable(categories) |>
  width(j = "General", width = 1, unit = "in") |>
  width(j = "Specific", width = 1.5, unit = "in") |>
  width(j = "Description", width = 2.5, unit = "in") |>
  align(align = "center", part = "header") |>
  merge_v(j = "General") |>
  valign(valign = "top", part = "body", i = 1, j = "General") |>
  fontsize(size = 10, part = "all") |>
  font(part = "all", fontname = "Arial") |>
  theme_box()

appx04 <- PivotTable$new()
appx04$addData(data)
appx04$addColumnDataGroups("Site", totalCaption = "Total")
appx04$defineCalculation(calculationName = "Count", summariseExpression = "n()", caption = "Count", visible = TRUE)
filterOverrides <- PivotFilterOverrides$new(appx04, keepOnlyFiltersFor = "Count")
appx04$defineCalculation(calculationName = "TOCTotal", filters = filterOverrides, summariseExpression = "n()", visible = FALSE)
appx04$defineCalculation(calculationName = "PercentageAllMotifs", type = "calculation",
                         basedOn = c("Count", "TOCTotal"),
                         calculationExpression = "values$Count/values$TOCTotal*100",
                         format = "%.1f %%", caption = "Percent")
appx04$addRowDataGroups("General.Technique")
appx04$addRowDataGroups("Specific.Type", totalCaption = "Sub-total")
appx04$renderPivot()

# -------------------------- Convert to flextables ------------------------
t01FT <- enlarge_ft(add_border(table01$asBasicTable()$asFlexTable()))
t02FT <- enlarge_ft(add_border(table02$asBasicTable()$asFlexTable()))
t03FT <- enlarge_ft(add_border(table03$asBasicTable()$asFlexTable()))
t04FT <- enlarge_ft(add_border(table04$asBasicTable()$asFlexTable()))
t05FT <- enlarge_ft(add_border(table05$asBasicTable()$asFlexTable()))
appx04FT <- enlarge_ft(add_border(appx04$asBasicTable()$asFlexTable()))

appx01 <- enlarge_ft(appx01)
appx02 <- enlarge_ft(appx02)
appx03 <- enlarge_ft(appx03)

# -------------------------- Build Word document --------------------------
tablesdocx <- read_docx()

tablesdocx <- body_add_flextable(tablesdocx, t01FT)
tablesdocx <- body_add_par(tablesdocx, "Table 1: Motif General Technique and Category, all sites")
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_flextable(tablesdocx, t02FT)
tablesdocx <- body_add_par(tablesdocx, "Table 2: Motif General Technique and Pigment Colour, all sites")
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_flextable(tablesdocx, t03FT)
tablesdocx <- body_add_par(tablesdocx, "Table 3: Motif General and Specific Technique, all sites")
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_flextable(tablesdocx, t04FT)
tablesdocx <- body_add_par(tablesdocx, "Table 4: Motif Contrast state, all sites (1 = heavily weathered, 5 = minimally weathered)")
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_flextable(tablesdocx, t05FT)
tablesdocx <- body_add_par(tablesdocx, "Table 5: Motif General Technique and General Type, all sites")
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_par(tablesdocx, "Appendix 1: Techniques")
tablesdocx <- body_add_flextable(tablesdocx, appx01)
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_par(tablesdocx, "Appendix 2: Contrast State")
tablesdocx <- body_add_flextable(tablesdocx, appx02)
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_par(tablesdocx, "Appendix 3: Categories")
tablesdocx <- body_add_flextable(tablesdocx, appx03)
tablesdocx <- body_add_break(tablesdocx)

tablesdocx <- body_add_flextable(tablesdocx, appx04FT)
tablesdocx <- body_add_par(tablesdocx, "Appendix 4: General Technique and Specific Motif Classes, all sites")
tablesdocx <- body_add_break(tablesdocx)

# Output final docx
print(tablesdocx, target = "outputs/tables.docx")

# End of script
