# Upload MS Access query results ----

#excel output from Val_Samp spectral library MS Access query (saved as a csv)
#if copying from path in file explorer, replace back slashes \ with forward slashes /
##do not find and replace \ to / on entire document though, they are needed later
library_query_path <- "C:/workspace/MIR/KS2026/water_15bar/exports/KS_water15bar_MIR_valsamp.csv"
library_query <- read.csv(library_query_path, header = TRUE, sep = ",", na.strings = "")

# Local ALPHA spectra ----

#finding all file names in local shortcut to sharepoint/teams validation spectra onedrive folder
val_samp <- list.files(
  "C:/Users/Nathan.Stremcha/OneDrive - USDA/Documents/MIR Data Storage/Spectra/__Validation Spectra - Samples scanned on Alpha and analyzed at KSSL",
  pattern = "[0-9]$",
  recursive = TRUE, full.names = TRUE)

#grabbing the file names of any of the val_samp alpha scans
alpha_samples <- data.frame(unique(library_query$Val_Samp_lay[!is.na(library_query$Val_Samp_lay)]))
colnames(alpha_samples) <- "file_names"
alpha_target <- paste(alpha_samples$file_names[1:nrow(alpha_samples)],"\\.", sep = "")

#searching for file names in the list of stored validation spectra files
alpha_origin_paths <- val_samp[grep(paste(alpha_target,collapse="|"), val_samp)]

#setting folder to copy alpha scans to and copying
alpha_destination_path <- "C:/workspace/MIR/KS2026/water_15bar/testspectra_alpha"
file.copy(alpha_origin_paths,alpha_destination_path)