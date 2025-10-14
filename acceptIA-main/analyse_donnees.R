# ============================================================================
# SCRIPT D'ANALYSE DES DONNÉES
# Acceptabilité de l'IA en Santé
# ============================================================================

# Chargement des packages nécessaires
if (!require("dplyr")) install.packages("dplyr")
if (!require("tidyr")) install.packages("tidyr")
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("lavaan")) install.packages("lavaan")
if (!require("psych")) install.packages("psych")
if (!require("corrplot")) install.packages("corrplot")

library(dplyr)
library(tidyr)
library(ggplot2)
library(lavaan)
library(psych)
library(corrplot)

# ============================================================================
# CHARGEMENT DES DONNÉES
# ============================================================================

# Charger les données collectées
load_study_data <- function(file_path = "data/study_data.RData") {
  if (file.exists(file_path)) {
    load(file_path)
    return(study_data)
  } else if (file.exists("data/study_data.csv")) {
    study_data <- read.csv("data/study_data.csv", stringsAsFactors = FALSE)
    return(study_data)
  } else {
    stop("Aucun fichier de données trouvé. Veuillez collecter des données d'abord.")
  }
}

# Charger les données
data <- load_study_data()

cat("Données chargées avec succès!\n")
cat("Nombre de participants:", nrow(data), "\n\n")

# ============================================================================
# PRÉPARATION DES DONNÉES
# ============================================================================

# Calculer les scores composites
calculate_scores <- function(data) {
  
  # Scores d'aversion au risque et à l'ambiguïté
  data$score_Risk_Gains <- rowMeans(data[, c("RG1", "RG2", "RG3")], na.rm = TRUE)
  data$score_Risk_Losses <- rowMeans(data[, c("RP1", "RP2", "RP3")], na.rm = TRUE)
  data$score_Ambig_Gains <- rowMeans(data[, c("AG1", "AG2", "AG3")], na.rm = TRUE)
  data$score_Ambig_Losses <- rowMeans(data[, c("AP1", "AP2", "AP3")], na.rm = TRUE)
  
  # Scores de perception de l'IA en santé
  data$score_Benefices <- rowMeans(data[, paste0("B", 1:10)], na.rm = TRUE)
  data$score_Craintes <- rowMeans(data[, paste0("C", 1:10)], na.rm = TRUE)
  
  return(data)
}

data <- calculate_scores(data)

cat("Scores composites calculés.\n\n")

# ============================================================================
# STATISTIQUES DESCRIPTIVES
# ============================================================================

cat(rep("=", 78), "\n", sep = "")
cat("STATISTIQUES DESCRIPTIVES\n")
cat(rep("=", 78), "\n\n", sep = "")

# Caractéristiques sociodémographiques
cat("--- SOCIODÉMOGRAPHIQUES ---\n")
if ("age" %in% names(data)) {
  cat("Âge moyen:", round(mean(data$age, na.rm = TRUE), 2), 
      "± ", round(sd(data$age, na.rm = TRUE), 2), "\n")
  cat("Âge min-max:", min(data$age, na.rm = TRUE), "-", 
      max(data$age, na.rm = TRUE), "\n\n")
}

if ("sexe" %in% names(data)) {
  cat("Répartition par sexe:\n")
  print(table(data$sexe))
  cat("\n")
}

if ("education" %in% names(data)) {
  cat("Niveau d'éducation:\n")
  print(table(data$education))
  cat("\n")
}

# Statistiques sur les scores composites
cat("\n--- SCORES D'AVERSION ---\n")
score_cols <- c("score_Risk_Gains", "score_Risk_Losses", 
                "score_Ambig_Gains", "score_Ambig_Losses")
for (col in score_cols) {
  if (col %in% names(data)) {
    cat(col, ":\n")
    cat("  Moyenne:", round(mean(data[[col]], na.rm = TRUE), 2), "\n")
    cat("  Écart-type:", round(sd(data[[col]], na.rm = TRUE), 2), "\n")
    cat("  Min-Max:", round(min(data[[col]], na.rm = TRUE), 2), "-", 
        round(max(data[[col]], na.rm = TRUE), 2), "\n\n")
  }
}

