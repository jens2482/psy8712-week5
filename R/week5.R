# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)

# Data Import
 Adata_tbl<- read_delim ('../data/Aparticipants.dat', delim = "-", col_names = c("casenum", "parnum", "stimver", "datadate", "qs"))
 Anotes_tbl<- read_csv ('../data/Anotes.csv')
 Bdata_tbl<- read_delim ('../data/Bparticipants.dat', delim = "\t", col_names = c("casenum", "parnum", "stimver", "datadate", paste0("q", 1:10))) #readtsv also option
 Bnotes_tbl<- read_delim ('../data/Bnotes.txt', delim = "\t")
 
 # Data Cleaning
 Aclean_tbl <- Adata_tbl %>%
   separate(qs, into = c(paste0("q", 1:5))) %>%
   mutate(datadate = as.POSIXct(datadate, format = "%b %d %Y, %H:%M:%S")) %>%
   mutate(across(starts_with("q"), as.integer)) %>%
   # mutate(datadate = as.POSIXct(datadate, format = "%b %d %Y, %H:%M:%S")),
   # (across(starts_with("q"), as.integer)) %>% #this line and previous are alternate way to code two mutates in a row (second row has implied mutate by putting column between mutates)
   inner_join(Anotes_tbl, by = "parnum") %>%
   filter(is.na(notes))
 ABclean_tbl <- Bdata_tbl %>%
   mutate(datadate = as.POSIXct(datadate, format = "%b %d %Y, %H:%M:%S")) %>%
   mutate(across(starts_with("q"), as.integer)) %>%
   inner_join(Bnotes_tbl, by = "parnum") %>%
   filter(is.na(notes)) %>%
   bind_rows(Aclean_tbl, .id = "lab") %>%
   select(-notes)
 