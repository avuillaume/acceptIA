# ============================================================================
# FONCTIONS SERVEUR ET UTILITAIRES
# ============================================================================

# Fonction pour compter les occurrences d'un chiffre dans les décimales de π
count_digit_in_pi <- function(digit) {
  # Décimales de π (200 premières avec les nouvelles décimales ajoutées)
  pi_decimals <- "14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196"
  
  # Compter les occurrences du chiffre
  count <- sum(strsplit(pi_decimals, "")[[1]] == as.character(digit))
  return(count)
}

# Fonction pour initialiser la tâche de comptage avec un chiffre aléatoire
initialize_counting_task <- function() {
  # Choisir un chiffre aléatoire entre 0 et 9
  digit <- sample(0:9, 1)
  
  # Compter les occurrences de ce chiffre
  correct_count <- count_digit_in_pi(digit)
  
  return(list(
    digit = digit,
    correct_count = correct_count
  ))
}

# Fonction de validation des sections
validate_current_section <- function(input, section, rv = NULL) {
  
  # Section 0 : Consentement (déjà géré)
  if (section == 0) return(TRUE)
  
  # Section 1 : Introduction tâches d'aversion (pas de validation nécessaire)
  if (section == 1) return(TRUE)
  
  # Section 2 : Tâche de comptage - Validation stricte avec la bonne réponse
  if (section == 2) {
    if (is.null(input$comptage_pi) || is.na(input$comptage_pi)) {
      return(FALSE)
    }
    
    # Vérifier la bonne réponse selon le chiffre randomisé
    if (!is.null(rv) && !is.null(rv$digit_to_count)) {
      correct_answer <- rv$correct_count
      is_correct <- (input$comptage_pi == correct_answer)
      
      # Mettre à jour le flag d'erreur
      rv$counting_error <- !is_correct
      
      return(is_correct)
    }
    
    return(FALSE)
  }
  
  # Section 3 : Félicitations (pas de validation nécessaire)
  if (section == 3) return(TRUE)
  
  # Section 4 : Risque Gains (les sliders ont toujours une valeur)
  if (section == 4) return(TRUE)
  
  # Section 5 : Risque Pertes (les sliders ont toujours une valeur)
  if (section == 5) return(TRUE)
  
  # Section 6 : Ambiguïté Gains (les sliders ont toujours une valeur)
  if (section == 6) return(TRUE)
  
  # Section 7 : Ambiguïté Pertes (les sliders ont toujours une valeur)
  if (section == 7) return(TRUE)
  
  # Section 8 : Introduction questionnaire (pas de validation nécessaire)
  if (section == 8) return(TRUE)
  
  # Section 9 : Usages numériques
  if (section == 9) {
    freq_answered <- all(sapply(1:7, function(i) {
      !is.null(input[[paste0("usage_freq_", i)]]) && 
        input[[paste0("usage_freq_", i)]] != ""
    }))
    
    connaissance_ok <- !is.null(input$connaissance_ia) && input$connaissance_ia != ""
    opinion_ok <- !is.null(input$opinion_ia) && input$opinion_ia != ""
    raisons_ok <- !is.null(input$raisons_usage) && length(input$raisons_usage) > 0 && 
      length(input$raisons_usage) <= 3
    freins_ok <- !is.null(input$freins_usage) && length(input$freins_usage) > 0 && 
      length(input$freins_usage) <= 3
    
    return(freq_answered && connaissance_ok && opinion_ok && raisons_ok && freins_ok)
  }
  
  # Section 10 : Santé
  if (section == 10) {
    sante_vars <- c(
      "activite_physique", "fruits_legumes", "produits_transformes",
      "alcool", "gestion_stress", "sommeil", "tabac",
      "bilan_sante", "depistage_organise", "depistage_volontaire"
    )
    
    all_answered <- all(sapply(sante_vars, function(var) {
      !is.null(input[[var]]) && input[[var]] != ""
    }))
    return(all_answered)
  }
  
  # Section 11 : IA en santé - Bénéfices perçus
  if (section == 11) {
    # Les sliders ont toujours une valeur par défaut, donc considéré comme valide
    return(TRUE)
  }
  
  # Section 12 : IA en santé - Craintes
  if (section == 12) {
    # Les sliders ont toujours une valeur par défaut, donc considéré comme valide
    return(TRUE)
  }
  
  # Section 13 : Usages numériques en santé
  if (section == 13) {
    teleconsult_ok <- !is.null(input$teleconsult_usage) && input$teleconsult_usage != ""
    doctolib_ok <- !is.null(input$doctolib_usage) && input$doctolib_usage != ""
    ens_ok <- !is.null(input$ens_connaissance) && input$ens_connaissance != ""
    carte_vitale_ok <- !is.null(input$carte_vitale) && input$carte_vitale != ""
    objets_ok <- !is.null(input$objets_connectes) && input$objets_connectes != ""
    chatbot_ok <- !is.null(input$chatbot_sante) && input$chatbot_sante != ""
    
    return(teleconsult_ok && doctolib_ok && ens_ok && carte_vitale_ok && 
             objets_ok && chatbot_ok)
  }
  
  # Section 14 : Sociodémographiques
  if (section == 14) {
    age_ok <- !is.null(input$age) && !is.na(input$age) && input$age >= 18
    sexe_ok <- !is.null(input$sexe) && input$sexe != ""
    education_ok <- !is.null(input$education) && input$education != ""
    situation_ok <- !is.null(input$situation_pro) && input$situation_pro != ""
    ville_ok <- !is.null(input$taille_ville) && input$taille_ville != ""
    enfants_ok <- !is.null(input$enfants) && input$enfants != ""
    couple_ok <- !is.null(input$en_couple) && input$en_couple != ""
    
    return(age_ok && sexe_ok && education_ok && situation_ok && 
             ville_ok && enfants_ok && couple_ok)
  }
  
  return(TRUE)
}

