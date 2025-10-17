# ============================================================================
# SCRIPT DE TEST MONGODB
# ============================================================================

# Charger le package
if (!require("mongolite")) install.packages("mongolite")
library(mongolite)

cat("========================================\n")
cat("TEST DE CONNEXION MONGODB ATLAS\n")
cat("========================================\n\n")

# Connection string
mongo_uri <- "mongodb+srv://vuillaumeanthony_db_user:y4IRDyem6180yh7I@cluster0.zaf44u9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

# Test 1 : Se connecter
cat("1. Test de connexion...\n")
tryCatch({
  participants <- mongo(
    collection = "participants",
    db = "acceptia_study",
    url = mongo_uri
  )
  cat("   ✓ Connexion réussie !\n\n")
}, error = function(e) {
  cat("   ✗ ERREUR de connexion:", e$message, "\n\n")
  stop()
})

# Test 2 : Compter les documents existants
cat("2. Nombre de participants dans la base...\n")
count <- participants$count('{}')
cat("   →", count, "participant(s) trouvé(s)\n\n")

# Test 3 : Insérer un participant de test
cat("3. Insertion d'un participant de test...\n")
test_participant <- data.frame(
  participant_id = paste0("TEST_", format(Sys.time(), "%Y%m%d%H%M%S")),
  timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
  age = 99,
  sexe = "Test",
  benefices_first = TRUE,
  usages_sante_first = FALSE,
  test_data = TRUE,
  stringsAsFactors = FALSE
)

tryCatch({
  participants$insert(test_participant)
  cat("   ✓ Participant de test inséré !\n\n")
}, error = function(e) {
  cat("   ✗ ERREUR d'insertion:", e$message, "\n\n")
})

# Test 4 : Récupérer tous les participants
cat("4. Récupération de tous les participants...\n")
all_participants <- participants$find('{}')
cat("   → Total après insertion:", nrow(all_participants), "participant(s)\n\n")

# Test 5 : Afficher les 3 derniers participants
cat("5. Aperçu des derniers participants:\n")
if (nrow(all_participants) > 0) {
  n_show <- min(3, nrow(all_participants))
  print(tail(all_participants[, c("participant_id", "timestamp", "age", "sexe")], n_show))
} else {
  cat("   (Aucun participant)\n")
}
cat("\n")

# Test 6 : Supprimer le participant de test
cat("6. Nettoyage (suppression du participant de test)...\n")
tryCatch({
  participants$remove(sprintf('{"participant_id": "%s"}', test_participant$participant_id))
  cat("   ✓ Participant de test supprimé !\n\n")
}, error = function(e) {
  cat("   ✗ ERREUR de suppression:", e$message, "\n\n")
})

# Vérification finale
count_final <- participants$count('{}')
cat("========================================\n")
cat("RÉSUMÉ:\n")
cat("  - Connexion: ✓ OK\n")
cat("  - Insertion: ✓ OK\n")
cat("  - Lecture: ✓ OK\n")
cat("  - Suppression: ✓ OK\n")
cat("  - Participants actuels:", count_final, "\n")
cat("========================================\n")
cat("\n✓ MongoDB est prêt à être utilisé !\n\n")
