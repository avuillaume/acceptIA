# ============================================================================
# SCRIPT DE LANCEMENT - Application R Shiny
# Acceptabilité de l'IA en Santé
# ============================================================================

# Ce script facilite le lancement de l'application R Shiny

# Définir le répertoire de travail (où se trouve ce script)
if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
  # Si RStudio est disponible, utiliser le chemin du script
  script_path <- dirname(rstudioapi::getActiveDocumentContext()$path)
  if (nchar(script_path) > 0) {
    setwd(script_path)
  }
} else {
  # Sinon, définir manuellement le chemin
  setwd("c:/Users/U017972/OneDrive - SCOR/Documents/Docs/acceptabilité de l'IA/acceptIA-main/acceptIA-main")
}

cat("Répertoire de travail:", getwd(), "\n\n")

# Nettoyer l'environnement
rm(list = ls())

# Afficher un message de bienvenue
cat("\n")
cat("========================================================\n")
cat("  Application R Shiny - Acceptabilité de l'IA en Santé\n")
cat("========================================================\n")
cat("\n")

# Vérifier et installer les packages nécessaires
cat("Vérification des packages nécessaires...\n")

packages_necessaires <- c(
  "shiny", "shinyjs", "shinythemes", "DT",
  "dplyr", "tidyr", "ggplot2", "lavaan"
)

packages_manquants <- packages_necessaires[!packages_necessaires %in% installed.packages()[,"Package"]]

if (length(packages_manquants) > 0) {
  cat("\nInstallation des packages manquants:", paste(packages_manquants, collapse = ", "), "\n")
  install.packages(packages_manquants, dependencies = TRUE)
  cat("Installation terminée.\n\n")
} else {
  cat("Tous les packages sont déjà installés.\n\n")
}

# Vérifier que le fichier app.R existe
if (!file.exists("app.R")) {
  stop("Erreur : Le fichier app.R n'a pas été trouvé dans le répertoire courant.\n",
       "Assurez-vous d'être dans le bon répertoire avec setwd().")
}

# Vérifier que le dossier modules existe
if (!dir.exists("modules")) {
  stop("Erreur : Le dossier 'modules' n'a pas été trouvé.\n",
       "Assurez-vous que la structure du projet est complète.")
}

# Créer le dossier data s'il n'existe pas
if (!dir.exists("data")) {
  dir.create("data")
  cat("Dossier 'data' créé.\n\n")
}

# Lancer l'application
cat("Lancement de l'application...\n")
cat("Une fenêtre de navigateur devrait s'ouvrir automatiquement.\n")
cat("Si ce n'est pas le cas, copiez l'URL affichée dans votre navigateur.\n\n")
cat("Pour arrêter l'application, appuyez sur ESC ou fermez la fenêtre R.\n\n")

# Lancer l'application Shiny
shiny::runApp(launch.browser = TRUE)
