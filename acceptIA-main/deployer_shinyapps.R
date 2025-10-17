# ============================================================================
# SCRIPT DE DÉPLOIEMENT SUR SHINYAPPS.IO
# ============================================================================

library(rsconnect)

cat("========================================\n")
cat("DÉPLOIEMENT SUR SHINYAPPS.IO\n")
cat("========================================\n\n")

# Vérifier que rsconnect est configuré
accounts <- rsconnect::accounts()

if (nrow(accounts) == 0) {
  cat("⚠️ Vous devez d'abord configurer votre compte ShinyApps.io\n\n")
  cat("1. Allez sur https://www.shinyapps.io\n")
  cat("2. Cliquez sur votre nom → Account → Tokens\n")
  cat("3. Cliquez sur 'Show Token'\n")
  cat("4. Copiez et exécutez la commande rsconnect::setAccountInfo(...)\n\n")
  cat("Exemple:\n")
  cat("rsconnect::setAccountInfo(\n")
  cat("  name = 'votre-nom',\n")
  cat("  token = 'XXXXXXXXXXXX',\n")
  cat("  secret = 'YYYYYYYYYYYY'\n")
  cat(")\n\n")
  stop("Configuration requise avant déploiement")
}

cat("✓ Compte ShinyApps.io configuré:", accounts$name[1], "\n\n")

# Liste des fichiers à déployer
fichiers_a_deployer <- c(
  "app.R",
  "modules/ui_modules.R",
  "modules/ui_modules_suite.R",
  "modules/server_modules.R",
  "modules/data_functions.R"
)

cat("Fichiers à déployer:\n")
for (f in fichiers_a_deployer) {
  if (file.exists(f)) {
    cat("  ✓", f, "\n")
  } else {
    cat("  ✗", f, "MANQUANT!\n")
    stop("Fichier manquant:", f)
  }
}

cat("\n========================================\n")
cat("Déploiement en cours...\n")
cat("========================================\n\n")

# Déployer
tryCatch({
  rsconnect::deployApp(
    appFiles = fichiers_a_deployer,
    appName = "acceptia-study",
    forceUpdate = TRUE,
    launch.browser = TRUE
  )
  
  cat("\n========================================\n")
  cat("✓ DÉPLOIEMENT RÉUSSI !\n")
  cat("========================================\n\n")
  cat("Votre application est accessible sur:\n")
  cat("https://", accounts$name[1], ".shinyapps.io/acceptia-study/\n\n", sep = "")
  
}, error = function(e) {
  cat("\n========================================\n")
  cat("✗ ERREUR DE DÉPLOIEMENT\n")
  cat("========================================\n\n")
  cat("Message d'erreur:", e$message, "\n\n")
  
  cat("Solutions possibles:\n")
  cat("1. Vérifiez votre connexion internet\n")
  cat("2. Vérifiez que votre plan ShinyApps.io est actif\n")
  cat("3. Essayez de redéployer avec forceUpdate = TRUE\n")
  cat("4. Consultez les logs sur shinyapps.io\n\n")
})
