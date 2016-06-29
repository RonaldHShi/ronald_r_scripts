whole_process <- function()
{
  source("~/git/ronald_r_scripts/GDC_metadata_download.ronald.r")
  source("~/git/ronald_r_scripts/GDC_raw_count_merge.vRonald.r")
  source("~/git/ronald_r_scripts/get_listof_UUIDs.r")
  library(DESeq)
  
  # downloads data
  download_project_data("TCGA-LUAD")
  download_project_data("TCGA-LUSC")
  
  # unzips data into .counts files
  system("gunzip *.gz")
  system("ls > counts_files")
  
  # merges abundance data together
  GDC_raw_count_merge(id_list="counts_files")
  
  # gets UUIDs of data merged together
  export_listof_UUIDs(tsv = "counts_files.merged_data.txt")
  
  # gets metadata file
  get_GDC_metadata("counts_files.merged_data_file_UUIDs", my_rot = "yes")
  metadata_filename <- system("ls -t | head -n1")
  
  # normalizing the data
  preprocessing_tool(data_in = "counts_files.merged_data.txt", produce_boxplots = TRUE)
  
  # visualize the data
  heatmap_dendrogram(file_in = "counts_files.merged_data.txt.DESeq_blind.PREPROCESSED.txt")
  calculate_pco(file_in = "counts_files.merged_data.txt.DESeq_blind.PREPROCESSED.txt")
  render_calcualted_pcoa("counts_files.merged_data.txt.DESeq_blind.PREPROCESSED.txt.euclidean.PCoA", metadata_table = metadata_filename, use_all_metadata_columns = T)
}