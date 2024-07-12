# Analysis of Motif Data, Kaanju Ngaachi Indigenous Protected Area
# This script will call clean data from the 01-DataCleaning.R script, and produce
# a word document with required tables. 

# Mick Morrison,  30 Jan 2024


# Set up environment ------------------------------------------------------

# Clear the Global Environment if needed
rm(list = ls())

# Load the necessary packages, then runs pacman to load necessary packages
library(pivottabler)
library(data.table)
library(openxlsx)
library(basictabler) 
library(flextable) 
library(officer)
library(tidyverse)
library(flextable)

# load cleaned data from the 01-Data Cleaning script
data <- readRDS("data/cleandata")
ch01 <- readRDS("data/CH01")
ch02 <- readRDS("data/CH02")
wt01 <- readRDS("data/WT01")
engr <- readRDS("data/engravings")
paint <- readRDS("data/paintings")
infengr <- readRDS("data/infilled_engravings")
techniques <- readRDS("data/marshall_2018_techniques")
contrast <- readRDS("data/marshall_2018_contrast")
categories <- readRDS("data/marshall_2018_categories")


# Table 1, Motif General Technique and Category, all sites ---------------------
table01 <- PivotTable$new()
table01$addData(data)
table01$addColumnDataGroups("Site", totalCaption = "Total")
table01$defineCalculation(calculationName="Count", summariseExpression="n()", caption="Count", visible=TRUE)
filterOverrides <- PivotFilterOverrides$new(table01, keepOnlyFiltersFor="Count")
table01$defineCalculation(calculationName="TOCTotal", filters=filterOverrides, 
                          summariseExpression="n()", caption="TOC Total", visible=FALSE)
table01$defineCalculation(calculationName="PercentageAllMotifs", type="calculation", 
                              basedOn=c("Count", "TOCTotal"),
                              calculationExpression="values$Count/values$TOCTotal*100", 
                              format="%.1f %%", caption="Percent")
table01$addRowDataGroups("General.Technique")
table01$addRowDataGroups("Category", totalCaption = "Sub-total", dataSortOrder = "custom",
                         customSortOrder = c("Figurative", "Track", "Non-Figurative", "Non-diagnostic"))
table01$theme <- "compact"
table01$renderPivot()
table01$evaluatePivot()

# Table-2 Motif General Technique and Pigment Colour, all sites ----------------------------------------------------------------

#subset the data we need
pigments <- subset(data, General.Technique != 'Engraving')

table02 <- PivotTable$new()
table02$addData(pigments)
table02$addColumnDataGroups("Site", totalCaption = "Total")
table02$defineCalculation(calculationName="Count", summariseExpression="n()", caption="Count", visible=TRUE)
filterOverrides <- PivotFilterOverrides$new(table02, keepOnlyFiltersFor="Count")
table02$defineCalculation(calculationName="TOCTotal", filters=filterOverrides, 
                          summariseExpression="n()", caption="TOC Total", visible=FALSE)
table02$defineCalculation(calculationName="PercentageAllMotifs", type="calculation", 
                          basedOn=c("Count", "TOCTotal"),
                          calculationExpression="values$Count/values$TOCTotal*100", 
                          format="%.1f %%", caption="Percent")
table02$addRowDataGroups("General.Technique")
table02$addRowDataGroups("Colour.Primary", totalCaption = "Sub-total", dataSortOrder = "custom",
                         customSortOrder = c("Brown", "Red","Yellow", "Not applicable"))
table02$renderPivot()
table02$evaluatePivot()


# Table 3 Motif General and Specific Technique, all sites ----------------------------------------------------

table03 <- PivotTable$new()
table03$addData(data)
table03$addColumnDataGroups("Site", totalCaption = "Total")
table03$defineCalculation(calculationName="Count", summariseExpression="n()", caption="Count", visible=TRUE)
filterOverrides <- PivotFilterOverrides$new(table03, keepOnlyFiltersFor="Count")
table03$defineCalculation(calculationName="TOCTotal", filters=filterOverrides,
                          summariseExpression="n()", caption="TOC Total", visible=FALSE)
table03$defineCalculation(calculationName="PercentageAllMotifs", type="calculation",
                          basedOn=c("Count", "TOCTotal"),
                          calculationExpression="values$Count/values$TOCTotal*100",
                          format="%.1f %%", caption="Percent")
table03$addRowDataGroups("General.Technique")
table03$addRowDataGroups("Specific.Technique", totalCaption = "Sub-total", dataSortOrder = "custom", customSortOrder = c("Abraded", "Pecked","Infilled", "Outline", "Indeterminate"))
table03$renderPivot()
table03$evaluatePivot()


