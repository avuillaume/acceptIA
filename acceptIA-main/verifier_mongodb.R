# ============================================================================
# VÉRIFIER L'ÉTAT DE MONGODB
# ============================================================================

if (!require("mongolite")) {
  cat("Installation de mongolite...\n")
  install.packages("mongolite")
}

library(mongolite)

cat("========================================\n")
cat("VÉRIFICATION MONGODB ATLAS\n")
cat("========================================\n\n")

# Connection string
mongo_uri <- "mongodb+srv://vuillaumeanthony_db_user:y4IRDyem6180yh7I@cluster0.zaf44u9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

cat("1. Test de connexion à MongoDB Atlas...\n")

tryCatch({
  # Se connecter
  participants <- mongo(
    collection = "participants",
    db = "acceptia_study",
    url = mongo_uri
  )
  
  cat("   ✓ Connexion réussie !\n\n")
  
  # Compter les participants
  cat("2. Vérification des données existantes...\n")
  count <- participants$count('{}')
  
  if (count == 0) {
    cat("   ℹ️  Aucun participant trouvé\n")
    cat("   → C'est normal si personne n'a encore rempli le questionnaire\n")
    cat("   → La database et la collection seront créées automatiquement\n")
    cat("     lors du premier participant\n\n")
    
    cat("========================================\n")
    cat("ÉTAT : Base de données vide (prête)\n")
    cat("========================================\n\n")
    
    cat("Prochaines étapes :\n")
    cat("1. Testez localement : source('lancer_app.R')\n")
    cat("2. Remplissez un questionnaire de test\n")
    cat("3. Vérifiez à nouveau avec ce script\n")
    cat("4. Déployez sur ShinyApps.io\n\n")
    
  } else {
    cat("   ✓", count, "participant(s) trouvé(s)\n\n")
    
    # Récupérer tous les participants
    all_data <- participants$find('{}')
    
    cat("3. Aperçu des participants :\n")
    cat("========================================\n")
    
    # Afficher les colonnes disponibles
    cat("Colonnes disponibles (", ncol(all_data), "):\n")
    print(names(all_data))
    cat("\n")
    
    # Afficher les premiers participants
    cat("Derniers participants :\n")
    if ("participant_id" %in% names(all_data)) {
      cols_to_show <- intersect(c("participant_id", "timestamp", "age", "sexe", "benefices_first"), 
                                 names(all_data))
      print(tail(all_data[, cols_to_show], min(5, nrow(all_data))))
    } else {
      print(head(all_data, 2))
    }
    
    cat("\n========================================\n")
    cat("ÉTAT : Données présentes\n")
    cat("========================================\n\n")
    
    cat("Pour télécharger toutes les données :\n")
    cat("source('telecharger_donnees.R')\n\n")
  }
  
}, error = function(e) {
  cat("   ✗ ERREUR de connexion\n\n")
  cat("Message d'erreur:", e$message, "\n\n")
  
  cat("========================================\n")
  cat("PROBLÈMES POSSIBLES\n")
  cat("========================================\n\n")
  
  cat("1. Problème de connexion internet\n")
  cat("   → Vérifiez votre connexion\n\n")
  
  cat("2. Erreur d'authentification MongoDB\n")
  cat("   → Vérifiez le mot de passe dans la connection string\n\n")
  
  cat("3. IP non autorisée\n")
  cat("   → Sur MongoDB Atlas :\n")
  cat("     - Network Access → Add IP Address\n")
  cat("     - Allow from Anywhere (0.0.0.0/0)\n\n")
  
  cat("4. Cluster en pause (plan gratuit inactif)\n")
  cat("   → Allez sur MongoDB Atlas et réveillez le cluster\n\n")
})

cat("========================================\n")
cat("FIN DE LA VÉRIFICATION\n")
cat("========================================\n")
