# ============================================================================
# Script de Test - Comptage des Décimales de π
# ============================================================================
# Ce script vérifie que les comptages de chiffres sont corrects

# Décimales de π (200 premières)
pi_decimals <- "14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196"

# Fonction pour compter un chiffre
count_digit <- function(digit, decimals = pi_decimals) {
  sum(strsplit(decimals, "")[[1]] == as.character(digit))
}

# Comptages attendus (fournis par l'utilisateur)
expected_counts <- c(
  "0" = 19,
  "1" = 20,
  "2" = 24,
  "3" = 19,
  "4" = 22,
  "5" = 20,
  "6" = 16,
  "7" = 12,
  "8" = 25,
  "9" = 23
)

# Vérification
cat("=== Vérification des Comptages de π ===\n\n")
cat("Décimales :", pi_decimals, "\n\n")
cat("Longueur totale :", nchar(pi_decimals), "caractères\n\n")

all_correct <- TRUE

for (digit in 0:9) {
  actual_count <- count_digit(digit)
  expected_count <- expected_counts[as.character(digit)]
  
  is_correct <- (actual_count == expected_count)
  symbol <- ifelse(is_correct, "✓", "✗")
  
  cat(sprintf("%s Chiffre %d : %2d occurrences (attendu: %2d) %s\n", 
              symbol, digit, actual_count, expected_count,
              ifelse(is_correct, "", "❌ ERREUR")))
  
  if (!is_correct) {
    all_correct <- FALSE
  }
}

cat("\n")
cat("Total des occurrences :", sum(sapply(0:9, count_digit)), "\n")
cat("Somme des attendus :", sum(expected_counts), "\n\n")

if (all_correct) {
  cat("✅ TOUS LES COMPTAGES SONT CORRECTS !\n")
} else {
  cat("❌ CERTAINS COMPTAGES SONT INCORRECTS !\n")
  cat("   Vérifiez les décimales de π.\n")
}

# Afficher la distribution sous forme de graphique (si ggplot2 est disponible)
if (require("ggplot2", quietly = TRUE)) {
  cat("\n=== Génération du Graphique ===\n")
  
  counts_df <- data.frame(
    Chiffre = factor(0:9),
    Occurrences = sapply(0:9, count_digit)
  )
  
  p <- ggplot(counts_df, aes(x = Chiffre, y = Occurrences, fill = Chiffre)) +
    geom_bar(stat = "identity", show.legend = FALSE) +
    geom_text(aes(label = Occurrences), vjust = -0.5, size = 5) +
    scale_fill_brewer(palette = "Spectral") +
    labs(
      title = "Distribution des Chiffres dans les 200 Premières Décimales de π",
      x = "Chiffre",
      y = "Nombre d'Occurrences"
    ) +
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(hjust = 0.5, face = "bold"),
      panel.grid.major.x = element_blank()
    ) +
    ylim(0, 30)
  
  print(p)
  
  # Sauvegarder le graphique
  ggsave("distribution_pi_decimales.png", p, width = 10, height = 6, dpi = 300)
  cat("Graphique sauvegardé : distribution_pi_decimales.png\n")
} else {
  cat("\nℹ️  Installez ggplot2 pour générer le graphique : install.packages('ggplot2')\n")
}

# Test de randomisation
cat("\n=== Test de Randomisation ===\n")
set.seed(NULL)  # Assurer la vraie randomisation
random_digits <- sample(0:9, 20, replace = TRUE)
cat("20 chiffres aléatoires générés :", paste(random_digits, collapse = ", "), "\n")
cat("Distribution :", table(random_digits), "\n")

# Résumé statistique
cat("\n=== Statistiques ===\n")
cat(sprintf("Moyenne : %.2f occurrences par chiffre\n", mean(sapply(0:9, count_digit))))
cat(sprintf("Médiane : %.2f\n", median(sapply(0:9, count_digit))))
cat(sprintf("Écart-type : %.2f\n", sd(sapply(0:9, count_digit))))
cat(sprintf("Min : %d (chiffre %s)\n", 
            min(sapply(0:9, count_digit)),
            paste(which(sapply(0:9, count_digit) == min(sapply(0:9, count_digit))) - 1, collapse = ", ")))
cat(sprintf("Max : %d (chiffre %s)\n", 
            max(sapply(0:9, count_digit)),
            paste(which(sapply(0:9, count_digit) == max(sapply(0:9, count_digit))) - 1, collapse = ", ")))

cat("\n✅ Test terminé !\n")