# Table 4 Motif Contrast state, all sites  ----------------------------------------
table04 <- PivotTable$new()
table04$addData(engr)
table04$addColumnDataGroups("Site", totalCaption = "Total")
table04$defineCalculation(calculationName="Count", summariseExpression="n()", caption="Count", visible=TRUE)
filterOverrides <- PivotFilterOverrides$new(table04, keepOnlyFiltersFor="Count")
table04$defineCalculation(calculationName="TOCTotal", filters=filterOverrides,
                          summariseExpression="n()", caption="TOC Total", visible=FALSE)
table04$defineCalculation(calculationName="PercentageAllMotifs", type="calculation",
                          basedOn=c("Count", "TOCTotal"),
                          calculationExpression="values$Count/values$TOCTotal*100",
                          format="%.1f %%", caption="Percent")
table04$addRowDataGroups("Contrast.State", totalCaption = "Sub-total")
table04$renderPivot()
table04$evaluatePivot()


# Table 5 Motif General Technique and General Type, all sites ------------------------
table05 <- PivotTable$new()
table05$addData(data)
table05$addColumnDataGroups("Site", totalCaption = "Total")
table05$defineCalculation(calculationName="Count", summariseExpression="n()", caption="Count", visible=TRUE)
filterOverrides <- PivotFilterOverrides$new(table05, keepOnlyFiltersFor="Count")
table05$defineCalculation(calculationName="TOCTotal", filters=filterOverrides, 
                          summariseExpression="n()", caption="TOC Total", visible=FALSE)
table05$defineCalculation(calculationName="PercentageAllMotifs", type="calculation", 
                          basedOn=c("Count", "TOCTotal"),
                          calculationExpression="values$Count/values$TOCTotal*100", 
                          format="%.1f %%", caption="Percent")
table05$addRowDataGroups("General.Technique")
table05$addRowDataGroups("General.Type", totalCaption = "Sub-total")
table05$renderPivot()



# Appendix ----------------------------------------------------------------
# Appendix 1 - techniques
names(techniques)
appx01 <- flextable(techniques) %>%
  width(j = "General", width = 1, unit = "in") %>%
  width(j = "Specific", width = 1, unit = "in") %>%
  width(j = "Description", width = 4, unit = "in") %>%
  align(align = "center", part = "header") %>%
  merge_v(j = "General") %>%
  valign(valign="top", part = "body")%>%
  fontsize(size =10, part = "all") %>%
  font(part="all", fontname = "Arial")
print(appx01)

# Appendix 2 - contrast states
names(contrast)
appx02 <- flextable(contrast) %>%
  width(j = "Class", width = 1.5, unit = "in") %>%
  width(j = "Definition", width = 5, unit = "in") %>%
  align(align = "center", part = "header") %>%
  align(align = "left", part ="body") %>%
  fontsize(size = 10, part ="all") %>%
  font(part="all", fontname = "Arial")
print(appx02)

# Appendix 3 - categories
appx03 <- flextable(categories) %>%
  width(j = "General", width = 1, unit = "in") %>%
  width(j = "Specific", width = 1.5, unit = "in") %>%
  width(j = "Description", width = 2.5, unit = "in") %>%
  align(align = "center", part = "header") %>%
  merge_v(j = "General") %>%
  valign(valign = "top", part = "body", i = 1, j = "General") %>%
  fontsize(size = 10, part = "all") %>%
  font(part="all", fontname = "Arial") %>%
  theme_box()
print(appx03)
      
# Appendix 4 --------------------------------------------------------------

appx04 <- PivotTable$new()
appx04$addData(data)
appx04$addColumnDataGroups("Site", totalCaption = "Total")
appx04$defineCalculation(calculationName="Count", summariseExpression="n()", caption="Count", visible=TRUE)
filterOverrides <- PivotFilterOverrides$new(appx04, keepOnlyFiltersFor="Count")
appx04$defineCalculation(calculationName="TOCTotal", filters=filterOverrides, 
                          summariseExpression="n()", caption="TOC Total", visible=FALSE)
appx04$defineCalculation(calculationName="PercentageAllMotifs", type="calculation", 
                          basedOn=c("Count", "TOCTotal"),
                          calculationExpression="values$Count/values$TOCTotal*100", 
                          format="%.1f %%", caption="Percent")
appx04$addRowDataGroups("General.Technique")
appx04$addRowDataGroups("Specific.Type", totalCaption = "Sub-total")
appx04$renderPivot()