cat("\n--- SCORES DE PERCEPTION ---\n")
perception_cols <- c("score_Benefices", "score_Craintes")
for (col in perception_cols) {
  if (col %in% names(data)) {
    cat(col, ":\n")
    cat("  Moyenne:", round(mean(data[[col]], na.rm = TRUE), 2), "\n")
    cat("  Écart-type:", round(sd(data[[col]], na.rm = TRUE), 2), "\n")
    cat("  Min-Max:", round(min(data[[col]], na.rm = TRUE), 2), "-", 
        round(max(data[[col]], na.rm = TRUE), 2), "\n\n")
  }
}

# ============================================================================
# ANALYSES DE CORRÉLATIONS
# ============================================================================

cat("\n", rep("=", 78), "\n", sep = "")
cat("CORRÉLATIONS\n")
cat(rep("=", 78), "\n\n", sep = "")

# Matrice de corrélations entre les scores
score_data <- data[, c("score_Risk_Gains", "score_Risk_Losses", 
                       "score_Ambig_Gains", "score_Ambig_Losses",
                       "score_Benefices", "score_Craintes")]

if (nrow(na.omit(score_data)) > 0) {
  cor_matrix <- cor(score_data, use = "pairwise.complete.obs")
  cat("Matrice de corrélations:\n")
  print(round(cor_matrix, 3))
  
  # Visualisation
  png("resultats/correlation_matrix.png", width = 800, height = 800)
  corrplot(cor_matrix, method = "color", type = "upper", 
           addCoef.col = "black", tl.col = "black", tl.srt = 45,
           title = "Matrice de corrélations", mar = c(0,0,1,0))
  dev.off()
  cat("\nGraphique sauvegardé: resultats/correlation_matrix.png\n")
}

# ============================================================================
# VISUALISATIONS
# ============================================================================

cat("\n", rep("=", 78), "\n", sep = "")
cat("GÉNÉRATION DES VISUALISATIONS\n")
cat(rep("=", 78), "\n\n", sep = "")

# Créer le dossier resultats s'il n'existe pas
if (!dir.exists("resultats")) {
  dir.create("resultats")
}

# 1. Distribution des scores d'aversion
p1 <- data %>%
  select(starts_with("score_")) %>%
  select(score_Risk_Gains:score_Ambig_Losses) %>%
  pivot_longer(everything(), names_to = "Type", values_to = "Score") %>%
  mutate(Type = gsub("score_", "", Type)) %>%
  ggplot(aes(x = Score, fill = Type)) +
  geom_histogram(bins = 20, alpha = 0.7) +
  facet_wrap(~Type, scales = "free") +
  theme_minimal() +
  labs(title = "Distribution des scores d'aversion",
       x = "Score", y = "Fréquence") +
  theme(legend.position = "none")

ggsave("resultats/distribution_aversions.png", p1, width = 10, height = 6)
cat("✓ Distribution des aversions sauvegardée\n")

# 2. Distribution des scores de perception
p2 <- data %>%
  select(score_Benefices, score_Craintes) %>%
  pivot_longer(everything(), names_to = "Type", values_to = "Score") %>%
  mutate(Type = gsub("score_", "", Type)) %>%
  ggplot(aes(x = Score, fill = Type)) +
  geom_histogram(bins = 20, alpha = 0.7, position = "identity") +
  scale_fill_manual(values = c("Benefices" = "forestgreen", "Craintes" = "coral")) +
  theme_minimal() +
  labs(title = "Distribution des scores de perception de l'IA en santé",
       x = "Score (1-7)", y = "Fréquence",
       fill = "Type de perception")

ggsave("resultats/distribution_perceptions.png", p2, width = 10, height = 6)
cat("✓ Distribution des perceptions sauvegardée\n")

