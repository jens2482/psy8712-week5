# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
 Adata_tbl<- read_delim ('../data/Aparticipants.dat', delim = "-", col_names = c("casenum", "parnum", "stimver", "datadate", "qs"))
 Anotes_tbl<- read_csv ('../data/Anotes.csv')
 Bdata_tbl<- read_delim ('../data/Bparticipants.dat', delim = "\t", col_names = c("casenum", "parnum", "stimver", "datadate", paste0("q", 1:10)))
 Bnotes_tbl<- read_delim ('../data/Bnotes.txt', delim = "\t")
 
 # Data Cleaning
 Aclean_tbl <- Adata_tbl %>%
   separate(qs, into = c("q1", "q2", "q3", "q4","q5"), sep = "-") %>%
   mutate(datadate = as.POSIXct(datadate, format = "%b %d %Y, %H:%M:%S")) %>%
   mutate(across(starts_with("q"), as.integer)) %>%
   left_join(Anotes_tbl, by = c("casenum" = "parnum")) %>%
   filter(is.na(notes))