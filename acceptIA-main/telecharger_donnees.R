# ============================================================================
# SCRIPT POUR TÉLÉCHARGER LES DONNÉES DEPUIS MONGODB
# ============================================================================

# Charger les packages nécessaires
if (!require("mongolite")) install.packages("mongolite")
if (!require("writexl")) install.packages("writexl")

library(mongolite)
library(writexl)

cat("========================================\n")
cat("TÉLÉCHARGEMENT DES DONNÉES MONGODB\n")
cat("========================================\n\n")

# Connection string
mongo_uri <- "mongodb+srv://vuillaumeanthony_db_user:y4IRDyem6180yh7I@cluster0.zaf44u9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

# Se connecter
cat("Connexion à MongoDB...\n")
participants <- mongo(
  collection = "participants",
  db = "acceptia_study",
  url = mongo_uri
)

# Compter les participants
count <- participants$count('{}')
cat("→", count, "participant(s) trouvé(s)\n\n")

if (count == 0) {
  cat("⚠ Aucune donnée à télécharger.\n")
  cat("Les participants apparaîtront ici après avoir terminé le questionnaire.\n\n")
} else {
  # Récupérer toutes les données
  cat("Récupération des données...\n")
  all_data <- participants$find('{}')
  
  # Créer un nom de fichier avec la date
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  
  # Sauvegarder en CSV
  csv_filename <- paste0("donnees_acceptia_", timestamp, ".csv")
  write.csv(all_data, csv_filename, row.names = FALSE, fileEncoding = "UTF-8")
  cat("✓ CSV sauvegardé:", csv_filename, "\n")
  
  # Sauvegarder en Excel
  excel_filename <- paste0("donnees_acceptia_", timestamp, ".xlsx")
  write_xlsx(all_data, excel_filename)
  cat("✓ Excel sauvegardé:", excel_filename, "\n")
  
  # Sauvegarder en RData
  rdata_filename <- paste0("donnees_acceptia_", timestamp, ".RData")
  study_data <- all_data
  save(study_data, file = rdata_filename)
  cat("✓ RData sauvegardé:", rdata_filename, "\n\n")
  
  # Afficher un aperçu des données
  cat("========================================\n")
  cat("APERÇU DES DONNÉES\n")
  cat("========================================\n")
  cat("Nombre de participants:", nrow(all_data), "\n")
  cat("Nombre de variables:", ncol(all_data), "\n\n")
  
  cat("Colonnes disponibles:\n")
  print(names(all_data))
  cat("\n")
  
  # Statistiques de base
  if ("age" %in% names(all_data)) {
    cat("Âge moyen:", round(mean(all_data$age, na.rm = TRUE), 1), "ans\n")
    cat("Âge min-max:", min(all_data$age, na.rm = TRUE), "-", 
        max(all_data$age, na.rm = TRUE), "ans\n")
  }
  
  if ("sexe" %in% names(all_data)) {
    cat("\nDistribution par sexe:\n")
    print(table(all_data$sexe))
  }
  
  if ("benefices_first" %in% names(all_data)) {
    cat("\nRandomisation Bénéfices/Craintes:\n")
    cat("  - Bénéfices en premier:", sum(all_data$benefices_first, na.rm = TRUE), "\n")
    cat("  - Craintes en premier:", sum(!all_data$benefices_first, na.rm = TRUE), "\n")
  }
  
  if ("usages_sante_first" %in% names(all_data)) {
    cat("\nRandomisation Usages santé:\n")
    cat("  - Usages avant IA:", sum(all_data$usages_sante_first, na.rm = TRUE), "\n")
    cat("  - Usages après IA:", sum(!all_data$usages_sante_first, na.rm = TRUE), "\n")
  }
  
  cat("\n========================================\n")
  cat("✓ Téléchargement terminé !\n")
  cat("========================================\n\n")
}