# 3. Relation Bénéfices vs Craintes
p3 <- ggplot(data, aes(x = score_Benefices, y = score_Craintes)) +
  geom_point(alpha = 0.5, size = 3, color = "steelblue") +
  geom_smooth(method = "lm", color = "red", se = TRUE) +
  theme_minimal() +
  labs(title = "Relation entre Bénéfices perçus et Craintes",
       x = "Bénéfices perçus (1-7)", 
       y = "Craintes (1-7)")

ggsave("resultats/benefices_vs_craintes.png", p3, width = 8, height = 6)
cat("✓ Graphique Bénéfices vs Craintes sauvegardé\n")

# 4. Boxplots comparatifs
p4 <- data %>%
  select(starts_with("score_")) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Score") %>%
  mutate(Variable = gsub("score_", "", Variable)) %>%
  ggplot(aes(x = Variable, y = Score, fill = Variable)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        legend.position = "none") +
  labs(title = "Comparaison des scores (boxplots)",
       x = "", y = "Score")

ggsave("resultats/boxplots_scores.png", p4, width = 10, height = 6)
cat("✓ Boxplots sauvegardés\n")

# ============================================================================
# MODÈLE SEM (Structural Equation Modeling)
# ============================================================================

cat("\n", rep("=", 78), "\n", sep = "")
cat("MODÈLE D'ÉQUATIONS STRUCTURELLES (SEM)\n")
cat(rep("=", 78), "\n\n", sep = "")

# Définir le modèle SEM
sem_model <- '
  # Modèle de mesure - Variables latentes
  Risk_Gains =~ RG1 + RG2 + RG3
  Risk_Losses =~ RP1 + RP2 + RP3
  Ambig_Gains =~ AG1 + AG2 + AG3
  Ambig_Losses =~ AP1 + AP2 + AP3
  
  Benefices =~ B1 + B2 + B3 + B4 + B5 + B6 + B7 + B8 + B9 + B10
  Craintes =~ C1 + C2 + C3 + C4 + C5 + C6 + C7 + C8 + C9 + C10
  
  # Modèle structurel - Relations causales
  Benefices ~ a1*Risk_Gains + a2*Risk_Losses + a3*Ambig_Gains + a4*Ambig_Losses
  Craintes ~ b1*Risk_Gains + b2*Risk_Losses + b3*Ambig_Gains + b4*Ambig_Losses
  
  # Covariances entre les aversions
  Risk_Gains ~~ Risk_Losses
  Ambig_Gains ~~ Ambig_Losses
  Risk_Gains ~~ Ambig_Gains
  Risk_Losses ~~ Ambig_Losses
  
  # Covariance entre les perceptions
  Benefices ~~ Craintes
  
  # Effets indirects
  ind_rg_benef := a1
  ind_rl_benef := a2
  ind_ag_benef := a3
  ind_al_benef := a4
  
  ind_rg_craint := b1
  ind_rl_craint := b2
  ind_ag_craint := b3
  ind_al_craint := b4
'

# Estimer le modèle
cat("Estimation du modèle en cours...\n")
fit <- tryCatch({
  sem(sem_model, data = data, estimator = "MLR", missing = "fiml",
      se = "robust", test = "Satorra.Bentler")
}, error = function(e) {
  cat("Erreur lors de l'estimation du modèle:", e$message, "\n")
  return(NULL)
})

