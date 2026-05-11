library(soilDB)
library(leaflet)

#I'm using a local shortcut to sharepoint/teams MIR Data Storage
#export val_samp_lay query from MS Access with KSSL spectral library with ValidationSamplesDb additions and save as a csv
#columns: upedonid, dept, depb, equipment_num, alpha_file_name, lat, long
val_samples <- read.csv("C:/Users/Nathan.Stremcha/OneDrive - USDA/Documents/MIR Data Storage/Spectra/__Validation Spectra - Samples scanned on Alpha and analyzed at KSSL/Val_samp_lay_05112026.csv",
         header = TRUE, na = "")

val_samples$lat <- ifelse(is.na(val_samples$Lat_Site),
                          val_samples$Lat_County_Centroid,
                          val_samples$Lat_Site)
val_samples$long <- ifelse(is.na(val_samples$Long_Site),
                          val_samples$Long_County_Centroid,
                          val_samples$Long_Site)

latmin <- min(val_samples$lat)
latmax <- max(val_samples$lat)
lngmin <- min(val_samples$long)
lngmax <- max(val_samples$long)

poptxt <- paste("<b>upedonid:</b>",val_samples$user_pedon_id,"<br/>",
                "<b>depths:</b>",val_samples$lay_depth_to_top,"to",val_samples$lay_depth_to_bottom,"cm","<br/>",
                "<b>equipment #:</b>",val_samples$alpha_equipment_number,"<br/>",
                "<b>alpha spectral file name:</b>",val_samples$alpha_spectral_file_name)

leaflet() %>%
  addProviderTiles(providers$Esri.WorldTopoMap) %>%
  fitBounds(lngmin,latmin,lngmax,latmax) %>%
  addMarkers(lat = val_samples$lat, lng = val_samples$long, clusterOptions = TRUE,
             label = val_samples$user_pedon_id, popup = poptxt)

