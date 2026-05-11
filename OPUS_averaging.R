library(tidyr)
library(dplyr)

in_path <- "C:/Users/Nathan.Stremcha/OneDrive - USDA/Documents/MIR Data Storage/Data Analysis/KS - Salina - Data Analysis/2025_PlantMaterialsCenter/PMC_opusout.csv"

opus_out <- read.csv(in_path)

#opus_out <- read.csv("C:/Users/Nathan.Stremcha/OneDrive - USDA/Documents/Salina, KS/FY2026/TSS Soil Health Sampling in Marshall County, KS/Db_MIRopusout.csv")

opus_out$real.Component <- ifelse(substr(opus_out$Component,1,4)=="sqrt",
                                  substr(opus_out$Component,5,nchar(opus_out$Component)),
                                  opus_out$Component)
opus_out$real.Prediction <- ifelse(substr(opus_out$Component,1,4)=="sqrt",
                                   opus_out$Prediction^2,opus_out$Prediction)
opus_out$Property.Model <- paste(opus_out$real.Component," (",
                                gsub("\\..*","",opus_out$Method),")",
                                sep = "")

opus_snip <- data.frame(opus_out$File.Name, opus_out$Property.Model, opus_out$real.Prediction)
colnames(opus_snip) <- c("File_Name","Property.Model","Prediction")

snip_wide <- pivot_wider(opus_snip, names_from = Property.Model, values_from = Prediction)

snip_wide$File_Name <- gsub("\\..*","",snip_wide$File_Name)

avg_replicates <- snip_wide %>% group_by(File_Name) %>%
  summarize(across(names(snip_wide)[2:length(names(snip_wide))], mean, .names = "mean_{.col}"))


out_path <- gsub("\\.csv","_averaged.csv",in_path)

write.csv(avg_replicates,out_path)
