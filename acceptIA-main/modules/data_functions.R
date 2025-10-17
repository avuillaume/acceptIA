# ============================================================================
# FONCTIONS DE GESTION DES DONNÉES
# ============================================================================

# Charger le package MongoDB
if (!require("mongolite")) install.packages("mongolite")
library(mongolite)

# ============================================================================
# FONCTIONS MONGODB
# ============================================================================

# Fonction pour obtenir la connexion MongoDB
get_mongo_connection <- function() {
  # Connection string MongoDB Atlas
  mongo_uri <- "mongodb+srv://vuillaumeanthony_db_user:y4IRDyem6180yh7I@cluster0.zaf44u9.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
  
  # Se connecter à la collection "participants"
  mongo(
    collection = "participants",
    db = "acceptia_study",
    url = mongo_uri
  )
}

# Fonction pour sauvegarder les données d'un participant dans MongoDB
save_participant_data_mongo <- function(rv) {
  tryCatch({
    # Connexion à MongoDB
    participants_collection <- get_mongo_connection()
    
    # Préparer les données du participant
    data_row <- data.frame(
      # Métadonnées
      participant_id = rv$participant_id,
      timestamp = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      
      # Randomisation
      benefices_first = rv$benefices_first,
      usages_sante_first = rv$usages_sante_first,
      
      # Tâche de comptage
      digit_to_count = rv$digit_to_count,
      correct_count = rv$correct_count,
      
      stringsAsFactors = FALSE
    )
    
    # Ajouter toutes les données collectées depuis rv$participant_data
    for (name in names(rv$participant_data)) {
      if (!(name %in% names(data_row))) {
        value <- rv$participant_data[[name]]
        # Convertir NULL en NA
        if (is.null(value)) value <- NA
        data_row[[name]] <- value
      }
    }
    
    # Ajouter les flags des sections optionnelles
    data_row$show_section_8 <- rv$show_section_8
    data_row$show_section_9 <- rv$show_section_9
    data_row$show_section_10 <- rv$show_section_10
    data_row$show_section_11 <- rv$show_section_11
    
    # Ajouter les résultats de la loterie
    if (!is.null(rv$lottery_results)) {
      data_row$lottery_selected_type <- rv$lottery_results$selected_grille$type
      data_row$lottery_selected_optional <- rv$lottery_results$selected_grille$optional
      data_row$lottery_final_payoff <- rv$lottery_results$final_payoff
    }
    
    # Insérer dans MongoDB
    participants_collection$insert(data_row)
    
    cat("✓ Participant", rv$participant_id, "sauvegardé dans MongoDB\n")
    return(TRUE)
    
  }, error = function(e) {
    cat("✗ ERREUR lors de la sauvegarde MongoDB:", e$message, "\n")
    warning("Impossible de sauvegarder dans MongoDB: ", e$message)
    return(FALSE)
  })
}

# Fonction pour récupérer tous les participants depuis MongoDB
get_all_participants_mongo <- function() {
  tryCatch({
    participants_collection <- get_mongo_connection()
    all_data <- participants_collection$find('{}')
    return(all_data)
  }, error = function(e) {
    warning("Impossible de récupérer les données MongoDB: ", e$message)
    return(NULL)
  })
}

# Fonction pour compter le nombre de participants dans MongoDB
count_participants_mongo <- function() {
  tryCatch({
    participants_collection <- get_mongo_connection()
    count <- participants_collection$count('{}')
    return(count)
  }, error = function(e) {
    warning("Impossible de compter les participants: ", e$message)
    return(0)
  })
}

# ============================================================================
# FONCTIONS TRADITIONNELLES (CSV) - Conservées pour backup local
# ============================================================================

