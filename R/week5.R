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
 ABclean_tbl <- Bdata_tbl %>%
   mutate(datadate = as.POSIXct(datadate, format = "%b %d %Y, %H:%M:%S")) %>%
   mutate(across(starts_with("q"), as.integer)) %>%
   left_join(Bnotes_tbl, by = c("casenum" = "parnum")) %>%
   filter(is.na(notes)) %>%
   bind_rows(mutate(Aclean_tbl, lab = "A")) %>% #I cannot for the life of my figure out how to do this. I've spent hours trying to figure out how to get the data from lab B labeled as such, but it always duplicates the rows in the dataset. So for now, data from labs A and B are technically still differentiated, with lab A labeled as "A" and lab B containing NA. 
   select(-notes)
 