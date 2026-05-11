# Upload MS Access query results ----

#excel output from Val_Samp spectral library MS Access query (saved as a csv)
#if copying from path in file explorer, replace back slashes \ with forward slashes /
##do not find and replace \ to / on entire document though, they are needed later
library_query_path <- "C:/workspace/MIR/KS2026/ec/exports/KS_EC_MIR_valsamp.csv"
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
alpha_destination_path <- "C:/workspace/MIR/KS2026/ec/testspectra_alpha"
file.copy(alpha_origin_paths,alpha_destination_path)

#

# KSSL VERTEX calibration spectra ----

#base path of KSSL spectral library on local drive
spectral_library_path <- "C:/workspace/MIR/spectral_library/MIR_Library_OPUS"
#grabbing vertex file names except for those from pedons that have had any horizon scanned on alpha
vertex_calib_target <- subset(library_query, is.na(library_query$Val_Samp_ped),
                        select = c(lab_proj_name, scan_path_name))

#creating full file path names
vertex_c_origin_paths <- paste(spectral_library_path,
                             vertex_calib_target$lab_proj_name,
                             vertex_calib_target$scan_path_name,
                             sep = "/")

#increase timeout in case copying takes long
options(timeout = 300)

#setting folder to copy vertex scans to and copying
vertex_c_destination_path <- "C:/workspace/MIR/rtest/kssl_spectra"
file.copy(vertex_c_origin_paths,vertex_c_destination_path)


# KSSL VERTEX test spectra ----

#grabbing vertex file names from horizons that have been scanned on alpha
vertex_test_target <- subset(library_query, !is.na(library_query$Val_Samp_lay),
                        select = c(lab_proj_name, scan_path_name))

#creating full file path names
vertex_t_origin_paths <- paste(spectral_library_path,
                             vertex_test_target$lab_proj_name,
                             vertex_test_target$scan_path_name,
                             sep = "/")

vertex_t_destination_path <- "C:/workspace/MIR/rtest/kssl_test_spectra"
file.copy(vertex_t_origin_paths,vertex_t_destination_path)