if (!is.null(fit)) {
  cat("\n✓ Modèle estimé avec succès!\n\n")
  
  # Résumé du modèle
  cat("RÉSUMÉ DU MODÈLE:\n")
  cat(rep("=", 78), "\n", sep = "")
  summary_fit <- summary(fit, fit.measures = TRUE, standardized = TRUE, rsquare = TRUE)
  print(summary_fit)
  
  # Sauvegarder les résultats
  sink("resultats/sem_results.txt")
  cat("RÉSULTATS DU MODÈLE D'ÉQUATIONS STRUCTURELLES\n")
  cat("Date:", as.character(Sys.time()), "\n")
  cat(rep("=", 78), "\n\n", sep = "")
  print(summary_fit)
  sink()
  
  cat("\n✓ Résultats sauvegardés dans: resultats/sem_results.txt\n")
  
  # Indices d'ajustement
  cat("\n--- INDICES D'AJUSTEMENT ---\n")
  indices <- fitMeasures(fit, c("chisq", "df", "pvalue", "cfi", "tli", 
                                "rmsea", "rmsea.ci.lower", "rmsea.ci.upper",
                                "srmr", "aic", "bic"))
  print(round(indices, 3))
  
  # Paramètres standardisés
  cat("\n--- PARAMÈTRES STANDARDISÉS ---\n")
  params <- parameterEstimates(fit, standardized = TRUE)
  print(params[params$op == "~", c("lhs", "rhs", "est", "se", "pvalue", "std.all")])
  
  # Sauvegarder le modèle
  saveRDS(fit, "resultats/sem_model_fit.rds")
  cat("\n✓ Modèle sauvegardé dans: resultats/sem_model_fit.rds\n")
  
} else {
  cat("\n✗ Impossible d'estimer le modèle SEM.\n")
  cat("  Vérifiez que vous avez suffisamment de données.\n")
}

# ============================================================================
# ANALYSES COMPLÉMENTAIRES
# ============================================================================

cat("\n", rep("=", 78), "\n", sep = "")
cat("ANALYSES COMPLÉMENTAIRES\n")
cat(rep("=", 78), "\n\n", sep = "")

# Test t - Différences selon le sexe
if ("sexe" %in% names(data) && length(unique(data$sexe)) == 2) {
  cat("--- DIFFÉRENCES SELON LE SEXE ---\n")
  
  for (var in c("score_Benefices", "score_Craintes")) {
    if (var %in% names(data)) {
      test_result <- t.test(data[[var]] ~ data$sexe)
      cat("\n", var, ":\n")
      cat("  Groupe 1 (M):", round(test_result$estimate[1], 2), "\n")
      cat("  Groupe 2 (F):", round(test_result$estimate[2], 2), "\n")
      cat("  t =", round(test_result$statistic, 2), 
          ", p =", round(test_result$p.value, 4), "\n")
    }
  }
}

# Régression linéaire simple
cat("\n\n--- RÉGRESSIONS LINÉAIRES ---\n")

# Prédire les Bénéfices perçus
model_benef <- lm(score_Benefices ~ score_Risk_Gains + score_Risk_Losses + 
                   score_Ambig_Gains + score_Ambig_Losses, data = data)
cat("\nModèle: Bénéfices ~ Aversions\n")
print(summary(model_benef))

# Prédire les Craintes
model_craint <- lm(score_Craintes ~ score_Risk_Gains + score_Risk_Losses + 
                    score_Ambig_Gains + score_Ambig_Losses, data = data)
cat("\nModèle: Craintes ~ Aversions\n")
print(summary(model_craint))

# ============================================================================
# RAPPORT FINAL
# ============================================================================

cat("\n", rep("=", 78), "\n", sep = "")
cat("ANALYSE TERMINÉE\n")
cat(rep("=", 78), "\n\n", sep = "")

cat("Tous les résultats ont été sauvegardés dans le dossier 'resultats/'\n")
cat("Fichiers générés:\n")
cat("  - correlation_matrix.png\n")
cat("  - distribution_aversions.png\n")
cat("  - distribution_perceptions.png\n")
cat("  - benefices_vs_craintes.png\n")
cat("  - boxplots_scores.png\n")
cat("  - sem_results.txt\n")
cat("  - sem_model_fit.rds\n\n")

cat("Pour recharger le modèle SEM ultérieurement:\n")
cat("  fit <- readRDS('resultats/sem_model_fit.rds')\n\n")