# Fonction pour créer la structure des données
create_data_structure <- function() {
  data_structure <- list(
    # Métadonnées
    participant_id = character(),
    timestamp = character(),
    
    # Aversions (4 x 3 questions)
    RG1 = numeric(), RG2 = numeric(), RG3 = numeric(),
    RP1 = numeric(), RP2 = numeric(), RP3 = numeric(),
    AG1 = numeric(), AG2 = numeric(), AG3 = numeric(),
    AP1 = numeric(), AP2 = numeric(), AP3 = numeric(),
    
    # Usages numériques
    usage_freq_1 = character(),
    usage_freq_2 = character(),
    usage_freq_3 = character(),
    usage_freq_4 = character(),
    usage_freq_5 = character(),
    usage_freq_6 = character(),
    usage_freq_7 = character(),
    connaissance_ia = character(),
    opinion_ia = character(),
    raisons_usage = character(),
    freins_usage = character(),
    
    # Santé
    activite_physique = character(),
    fruits_legumes = character(),
    produits_transformes = character(),
    alcool = character(),
    gestion_stress = character(),
    sommeil = character(),
    tabac = character(),
    bilan_sante = character(),
    depistage_organise = character(),
    depistage_volontaire = character(),
    
    # IA en santé - Bénéfices (10 items)
    B1 = numeric(), B2 = numeric(), B3 = numeric(), B4 = numeric(), B5 = numeric(),
    B6 = numeric(), B7 = numeric(), B8 = numeric(), B9 = numeric(), B10 = numeric(),
    
    # IA en santé - Craintes (10 items)
    C1 = numeric(), C2 = numeric(), C3 = numeric(), C4 = numeric(), C5 = numeric(),
    C6 = numeric(), C7 = numeric(), C8 = numeric(), C9 = numeric(), C10 = numeric(),
    
    # Usages numériques en santé
    teleconsult_usage = character(),
    teleconsult_motiv = character(),
    doctolib_usage = character(),
    doctolib_type = character(),
    doctolib_documents = character(),
    doctolib_medecin = character(),
    ens_connaissance = character(),
    ens_opinion = character(),
    carte_vitale = character(),
    objets_connectes = character(),
    chatbot_sante = character(),
    
    # Sociodémographiques
    age = numeric(),
    sexe = character(),
    education = character(),
    situation_pro = character(),
    taille_ville = character(),
    enfants = character(),
    en_couple = character()
  )
  
  return(data_structure)
}

# Fonction pour nettoyer et préparer les données pour l'analyse
prepare_data_for_analysis <- function(raw_data) {
  
  # Convertir les variables catégorielles en facteurs
  categorical_vars <- c(
    "connaissance_ia", "opinion_ia",
    "activite_physique", "fruits_legumes", "produits_transformes",
    "alcool", "gestion_stress", "sommeil", "tabac",
    "bilan_sante", "depistage_organise", "depistage_volontaire",
    "teleconsult_usage", "doctolib_usage", "ens_connaissance",
    "carte_vitale", "objets_connectes", "chatbot_sante",
    "sexe", "education", "situation_pro", "taille_ville",
    "enfants", "en_couple"
  )
  
  for (var in categorical_vars) {
    if (var %in% names(raw_data)) {
      raw_data[[var]] <- as.factor(raw_data[[var]])
    }
  }
  
  # Convertir les variables d'usage en numériques si nécessaire
  freq_mapping <- c(
    "Jamais" = 0,
    "Moins d'une fois par mois" = 1,
    "Environ une fois par mois" = 2,
    "Environ une fois par semaine" = 3,
    "Plusieurs fois par semaine" = 4,
    "Environ une fois par jour" = 5,
    "Plusieurs fois par jour" = 6
  )
  
  for (i in 1:7) {
    var_name <- paste0("usage_freq_", i)
    if (var_name %in% names(raw_data)) {
      raw_data[[paste0(var_name, "_num")]] <- freq_mapping[raw_data[[var_name]]]
    }
  }
  
  return(raw_data)
}

# Fonction pour générer un résumé des données collectées
generate_data_summary <- function(data) {
  summary_list <- list()
  
  # Nombre de participants
  summary_list$n_participants <- nrow(data)
  
  # Distribution par sexe
  if ("sexe" %in% names(data)) {
    summary_list$sexe_distribution <- table(data$sexe)
  }
  
  # Âge moyen
  if ("age" %in% names(data)) {
    summary_list$age_mean <- mean(data$age, na.rm = TRUE)
    summary_list$age_sd <- sd(data$age, na.rm = TRUE)
    summary_list$age_range <- range(data$age, na.rm = TRUE)
  }
  
  # Scores moyens d'aversion
  aversion_vars <- c("RG1", "RG2", "RG3", "RP1", "RP2", "RP3",
                     "AG1", "AG2", "AG3", "AP1", "AP2", "AP3")
  if (all(aversion_vars %in% names(data))) {
    summary_list$aversion_means <- colMeans(data[, aversion_vars], na.rm = TRUE)
  }
  
  # Scores moyens de perception
  benefice_vars <- paste0("B", 1:10)
  crainte_vars <- paste0("C", 1:10)
  
  if (all(benefice_vars %in% names(data))) {
    summary_list$benefices_mean <- mean(rowMeans(data[, benefice_vars], na.rm = TRUE), 
                                       na.rm = TRUE)
  }
  
  if (all(crainte_vars %in% names(data))) {
    summary_list$craintes_mean <- mean(rowMeans(data[, crainte_vars], na.rm = TRUE), 
                                      na.rm = TRUE)
  }
  
  return(summary_list)
}

