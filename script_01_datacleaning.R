# Analysis of Motif Data, Kaanju Ngaachi Indigenous Protected Area
# Post-processing script to clean dataset
# Mick Morrison,  22 Feb. 2023

# Clear the Global Environment from previous session
rm(list = ls())
# Set the Wd

setwd(
  "/Volumes/Research/CloudUNE - Kuuku I'yu Northern Kaanju Rock Art Project/gitrepository/KuukuIyuRockArtProject"
)


# Load the necessary packages,
library(data.table)
library(dplyr)
library(tidyverse)
library(officer)
library(readxl)

# Read in and view the original data export from Natasha Marshall's Masters thesis data entry template (2018, Flinders University)
cleandata <- fread("marshall_data_2018_V03.csv")

# Read in the Marshall 2018 methodological tables
category <- fread("category.csv")
contrast <- fread("contrast.csv")
techniques <- fread("techniques.csv")

# Perform some basic editing on the dataset

#Remove NA data
cleandata[is.na(cleandata)] <- 0

#Update language to AU terminology throughout
cleandata[cleandata == "Petroglyph"] <- "Engraving"
cleandata[cleandata == "Pictograph"] <- "Painting"
cleandata[cleandata == "Line Series"] <- "Line series"

#then remove spaces from header names
names(cleandata)
names(cleandata)[names(cleandata) == "Colour primary"] <-
  "Colour.Primary"
names(cleandata)[names(cleandata) == "General Type"] <-
  "General.Type"
names(cleandata)[names(cleandata) == "Contrast state"] <-
  "Contrast.State"
names(cleandata)[names(cleandata) == "Specific_technique"] <-
  "Specific.Technique"
names(cleandata)[names(cleandata) == "Specific Type"] <-
  "Specific.Type"
names(cleandata)[names(cleandata) == "GeneralTechnique"] <-
  "General.Technique"
names(cleandata)[names(cleandata) == "Superimposition/Reiterative practice"] <-
  "Superimposition"
names(cleandata)

#Revise 'General.Technique' column for infilled engravings
# If the value in 'General.Technique' is "Engraving" and the value in 'Colour.Primary' is not "Not applicable",
# update 'General.Technique' to "Infilled engraving". Otherwise, if 'General.Technique' is "Painting",
# keep it as "Painting". For all other cases, keep 'General.Technique' as "Engraving".

cleandata$General.Technique <-
  ifelse(
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

# Ammending Categories for display in appendix
category$Specific[category$General == 'Human' &
                    category$Specific == "-"] <- 'Neutral'
category$Specific[category$General == 'Anthropomorph' &
                    category$Specific == "-"] <- NA
category <- subset(category, !(General == 'Animal' &
                                 Specific == ""))
category$Specific[category$General == 'Animal' &
                    category$Specific == "-"] <- NA
category$Specific[category$General == 'Zoomorph' &
                    category$Specific == "-"] <- NA
category$Specific[category$General == 'Tracks' &
                    category$Specific == "-"] <- NA
techniques$Specific[techniques$General == 'Engravings' &
                      techniques$Specific == "-"] <- NA
techniques$Specific[techniques$General == 'Paintings' &
                      techniques$Specific == "-"] <- NA

# Create a new row in 'techniques' for 'infilled engraving'
new_row <- data.frame(General = "Infilled engraving",
                      Specific = NA,
                      Description = "Removal of rock surface via unknown method, with application of pigment to infill the engraving (after Trezise 1971:128; Cole and Musgrave 2006)")

# Add the new row to the existing data frame
techniques <- rbind(techniques, new_row)

# NOw write cleandata to file to be loaded into other scripts as needed

saveRDS(
  cleandata,
  file = "data/cleandata",
  ascii = FALSE,
  version = NULL,
  compress = FALSE,
  refhook = NULL
)

