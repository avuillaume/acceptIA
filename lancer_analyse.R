# ============================================================================
# LANCEUR D'ANALYSE - Acceptabilité de l'IA en Santé
# ============================================================================

cat("\n")
cat("====================================================================\n")
cat("  ANALYSE DES DONNÉES - Acceptabilité de l'IA en Santé\n")
cat("====================================================================\n\n")

# Vérifier que les données existent
if (!file.exists("data/study_data.RData") && !file.exists("data/study_data.csv")) {
  cat("❌ ERREUR : Aucune donnée trouvée!\n\n")
  cat("Veuillez d'abord collecter des données avec l'application Shiny.\n")
  cat("Pour lancer l'application de collecte :\n")
  cat("  source('lancer_app.R')\n\n")
  stop("Données non disponibles.")
}

cat("✓ Données détectées\n\n")

# Vérifier les packages
required_packages <- c("dplyr", "tidyr", "ggplot2", "lavaan", "psych", "corrplot")
missing_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]

if (length(missing_packages) > 0) {
  cat("Installation des packages manquants...\n")
  install.packages(missing_packages)
}

cat("✓ Packages chargés\n\n")

# Lancer l'analyse
cat("Démarrage de l'analyse...\n")
cat("--------------------------------------------------------------------\n\n")

source("analyse_donnees.R")

cat("\n====================================================================\n")
cat("  ANALYSE TERMINÉE AVEC SUCCÈS!\n")
cat("====================================================================\n\n")
cat("Consultez le dossier 'resultats/' pour voir tous les fichiers générés.\n\n")
