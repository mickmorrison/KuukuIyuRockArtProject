# Rock Art Analysis Package -- Script 01 Data cleaning
# Author: Mick Morrison
# Version: 2 | Date: 2025-08-07

# Load the required packages

library(data.table)
library(dplyr)
library(tidyverse)
library(officer)
library(readxl)

path <- "KuukuIyuRockArtProject/data/"

# Read in and view the data

cleandata <- fread(paste0(path,"Marshall2018v03.csv"))


# Read in the schema

# These lists can be used to classify images of motifs.
category <- fread(paste0(path,"motif_category.csv"))
contrast <- fread(paste0(path,"motif_contrast.csv"))
techniques <- fread(paste0(path,"motif_techniques.csv"))

# Now that data is loaded, perform some basic editing

#Remove NA data
cleandata[is.na(cleandata)] <- 0

#Update language to AU terminology throughout
cleandata[cleandata == "Petroglyph"] <- "Engraving"
cleandata[cleandata == "Pictograph"] <- "Painting"
cleandata[cleandata == "Line Series"] <- "Line series"

#then remove spaces from header names
names(cleandata)
names(cleandata)[names(cleandata) == "Colour primary"] <- "Colour.Primary"
names(cleandata)[names(cleandata) == "General Type"] <- "General.Type"
names(cleandata)[names(cleandata) == "Contrast state"] <- "Contrast.State"
names(cleandata)[names(cleandata) == "Specific_technique"] <-"Specific.Technique"
names(cleandata)[names(cleandata) == "Specific Type"] <- "Specific.Type"
names(cleandata)[names(cleandata) == "GeneralTechnique"] <- "General.Technique"
names(cleandata)[names(cleandata) == "Superimposition/Reiterative practice"] <- "Superimposition"
names(cleandata)

#Revise 'General.Technique' column for infilled engravings
# If the value in 'General.Technique' is "Engraving" and the value in 'Colour.Primary' is not "Not applicable",
# change relevant 'General.Technique' field to "Infilled engraving". Otherwise, if 'General.Technique' is "Painting",
# keep it as "Painting". For all other cases, keep 'General.Technique' as "Engraving".

cleandata$General.Technique <- ifelse(
  cleandata$General.Technique == "Engraving" &
    cleandata$Colour.Primary != "Not applicable",
  "Infilled engraving",
  ifelse(
    cleandata$General.Technique == "Painting",
    "Painting",
    "Engraving"
  )
)

#Update data categories for standardisation

cleandata$Specific.Technique[cleandata$Specific.Technique == "Engraved"] <- "Abraded"
cleandata$Specific.Technique[cleandata$Specific.Technique == "Infilled or solid"] <- "Infilled"
cleandata$Colour.Primary[cleandata$Colour.Primary == "Not applicable"] <- ""
cleandata$Category[cleandata$Category == "Non-diagnostic"] <- "Indeterminate"
cleandata$Specific.Type[cleandata$Specific.Type == "Non-diagnostic"] <- "Indeterminate"
cleandata$General.Type[cleandata$General.Type == "Non-diagnostic"] <- "Indeterminate"

# Amending Categories for display in appendix
category$Specific[category$General == 'Human' & category$Specific == "-"] <- 'Neutral'
category$Specific[category$General == 'Anthropomorph' & category$Specific == "-"] <- NA
category <- subset(category, !(General == 'Animal' & Specific == ""))
category$Specific[category$General == 'Animal' & category$Specific == "-"] <- NA
category$Specific[category$General == 'Zoomorph' & category$Specific == "-"] <- NA
category$Specific[category$General == 'Tracks' & category$Specific == "-"] <- NA
techniques$Specific[techniques$General == 'Engravings' &  techniques$Specific == "-"] <- NA
techniques$Specific[techniques$General == 'Paintings' & techniques$Specific == "-"] <- NA

# Create a new row in 'techniques' for 'infilled engraving'
new_row <- data.frame(General = "Infilled engraving", Specific = NA, Description = "Removal of rock surface via unknown method, with application of pigment to infill the engraving (after Trezise 1971:128; Cole and Musgrave 2006)")

# Add the new row to the existing data frame
techniques <- rbind(techniques, new_row)



## Now, after finishing cleaning, we subset the data

infilledengravings <-subset(cleandata, General.Technique == 'Infilled engraving' & Colour.Primary != 'Not applicable')
paintings <- subset(cleandata, General.Technique == 'Painting')
engravings <- subset(cleandata, General.Technique == 'Engraving')
CH01 <- subset(cleandata, Site == 'CH01')
CH02 <- subset(cleandata, Site == 'CH02')
WT01 <- subset(cleandata, Site == 'WT01')

# Write the cleaned data to a binary file to be quickly loaded into other scripts as needed

saveRDS(
  cleandata,
  file = "data/cleandata",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)

saveRDS(
  infilledengravings,
  file = "data/infilled_engravings",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)
saveRDS(
  engravings,
  file = "data/engravings",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)
saveRDS(
  paintings,
  file = "data/paintings",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)
saveRDS(
  CH01,
  file = "data/CH01",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)
saveRDS(
  CH02,
  file = "data/CH02",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)
saveRDS(
  WT01,
  file = "data/WT01",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)

