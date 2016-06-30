whole_process <- function()
{
  source("~/git/Kevin_R_scripts/install_r_prereqs.r")
  source("~/git/Kevin_R_scripts/preprocessing_tool.r")
  source("~/git/Kevin_R_scripts/heatmap_dendrogram.r")
  source("~/git/Kevin_R_scripts/calculate_pco.r")
  source("~/git/Kevin_R_scripts/render_calculated_pcoa.r")
  source("~/git/ronald_r_scripts/GDC_metadata_download.ronald.r")
  source("~/git/ronald_r_scripts/GDC_raw_count_merge.vRonald.r")
  source("~/git/ronald_r_scripts/get_listof_UUIDs.r")
  library(DESeq)
  
  # downloads data
  #download_project_data("TCGA-LUAD")
  #download_project_data("TCGA-LUSC")
  system("curl --remote-name --remote-header-name 'https://gdc-api.nci.nih.gov/data/dbbd28f1-5e60-4735-9b90-0bdc25c96387'")
  system("curl --remote-name --remote-header-name 'https://gdc-api.nci.nih.gov/data/2edad525-0b1e-453c-9b39-cb126c92e079'")
  system("curl --remote-name --remote-header-name 'https://gdc-api.nci.nih.gov/data/574abc9e-aeb3-4e64-bc64-d21d619401fe'")
  system("curl --remote-name --remote-header-name 'https://gdc-api.nci.nih.gov/data/eab621eb-0b4f-48ac-a79a-08056111ffdc'")

  # unzips data into .counts files
  system("gunzip *.gz")
  system("ls | grep .counts$ > counts_files")
  
  # merges abundance data together
  GDC_raw_count_merge(id_list="counts_files")
  
  # gets UUIDs of data merged together
  export_listof_UUIDs(tsv = "counts_files.merged_data.txt")
  
  # gets metadata file
  get_GDC_metadata("counts_files.merged_data_file_UUIDs", my_rot = "yes")
  metadata_filename <- list.files()[grep("GDC_METADATA.txt", list.files(), perl=T)][1] 
  print(metadata_filename)
 
  # normalizing the data
  preprocessing_tool(data_in = "counts_files.merged_data.txt", produce_boxplots = TRUE)
  
  # visualize the data
  #heatmap_dendrogram(file_in = "counts_files.merged_data.txt.DESeq_blind.PREPROCESSED.txt")
  calculate_pco(file_in = "counts_files.merged_data.txt.DESeq_blind.PREPROCESSED.txt")
  print(metadata_filename)
  render_calcualted_pcoa("counts_files.merged_data.txt.DESeq_blind.PREPROCESSED.txt.euclidean.PCoA", metadata_table = metadata_filename, metadata_column_index = 9)
}
whole_process()
