
# Analysis of Motif Data, Kaanju Ngaachi Indigenous Protected Area

## Overview

This repository contains scripts and data used for the analysis of rock art motifs in the Kaanju Ngaachi Indigenous Protected Area, Cape York Peninsula, Australia. 

The analysis supports the research presented in the paper:

**Title**: Storyscapes: Rock art, personhood and social interaction in the northern Cape York Peninsula, Australia.  
**Authors**: Michael Morrison, David Claudie, Natasha Marshall, Darlene McNaughton  
**Date**:  2024  (Under Review)
**Keywords**: Indigenous archaeology, social interaction, rock Art, personhood, Story, Australia, Cape York Peninsula, Storyscape


## Requirements and acknowledgements.

- R (version 4.0.0 or later)
- R packages: `data.table`, `dplyr`, `tidyverse`, `officer`, `readxl`, `pivottabler`, `openxlsx`, `basictabler`, `flextable`, `ggplot2`, `FactoMineR`, `factoextra`, `DescTools`, `corrplot`, `ca`, `dummy`, `viridis`, `kableExtra`


## Abstract

This study analyses rock art assemblages and late Holocene social interaction in Cape York Peninsula’s (CYP) northern highlands, north-eastern Australia, from the vantage point of Kuuku I’yu (Northern Kaanju) Pama (Aboriginal People from CYP) homelands. Previous research has documented complex social networks across northeastern Australia and southern Papua New Guinea, highlighting long-distance alliances, exchanges, and kinship relations that connected island, coastal, and inland communities. However, local and interregional interactions remain under-researched, especially between coastal and inland communities on CYP’s mainland. Drawing on analysis of ethnographic materials, it is shown that Pama personhood, social identity, and social interaction in the past were underpinned by totemic, moiety, and kinship relations, as well as Stories—shared local and regional cosmogonies and cosmologies. Using digital methods centred on photogrammetry, here we analysed nearly 300 rock art motifs. Results reveal place-based variations in motifs indicating historical social distinctions. The study identifies potential links between rock art motifs, personhood, totemic beings, and major Stories. We draw on the concept of Storyscape as a culturally informed theoretical framework for understanding histories of social interaction and varied regional and local cultural influences on rock art. This reflects Indigenous ontologies of embodied relatedness, which potentially underpin recent and potentially late Holocene social interaction and material exchange spheres on the CYP mainland.

## Scripts and Data

### 01-DataCleaning.R
This script cleans the original dataset exported from Natasha Marshall's Masters thesis data entry template (2018). It performs various data transformations and saves the cleaned data for further analysis.

### 02-DataAnalysis.R
This script loads the cleaned data, produces various tables, and outputs them into a Word document with necessary appendices and formatting. Code cleaned to remove experimental or deprecated elements.

### 03-Figures.R
This script produces a series of figures to accompany the manuscript. It includes statistical analyses such as chi-square tests and correspondence analysis, with results saved as image files.

## Data Sources

- Kuuku Iyu Rock Art Catalogue 2018 (V03-03)
- Marshall, Natasha. 2018. Methods Excel Sheets (Flinders University)


## Setup

1. Clone this repository:
   \`\`\`sh
   git clone https://github.com/yourusername/your-repo-name.git
   \`\`\`
2. Set up the working environment by installing the required R packages:
   \`\`\`r
   install.packages(c("data.table", "dplyr", "tidyverse", "officer", "readxl", "pivottabler", "openxlsx", "basictabler", "flextable", "ggplot2", "FactoMineR", "factoextra", "DescTools", "corrplot", "ca", "dummy", "viridis", "kableExtra"))
   \`\`\`

## Usage

1. Place the required data files in the `data/` directory.
2. Run the scripts in the `R/` directory in the following order:
   - `01-DataCleaning.R`
   - `02-DataAnalysis.R`
   - `03-Figures.R`

## Ethical Considerations

This research was approved through the University of New England Human Research Ethics Committee, Approval number HE20_219.

## Declaration of Interests

None.

## License

Include the appropriate open-source license information here.

## Acknowledgements

This work acknowledges the contributions of Kuuku I’yu custodians and the Chuulangun Aboriginal Corporation.

For any questions or further information, please contact the corresponding author:
Michael Morrison  
Department of Archaeology, Classics and History  
University of New England, Armidale 2350 AUSTRALIA  
[mick.morrison@une.edu.au](mailto:mick.morrison@une.edu.au)  
[ORCID: https://orcid.org/0000-0003-3971-7829/](https://orcid.org/0000-0003-3971-7829/)