# Appendix 4 General and Specific Motif Classes, 
# appx04 <- PivotTable$new()
# appx04$addData(data)
# appx04$defineCalculation(calculationName="Count", summariseExpression="n()", caption="Count", visible=TRUE)
# filterOverrides <- PivotFilterOverrides$new(appx04, keepOnlyFiltersFor="Count")
# appx04$defineCalculation(calculationName="TOCTotal", filters=filterOverrides, 
#                          summariseExpression="n()", caption="TOC Total", visible=FALSE)
# appx04$defineCalculation(calculationName="PercentageAllMotifs", type="calculation", 
#                          basedOn=c("Count", "TOCTotal"),
#                          calculationExpression="values$Count/values$TOCTotal*100", 
#                          format="%.1f %%", caption="Percent")
# appx04$addRowDataGroups("Site")
# appx04$addRowDataGroups("General.Technique")
# appx04$addRowDataGroups("General.Type")
# appx04$addRowDataGroups("Specific.Type", totalCaption = "Sub-total")
# appx04$renderPivot()
# class(appx04)

# Output ------------------------------------------------------------------

# Output all tables to a single word document

#first create basic tables
t01BT <- table01$asBasicTable()
t02BT <- table02$asBasicTable()
t03BT <- table03$asBasicTable()
t04BT <- table04$asBasicTable()
t05BT <- table05$asBasicTable()
appx04BT <- appx04$asBasicTable() 

#then convert to flextable for quick export to word
t01FT <- t01BT$asFlexTable()
t02FT <- t02BT$asFlexTable()
t03FT <- t03BT$asFlexTable()
t04FT <- t04BT$asFlexTable()
t05FT <- t05BT$asFlexTable()
appx04FT <- appx04BT$asFlexTable()

# This section adds the 1px black border to all items
add_border <- function(table) {
  return(border_outer(table, border = fp_border(style = "solid", width = 1, color = "black")))
}

# Now convert these to flextable objects
t01FT <- add_border(t01BT$asFlexTable())
t02FT <- add_border(t02BT$asFlexTable())
t03FT <- add_border(t03BT$asFlexTable())
t04FT <- add_border(t04BT$asFlexTable())
t05FT <- add_border(t05BT$asFlexTable())
appx04FT <- add_border(appx04BT$asFlexTable())

# now to output these Flextables to a single word doc 'tables.doc'

tablesdocx <- read_docx() # Creates a blank word doc

#Table 01
tablesdocx <- body_add_flextable(tablesdocx, value = t01FT)
tablesdocx <- body_add_par(tablesdocx, "Table 1: Motif General Technique and Category, all sites")
tablesdocx <- body_add_break(tablesdocx)

#Table 02
tablesdocx <- body_add_flextable(tablesdocx, value = t02FT)
tablesdocx <- body_add_par(tablesdocx, "Table 2: Motif General Technique and Pigment Colour, all sites")
tablesdocx <- body_add_break(tablesdocx)

#Table 03
tablesdocx <- body_add_flextable(tablesdocx, value = t03FT)
tablesdocx <- body_add_par(tablesdocx, "Table 3: Motif General and Specific Technique, all sites")
tablesdocx <- body_add_break(tablesdocx)

#Table 04
tablesdocx <- body_add_flextable(tablesdocx, value = t04FT)
tablesdocx <- body_add_par(tablesdocx, "Table 4: Motif Contrast state, all sites (1 = heavily weathered, 5 = minimally weathered)")
tablesdocx <- body_add_break(tablesdocx)

#Table 05
tablesdocx <- body_add_flextable(tablesdocx, value = t05FT)
tablesdocx <- body_add_par(tablesdocx, "Table 5: Motif General Technique and General Type, all sites")
tablesdocx <- body_add_break(tablesdocx)

# appendix01
tablesdocx <- body_add_par(tablesdocx, "Appendix 1: Techniques")
tablesdocx <- body_add_flextable(tablesdocx, value = appx01)
tablesdocx <- body_add_break(tablesdocx)

# appendix02
tablesdocx <- body_add_par(tablesdocx, "Appendix 2: Contrast State")
tablesdocx <- body_add_flextable(tablesdocx, value = appx02)
tablesdocx <- body_add_break(tablesdocx)

# appendix03
tablesdocx <- body_add_par(tablesdocx, "Appendix 3: Categories")
tablesdocx <- body_add_flextable(tablesdocx, value = appx03)
tablesdocx <- body_add_break(tablesdocx)

# appendix 04
tablesdocx <- body_add_flextable(tablesdocx, value = appx04FT)
tablesdocx <- body_add_par(tablesdocx, "Appendix 4: General Technique and Specific Motif Classes, all sites")
tablesdocx <- body_add_break(tablesdocx)

print(tablesdocx, target = "/Volumes/Research/CloudUNE - Kuuku I'yu Northern Kaanju Rock Art Project/publication/AAAReview/FinalArtwork/Tables.docx")

# End of script