# Fonction pour sauvegarder les données d'une section
save_section_data <- function(input, section, rv) {
  
  # Section 2 : Tâche de comptage
  if (section == 2) {
    rv$participant_data$comptage_pi <- input$comptage_pi
    rv$participant_data$digit_to_count <- rv$digit_to_count
    rv$participant_data$correct_count <- rv$correct_count
  }
  
  # Section 4 : Risque Gains
  if (section == 4) {
    rv$participant_data$risque_gains_invest <- input$risque_gains_invest
  }
  
  # Section 5 : Risque Pertes
  if (section == 5) {
    rv$participant_data$risque_pertes_invest <- input$risque_pertes_invest
  }
  
  # Section 6 : Ambiguïté Gains
  if (section == 6) {
    rv$participant_data$ambiguite_gains_invest <- input$ambiguite_gains_invest
  }
  
  # Section 7 : Ambiguïté Pertes
  if (section == 7) {
    rv$participant_data$ambiguite_pertes_invest <- input$ambiguite_pertes_invest
  }
  
  # Section 9 : Usages numériques
  if (section == 9) {
    # Fréquences d'usage
    for (i in 1:7) {
      rv$participant_data[[paste0("usage_freq_", i)]] <- input[[paste0("usage_freq_", i)]]
    }
    rv$participant_data$connaissance_ia <- input$connaissance_ia
    rv$participant_data$opinion_ia <- input$opinion_ia
    rv$participant_data$raisons_usage <- paste(input$raisons_usage, collapse = ";")
    rv$participant_data$freins_usage <- paste(input$freins_usage, collapse = ";")
  }
  
  # Section 10 : Santé
  if (section == 10) {
    sante_vars <- c(
      "activite_physique", "fruits_legumes", "produits_transformes",
      "alcool", "gestion_stress", "sommeil", "tabac",
      "bilan_sante", "depistage_organise", "depistage_volontaire"
    )
    
    for (var in sante_vars) {
      rv$participant_data[[var]] <- input[[var]]
    }
  }
  
  # Section 11 : IA en santé - Bénéfices perçus
  if (section == 11) {
    # Bénéfices
    for (i in 1:10) {
      rv$participant_data[[paste0("B", i)]] <- input[[paste0("B", i)]]
    }
  }
  
  # Section 12 : IA en santé - Craintes
  if (section == 12) {
    # Craintes
    for (i in 1:10) {
      rv$participant_data[[paste0("C", i)]] <- input[[paste0("C", i)]]
    }
  }
  
  # Section 13 : Usages numériques en santé
  if (section == 13) {
    usages_sante_vars <- c(
      "teleconsult_usage", "teleconsult_motiv",
      "doctolib_usage", "doctolib_type", "doctolib_documents", "doctolib_medecin",
      "ens_connaissance", "ens_opinion",
      "carte_vitale",
      "objets_connectes", "chatbot_sante"
    )
    
    for (var in usages_sante_vars) {
      if (var == "teleconsult_motiv") {
        rv$participant_data[[var]] <- paste(input[[var]], collapse = ";")
      } else {
        rv$participant_data[[var]] <- input[[var]]
      }
    }
  }
  
  # Section 14 : Sociodémographiques
  if (section == 14) {
    socio_vars <- c(
      "age", "sexe", "education", "situation_pro",
      "taille_ville", "enfants", "en_couple"
    )
    
    for (var in socio_vars) {
      rv$participant_data[[var]] <- input[[var]]
    }
  }
}

