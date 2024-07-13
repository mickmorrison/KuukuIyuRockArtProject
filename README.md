## Rock Art Analysis Package (RAAP), v01:  Data, Schema and Scripts for the Formal Analysis of Rock Art Data

> **Author**: Dr Mick Morrison, University of New England.
>
> **Last major update**: 14 July 2024

This repository contains data, schema and scripts for analysing rock art motifs identified as part of the Kuuku I'yu Rock Art Project, and from the Kaanju Ngaachi Indigenous Protected Area, Cape York Peninsula, Australia.

The goal of this repository is to enable others to reproduce the tables and figures used in our research, or to use our data, schema or scripts in other work. Please acknowledge this. You can cite the RAAP as:

> Morrison, M., Marshall, N., & D. Claudie (2024) Rock Art Analysis Package (RAAP): Data, Schema and Scripts for the Formal Analysis of Rock Art Data [Data set]. In *Australian Archaeology* (pre-release) ####. Zenodo. <https://doi.org/10.5281/zenodo.12730323>

The RAAP was developed through and supports the research presented in the following paper. If you use these data or schema, please cite and acknowledge this work:

> Morrison, M., Claudie, D., Marshall, N., and D. McNaughton (Under Review) Storyscapes: Rock art, personhood and social interaction in the northern Cape York Peninsula, Australia. *Australian Archaeology*.
>
> *Abstract*
>
> This study analyses rock art assemblages and late Holocene social interaction in Cape York Peninsula’s (CYP) northern highlands, north-eastern Australia, from the vantage point of Kuuku I’yu (Northern Kaanju) Pama (Aboriginal People from CYP) homelands. Previous research has documented complex social networks across northeastern Australia and southern Papua New Guinea, highlighting long-distance alliances, exchanges, and kinship relations that connected island, coastal, and inland communities. However, local and interregional interactions remain under-researched, especially between coastal and inland communities on CYP’s mainland. Drawing on analysis of ethnographic materials, it is shown that Pama personhood, social identity, and social interaction in the past were underpinned by totemic, moiety, and kinship relations, as well as Stories—shared local and regional cosmogonies and cosmologies. Using digital methods centred on photogrammetry, here we analysed nearly 300 rock art motifs. Results reveal place-based variations in motifs indicating historical social distinctions. The study identifies potential links between rock art motifs, personhood, totemic beings, and major Stories. We draw on the concept of Storyscape as a culturally informed theoretical framework for understanding histories of social interaction and varied regional and local cultural influences on rock art. This reflects Indigenous ontologies of embodied relatedness, which potentially underpin recent and potentially late Holocene social interaction and material exchange spheres on the CYP mainland.Ethics and Indigenous Cultural and Intellectual Property

This research was approved through the University of New England Human Research Ethics Committee, Approval number HE20_219, as a component of the Australian Research Council-funded *Sugarbag and Shellfish: Indigenous Foodways in Colonial Cape York Peninsula* (LP170100050) project (2019-2024). It formerly had ethics approval at Flinders University.

This repository does not include images of rock art or Indigenous heritage places as these remain the cultural property of Kuuku I'yu (Northern Kaanju) Custodians. Approved images are available in the published paper or via the [Chuulangun Aboriginal Corporation](https://www.kaanjungaachi.com.au/ChuulangunAboriginalCorporation.htm "Chuulangun Aboriginal Corporation").

## Requirements

-   You will need some experience with R and be comfortable modifying the scripts provided to suit your system and needs.

-   R (version 4.0.0 or later)

-   R packages: `data.table`, `dplyr`, `tidyverse`, `officer`, `readxl`, `pivottabler`, `openxlsx`, `basictabler`, `flextable`, `ggplot2`, `FactoMineR`, `factoextra`, `DescTools`, `corrplot`, `ca`, `dummy`, `viridis`, `kableExtra` These are listed in the relevant scripts and are not relevant unless you are trying to run a script.

## Scripts 

### `script01_datacleaning.R`

This script cleans the original dataset exported from Marshall's Masters thesis (2018, Flinders University). It performs various data transformations and saves the cleaned data for further analysis as an RDS binary file. If you want the cleaned data as an excel spreadsheet, this script is, hopefully, easily understood, used and modified — but you'll need to add a few lines of code to do so at the end of the script as the intention here is reproducibility via the use of R.

Data outputs (RDS files) are in \`/data\`

### `script02_tables.R`

This script loads the cleaned data produced in script01, and produces various tables and appendices other files within this repo. These are previewed then output into a Word document. If the script is unmodified from source, it will generate the published tables and appendices of the published paper.

### `script03_figures.R`

This script produces a series of figures to accompany the manuscript. It includes statistical analyses such as chi-square tests and correspondence analysis, with results saved as image files to `/outputs`

## Data

> `motifdata2018v03`

The data provided is a modified version produced by co-authors Marshall and Morrison during the desktop analysis of digital models and images, as described in the published study. These are uncleaned so are not consistent with published data. Run the scripts to reproduce that dataset.

## Classification Schema

Marshall (2018) produced the following tables of values used to classify identified motifs. These can be used to create a simple database if required. See the published paper or Marshall (2018) for further details.

## Usage 

1.  Clone the RAAP repo to your computer. Cloning or forking from github is recommended, and for the simplest method use Github Desktop. You can also download the latest release as a Zip.
2.  Create a new project within RStudio, and save to the RAAP directory.
3.  Open all scripts, and modify the path and working directory in the first few lines to suit your system. You'll need the full path. Save
4.  Open Script 1, and run (select all and `run`). Verify that it has worked correctly by checking that your `/data` directory now includes a series of binary files. No warnings or error messages should appear.
5.  Open Script 2, run and if it runs without error, check the `outputs` directory. It will now include `tables.docx` generated by the script.
6.  Open Script 3, run and if it runs without error, check the `outputs` directory. It will now include three figures generated by the script.

This is just a basic overview, the scripts can be modified to use other data.