# Fonction pour exporter les données en différents formats
export_data <- function(data, format = "csv", filename = NULL) {
  
  if (is.null(filename)) {
    filename <- paste0("study_data_export_", format(Sys.Date(), "%Y%m%d"))
  }
  
  if (format == "csv") {
    write.csv(data, paste0(filename, ".csv"), row.names = FALSE)
  } else if (format == "rdata") {
    study_data <- data
    save(study_data, file = paste0(filename, ".RData"))
  } else if (format == "excel") {
    if (requireNamespace("writexl", quietly = TRUE)) {
      writexl::write_xlsx(data, paste0(filename, ".xlsx"))
    } else {
      warning("Package 'writexl' not installed. Cannot export to Excel.")
    }
  }
  
  return(invisible(TRUE))
}

# Fonction pour créer des visualisations de base
create_basic_visualizations <- function(data) {
  
  plots <- list()
  
  # Distribution des scores d'aversion
  if (all(c("RG1", "RG2", "RG3") %in% names(data))) {
    data$score_Risk_Gains <- rowMeans(data[, c("RG1", "RG2", "RG3")], na.rm = TRUE)
    data$score_Risk_Losses <- rowMeans(data[, c("RP1", "RP2", "RP3")], na.rm = TRUE)
    data$score_Ambig_Gains <- rowMeans(data[, c("AG1", "AG2", "AG3")], na.rm = TRUE)
    data$score_Ambig_Losses <- rowMeans(data[, c("AP1", "AP2", "AP3")], na.rm = TRUE)
    
    # Histogrammes des scores
    plots$aversion_hist <- ggplot(data) +
      geom_histogram(aes(x = score_Risk_Gains), fill = "steelblue", alpha = 0.7, bins = 10) +
      labs(title = "Distribution du score Risque - Gains",
           x = "Score", y = "Fréquence") +
      theme_minimal()
  }
  
  # Distribution des scores de perception
  if (all(paste0("B", 1:10) %in% names(data))) {
    data$score_Benefices <- rowMeans(data[, paste0("B", 1:10)], na.rm = TRUE)
    
    plots$benefices_hist <- ggplot(data) +
      geom_histogram(aes(x = score_Benefices), fill = "forestgreen", alpha = 0.7, bins = 10) +
      labs(title = "Distribution du score Bénéfices perçus",
           x = "Score (1-7)", y = "Fréquence") +
      theme_minimal()
  }
  
  if (all(paste0("C", 1:10) %in% names(data))) {
    data$score_Craintes <- rowMeans(data[, paste0("C", 1:10)], na.rm = TRUE)
    
    plots$craintes_hist <- ggplot(data) +
      geom_histogram(aes(x = score_Craintes), fill = "coral", alpha = 0.7, bins = 10) +
      labs(title = "Distribution du score Craintes",
           x = "Score (1-7)", y = "Fréquence") +
      theme_minimal()
  }
  
  # Scatter plot Bénéfices vs Craintes
  if ("score_Benefices" %in% names(data) && "score_Craintes" %in% names(data)) {
    plots$benef_craint_scatter <- ggplot(data, aes(x = score_Benefices, y = score_Craintes)) +
      geom_point(alpha = 0.6, color = "purple") +
      geom_smooth(method = "lm", color = "red", se = TRUE) +
      labs(title = "Relation entre Bénéfices perçus et Craintes",
           x = "Bénéfices perçus (1-7)", y = "Craintes (1-7)") +
      theme_minimal()
  }
  
  return(plots)
}

# Fonction pour vérifier la qualité des données
check_data_quality <- function(data) {
  
  quality_report <- list()
  
  # Taux de données manquantes par variable
  missing_rates <- colSums(is.na(data)) / nrow(data) * 100
  quality_report$missing_rates <- missing_rates[missing_rates > 0]
  
  # Variables avec trop de données manquantes (>20%)
  quality_report$high_missing_vars <- names(missing_rates[missing_rates > 20])
  
  # Vérifier les valeurs aberrantes pour l'âge
  if ("age" %in% names(data)) {
    quality_report$age_outliers <- sum(data$age < 18 | data$age > 120, na.rm = TRUE)
  }
  
  # Vérifier la cohérence des réponses Likert (doivent être entre 1 et 7)
  likert_vars <- c(paste0("B", 1:10), paste0("C", 1:10))
  likert_data <- data[, likert_vars[likert_vars %in% names(data)]]
  quality_report$likert_out_of_range <- sum(likert_data < 1 | likert_data > 7, na.rm = TRUE)
  
  return(quality_report)
}