# Fonction pour sauvegarder toutes les données du participant
save_participant_data <- function(rv) {
  
  # Créer le dossier data s'il n'existe pas
  if (!dir.exists("data")) {
    dir.create("data")
  }
  
  # Ajouter l'ID du participant et l'horodatage
  rv$participant_data$participant_id <- rv$participant_id
  rv$participant_data$timestamp <- Sys.time()
  
  # Ajouter l'ordre de randomisation Bénéfices/Craintes
  rv$participant_data$benefices_first <- rv$benefices_first
  rv$participant_data$ordre_IA <- ifelse(rv$benefices_first, "Benefices_puis_Craintes", "Craintes_puis_Benefices")
  
  # Convertir en data frame
  new_data <- as.data.frame(rv$participant_data, stringsAsFactors = FALSE)
  
  # Charger les données existantes si le fichier existe
  data_file <- "data/study_data.csv"
  
  if (file.exists(data_file)) {
    existing_data <- read.csv(data_file, stringsAsFactors = FALSE)
    # Combiner avec les nouvelles données
    all_data <- bind_rows(existing_data, new_data)
  } else {
    all_data <- new_data
  }
  
  # Sauvegarder
  write.csv(all_data, data_file, row.names = FALSE)
  
  # Sauvegarder aussi en RData
  study_data <- all_data
  save(study_data, file = "data/study_data.RData")
  
  return(invisible(TRUE))
}

# Fonction pour calculer les scores composites
calculate_composite_scores <- function(data) {
  
  # Scores d'aversion
  data$score_Risk_Gains <- rowMeans(data[, c("RG1", "RG2", "RG3")], na.rm = TRUE)
  data$score_Risk_Losses <- rowMeans(data[, c("RP1", "RP2", "RP3")], na.rm = TRUE)
  data$score_Ambig_Gains <- rowMeans(data[, c("AG1", "AG2", "AG3")], na.rm = TRUE)
  data$score_Ambig_Losses <- rowMeans(data[, c("AP1", "AP2", "AP3")], na.rm = TRUE)
  
  # Scores de perception (moyenne des 10 items disponibles)
  data$score_Benefices <- rowMeans(data[, paste0("B", 1:10)], na.rm = TRUE)
  data$score_Craintes <- rowMeans(data[, paste0("C", 1:10)], na.rm = TRUE)
  
  return(data)
}

# Fonction pour générer un rapport descriptif
generate_descriptive_report <- function(data) {
  
  # Calculer les scores composites
  data <- calculate_composite_scores(data)
  
  # Statistiques descriptives
  desc_stats <- data %>%
    select(starts_with("score_")) %>%
    summarise(across(everything(), list(
      n = ~sum(!is.na(.)),
      mean = ~mean(., na.rm = TRUE),
      sd = ~sd(., na.rm = TRUE),
      min = ~min(., na.rm = TRUE),
      max = ~max(., na.rm = TRUE)
    )))
  
  return(desc_stats)
}

# Fonction pour exécuter le modèle SEM complet
run_full_sem_model <- function(data) {
  
  # Modèle SEM complet basé sur le document
  model <- '
    # Measurement model
    Risk_Gains =~ RG1 + RG2 + RG3
    Risk_Losses =~ RP1 + RP2 + RP3
    Ambig_Gains =~ AG1 + AG2 + AG3
    Ambig_Losses =~ AP1 + AP2 + AP3
    
    Benefices =~ B1 + B2 + B3 + B4 + B5 + B6 + B7 + B8 + B9 + B10
    Craintes =~ C1 + C2 + C3 + C4 + C5 + C6 + C7 + C8 + C9 + C10
    
    # Structural regressions
    Benefices ~ a1*Risk_Gains + a2*Risk_Losses + a3*Ambig_Gains + a4*Ambig_Losses
    Craintes ~ b1*Risk_Gains + b2*Risk_Losses + b3*Ambig_Gains + b4*Ambig_Losses
    
    # Indirect effects (examples)
    ind_ag_benef := a3
    ind_ag_craint := b3
    ind_al_craint := b4
  '
  
  # Estimer le modèle
  fit <- tryCatch({
    lavaan::sem(model, data = data, estimator = "MLR", missing = "fiml")
  }, error = function(e) {
    message("Erreur dans l'estimation du modèle SEM : ", e$message)
    return(NULL)
  })
  
  return(fit)
}
