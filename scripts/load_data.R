#________________________________________________________
# load relevant libraries
library(tidyverse)
library(lubridate)
#________________________________________________________

#________________________________________________________
# load beia gambia data
# file <- "ABU-01-09-VSARBL-1596_PAC7000_29_9_2012.txt"
# file <- "ABU-02-11-VSARBL-1650_PAC7000_29_9_2012.txt"
# file <- "SUK-02-12ARBL-1596_PAC7000_12_7_2012.txt"
load_beia_gambia <- function(){
  
  data <-
    lapply(list.files("../data/beia-gambia/",
                      pattern = "[0-9].txt",
                      full.names = TRUE),

           function(file)

             # check if file is tab or semicolon delimited
             if (grepl(";", readr::read_lines(file, n_max = 1))) {

               # read file with semicolon delimiter
               readr::read_delim(file,
                                 delim = ";",
                                 skip = 33,
                                 col_types =
                                   cols(x1 = col_character(),
                                        datetime = col_character(),
                                        val = col_double()),
                                 col_names = c("x1", "datetime", "val"),
                                 na = c("", "NA")) %>%
               dplyr::mutate(logger_id = sub(".*-", "", file),
                             logger_id = gsub("_.*", "", logger_id))

             }else{

               # read file with tab delimiter
               readr::read_tsv(file,
                               skip = 33,
                               col_types =
                                 cols(x1 = col_character(),
                                      datetime = col_character(),
                                      val = col_double()),
                               col_names = c("x1", "datetime", "val"),
                               na = c("", "NA")) %>%
                 dplyr::mutate(logger_id = sub(".*-", "", file),
                               logger_id = gsub("_.*", "", logger_id))
               }
           )

  data <- 
    data %>%
      do.call(rbind.data.frame, .) %>%
      dplyr::select(-x1) %>%
      dplyr::mutate(pol = "co")
}
#________________________________________________________