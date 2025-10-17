# ============================================================================
# FONCTIONS SERVEUR ET UTILITAIRES
# ============================================================================

# ============================================================================
# FONCTIONS DE TIRAGE AU SORT ET CALCUL DES GAINS
# ============================================================================

# Fonction pour sélectionner aléatoirement une grille parmi celles complétées
select_random_grille <- function(rv) {
  # Collecter toutes les grilles complétées avec leurs infos
  completed_grilles <- list()
  
  # Grilles obligatoires (toujours complétées)
  for (i in 1:4) {
    type <- rv$order_grilles_obligatoires[i]
    input_name <- get_input_name_for_type(type, optional = FALSE)
    value <- rv$participant_data[[input_name]]
    
    completed_grilles[[length(completed_grilles) + 1]] <- list(
      type = type,
      optional = FALSE,
      decision_number = i,
      response = value
    )
  }
  
  # Grilles optionnelles (si complétées)
  if (!is.null(rv$order_grilles_optionnelles)) {
    for (i in 1:length(rv$order_grilles_optionnelles)) {
      type <- rv$order_grilles_optionnelles[i]
      input_name <- get_input_name_for_type(type, optional = TRUE)
      value <- rv$participant_data[[input_name]]
      
      if (!is.null(value) && !is.na(value)) {
        completed_grilles[[length(completed_grilles) + 1]] <- list(
          type = type,
          optional = TRUE,
          decision_number = 4 + i,
          response = value
        )
      }
    }
  }
  
  # Sélectionner aléatoirement une grille
  selected_index <- sample(1:length(completed_grilles), 1)
  return(completed_grilles[[selected_index]])
}

# Fonction pour effectuer le tirage au sort selon le type de grille et la réponse
perform_lottery <- function(selected_grille) {
  type <- selected_grille$type
  response <- selected_grille$response
  optional <- selected_grille$optional
  
  if (!optional) {
    # Grilles obligatoires : réponse = investissement (0-10)
    investment <- as.numeric(response)
    kept_tokens <- 10 - investment  # Jetons gardés (certain)
    
    # Déterminer le gain/perte selon le type
    if (grepl("gains", type)) {
      # Gains : 50% chance de doubler l'investissement
      lottery_result <- sample(c(TRUE, FALSE), 1)  # TRUE = succès
      if (lottery_result) {
        lottery_tokens <- investment * 2  # Double
      } else {
        lottery_tokens <- 0  # Rien
      }
      net_change <- kept_tokens + lottery_tokens - 10  # Changement par rapport aux 10 de départ
    } else {
      # Pertes : 50% chance de perdre l'investissement
      lottery_result <- sample(c(TRUE, FALSE), 1)  # TRUE = perte
      if (lottery_result) {
        lottery_tokens <- -investment  # Perd l'investissement
      } else {
        lottery_tokens <- 0  # Ne perd rien
      }
      net_change <- kept_tokens + lottery_tokens - 10
    }
    
    return(list(
      lottery_result = lottery_result,
      kept_tokens = kept_tokens,
      lottery_tokens = lottery_tokens,
      net_change = net_change
    ))
    
  } else {
    # Grilles optionnelles : réponse = choix d'urne (A/B/C/D/E)
    choice <- response
    
    # Définir les urnes selon le type et le choix
    lottery_result <- perform_urn_lottery(type, choice)
    
    return(lottery_result)
  }
}

# Fonction pour effectuer un tirage d'urne (grilles optionnelles)
perform_urn_lottery <- function(type, choice) {
  # Définir les compositions d'urnes et résultats selon le type et le choix
  
  if (type == "risque_gains") {
    # Décision 5 : Risque Gains 2
    urns <- list(
      A = list(yellow = 60, purple = 0, blue = 0, 
               outcomes = list(yellow = 10, purple = 0, blue = 0)),
      B = list(yellow = 30, purple = 30, blue = 0,
               outcomes = list(yellow = 5, purple = 15, blue = 0)),
      C = list(yellow = 20, purple = 20, blue = 20,
               outcomes = list(yellow = 5, purple = 15, blue = 10)),
      D = list(yellow = 30, purple = 30, blue = 0,
               outcomes = list(yellow = 0, purple = 20, blue = 0))
    )
  } else if (type == "risque_pertes") {
    # Décision 6 : Risque Pertes 2
    urns <- list(
      A = list(yellow = 60, purple = 0, blue = 0,
               outcomes = list(yellow = -10, purple = 0, blue = 0)),
      B = list(yellow = 30, purple = 30, blue = 0,
               outcomes = list(yellow = -5, purple = -15, blue = 0)),
      C = list(yellow = 20, purple = 20, blue = 20,
               outcomes = list(yellow = -5, purple = -15, blue = -10)),
      D = list(yellow = 30, purple = 30, blue = 0,
               outcomes = list(yellow = 0, purple = -20, blue = 0))
    )
  } else if (type == "ambiguite_gains") {
    # Décision 7 : Ambiguïté Gains 2
    urns <- list(
      A = list(yellow = 60, purple = 0, blue = 0,
               outcomes = list(yellow = 10, purple = 0, blue = 0)),
      B = list(yellow = NA, purple = NA, blue = 0,  # Nombre inconnu
               outcomes = list(yellow = 5, purple = 15, blue = 0)),
      C = list(yellow = NA, purple = NA, blue = NA,  # Nombre inconnu
               outcomes = list(yellow = 5, purple = 10, blue = 15)),
      D = list(yellow = NA, purple = NA, blue = 0,
               outcomes = list(yellow = 0, purple = 20, blue = 0))
    )
  } else if (type == "ambiguite_pertes") {
    # Décision 8 : Ambiguïté Pertes 2
    urns <- list(
      A = list(yellow = 60, purple = 0, blue = 0,
               outcomes = list(yellow = -10, purple = 0, blue = 0)),
      B = list(yellow = NA, purple = NA, blue = 0,
               outcomes = list(yellow = -5, purple = -15, blue = 0)),
      C = list(yellow = NA, purple = NA, blue = NA,
               outcomes = list(yellow = -5, purple = -10, blue = -15)),
      D = list(yellow = NA, purple = NA, blue = 0,
               outcomes = list(yellow = 0, purple = -20, blue = 0))
    )
  }
  
  urn <- urns[[choice]]
  outcomes <- urn$outcomes
  
  # Pour les urnes avec ambiguïté, utiliser les mêmes proportions que pour le risque
  # (le participant ne connaît pas les proportions, mais elles sont identiques)
  if (is.na(urn$yellow)) {
    # Ambiguïté : utiliser les mêmes proportions que dans les cas "risque"
    if (is.na(urn$blue)) {
      # 3 couleurs inconnues : 20/20/20 (comme dans risque)
      urn$yellow <- 20
      urn$purple <- 20
      urn$blue <- 20
    } else {
      # 2 couleurs inconnues (jaune et violet) : 30/30 (comme dans risque)
      urn$yellow <- 30
      urn$purple <- 30
    }
  }
  
  # Effectuer le tirage
  balls <- c(rep("yellow", urn$yellow), 
             rep("purple", urn$purple), 
             rep("blue", urn$blue))
  drawn_color <- sample(balls, 1)
  
  # Obtenir le résultat
  net_change <- outcomes[[drawn_color]]
  
  return(list(
    urn_choice = choice,
    urn_composition = list(yellow = urn$yellow, purple = urn$purple, blue = urn$blue),
    drawn_color = drawn_color,
    net_change = net_change
  ))
}

# Fonction pour calculer les gains finaux
calculate_final_payoff <- function(lottery_result) {
  initial_tokens <- 30
  final_tokens <- initial_tokens + lottery_result$net_change
  return(final_tokens)
}

# Fonction principale pour exécuter tout le processus de tirage
execute_final_lottery <- function(rv) {
  # 1. Sélectionner une grille aléatoire
  selected_grille <- select_random_grille(rv)
  
  # 2. Effectuer le tirage au sort
  lottery_result <- perform_lottery(selected_grille)
  
  # 3. Calculer les gains finaux
  final_payoff <- calculate_final_payoff(lottery_result)
  
  # 4. Retourner toutes les informations
  return(list(
    selected_grille = selected_grille,
    lottery_result = lottery_result,
    final_payoff = final_payoff
  ))
}

# ============================================================================
# FONCTIONS DE RANDOMISATION ET MAPPING
# ============================================================================

# Fonction pour obtenir le type de grille pour une section donnée (4-7)
get_grille_type_for_section <- function(section, rv) {
  if (section >= 4 && section <= 7) {
    # Sections obligatoires randomisées
    index <- section - 3  # section 4 = index 1, section 5 = index 2, etc.
    return(rv$order_grilles_obligatoires[index])
  } else if (section >= 8 && section <= 11) {
    # Sections optionnelles randomisées
    # IMPORTANT : Les sections 8-11 ne sont pas séquentielles !
    # On doit compter combien de sections ACTIVÉES il y a AVANT la section actuelle
    
    if (is.null(rv$order_grilles_optionnelles) || length(rv$order_grilles_optionnelles) == 0) {
      return(NULL)
    }
    
    # Compter combien de sections actives il y a avant celle-ci
    active_count <- 0
    for (s in 8:section) {
      is_active <- switch(
        as.character(s),
        "8" = rv$show_section_8,
        "9" = rv$show_section_9,
        "10" = rv$show_section_10,
        "11" = rv$show_section_11,
        FALSE
      )
      if (is_active) {
        active_count <- active_count + 1
      }
    }
    
    # L'index dans order_grilles_optionnelles est le nombre de sections actives jusqu'à maintenant
    if (active_count > 0 && active_count <= length(rv$order_grilles_optionnelles)) {
      result <- rv$order_grilles_optionnelles[active_count]
      cat("get_grille_type_for_section(", section, "): active_count =", active_count, "→", result, "\n")
      return(result)
    } else {
      cat("get_grille_type_for_section(", section, "): ERROR - active_count =", active_count, 
          ", length(order) =", length(rv$order_grilles_optionnelles), "\n")
    }
  }
  return(NULL)
}

# Fonction pour obtenir l'UI correspondant à un type de grille obligatoire
get_ui_for_grille_type <- function(type, optional = FALSE) {
  if (optional) {
    # Grilles optionnelles (version 2)
    switch(type,
           "risque_gains" = section_risque_gains_2_ui(),
           "risque_pertes" = section_risque_pertes_2_ui(),
           "ambiguite_gains" = section_ambiguite_gains_2_ui(),
           "ambiguite_pertes" = section_ambiguite_pertes_2_ui(),
           NULL)
  } else {
    # Grilles obligatoires (version 1)
    switch(type,
           "risque_gains" = section_risque_gains_ui(),
           "risque_pertes" = section_risque_pertes_ui(),
           "ambiguite_gains" = section_ambiguite_gains_ui(),
           "ambiguite_pertes" = section_ambiguite_pertes_ui(),
           NULL)
  }
}

# Fonction pour obtenir le nom de l'input correspondant à un type de grille
get_input_name_for_type <- function(type, optional = FALSE) {
  if (optional) {
    # Grilles optionnelles - retournent le nom du choix radio
    switch(type,
           "risque_gains" = "risque_gains_2_choix",
           "risque_pertes" = "risque_pertes_2_choix",
           "ambiguite_gains" = "ambiguite_gains_2_choix",
           "ambiguite_pertes" = "ambiguite_pertes_2_choix",
           NULL)
  } else {
    # Grilles obligatoires - retournent le nom de l'investissement
    switch(type,
           "risque_gains" = "risque_gains_invest",
           "risque_pertes" = "risque_pertes_invest",
           "ambiguite_gains" = "ambiguite_gains_invest",
           "ambiguite_pertes" = "ambiguite_pertes_invest",
           NULL)
  }
}

# Fonction pour initialiser l'ordre des grilles optionnelles après la section 7
initialize_optional_grilles_order <- function(rv) {
  # Collecter les types de grilles optionnelles qui doivent être affichées
  optional_types <- c()
  
  if (rv$show_section_8) optional_types <- c(optional_types, "risque_gains")
  if (rv$show_section_9) optional_types <- c(optional_types, "risque_pertes")
  if (rv$show_section_10) optional_types <- c(optional_types, "ambiguite_gains")
  if (rv$show_section_11) optional_types <- c(optional_types, "ambiguite_pertes")
  
  # Randomiser l'ordre si plusieurs grilles optionnelles
  if (length(optional_types) > 1) {
    optional_types <- sample(optional_types)
  }
  
  return(optional_types)
}

# Fonction pour calculer le nombre effectif de sections affichées
calculate_effective_max_section <- function(rv) {
  # Total de base : 19 sections
  # Sections conditionnelles : 8, 9, 10, 11 (4 sections)
  base_max <- 19
  skipped_sections <- 0
  
  # Compter les sections sautées
  if (!rv$show_section_8) skipped_sections <- skipped_sections + 1
  if (!rv$show_section_9) skipped_sections <- skipped_sections + 1
  if (!rv$show_section_10) skipped_sections <- skipped_sections + 1
  if (!rv$show_section_11) skipped_sections <- skipped_sections + 1
  
  return(base_max - skipped_sections)
}

# Fonction pour calculer la position effective dans le parcours (pour la barre de progression)
calculate_effective_position <- function(current_section, rv) {
  # Compter combien de sections ont été effectivement vues jusqu'à maintenant
  position <- current_section
  
  # Soustraire les sections conditionnelles sautées avant la section actuelle
  if (current_section > 8 && !rv$show_section_8) position <- position - 1
  if (current_section > 9 && !rv$show_section_9) position <- position - 1
  if (current_section > 10 && !rv$show_section_10) position <- position - 1
  if (current_section > 11 && !rv$show_section_11) position <- position - 1
  
  return(position)
}

# Fonction pour déterminer la prochaine section en tenant compte des sections conditionnelles
next_section_logic <- function(current_section, rv) {
  next_sec <- current_section + 1
  
  # Boucle pour sauter toutes les sections conditionnelles désactivées consécutives
  while (next_sec >= 8 && next_sec <= 11) {
    should_show <- switch(
      as.character(next_sec),
      "8" = rv$show_section_8,
      "9" = rv$show_section_9,
      "10" = rv$show_section_10,
      "11" = rv$show_section_11,
      TRUE  # Si hors de 8-11, afficher
    )
    
    if (should_show) {
      break  # Cette section doit être affichée, on s'arrête
    } else {
      cat("Navigation: Saut de la section conditionnelle", next_sec, "(désactivée)\n")
      next_sec <- next_sec + 1  # Passer à la suivante
    }
  }
  
  return(next_sec)
}

# Fonction pour déterminer la section précédente en tenant compte des sections conditionnelles
previous_section_logic <- function(current_section, rv) {
  prev_sec <- current_section - 1
  
  # Boucle pour sauter toutes les sections conditionnelles désactivées consécutives (en arrière)
  while (prev_sec >= 8 && prev_sec <= 11) {
    should_show <- switch(
      as.character(prev_sec),
      "8" = rv$show_section_8,
      "9" = rv$show_section_9,
      "10" = rv$show_section_10,
      "11" = rv$show_section_11,
      TRUE  # Si hors de 8-11, afficher
    )
    
    if (should_show) {
      break  # Cette section doit être affichée, on s'arrête
    } else {
      cat("Navigation arrière: Saut de la section conditionnelle", prev_sec, "(désactivée)\n")
      prev_sec <- prev_sec - 1  # Retourner à la précédente
    }
  }
  
  return(prev_sec)
}

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
  
  # Sections 4-7 : Grilles obligatoires (les sliders ont toujours une valeur)
  if (section >= 4 && section <= 7) return(TRUE)
  
  # Sections 8-11 : Grilles optionnelles - Choix d'urnes (validation radio)
  if (section >= 8 && section <= 11) {
    # Vérifier si la section doit être affichée
    should_show <- switch(
      as.character(section),
      "8" = rv$show_section_8,
      "9" = rv$show_section_9,
      "10" = rv$show_section_10,
      "11" = rv$show_section_11,
      FALSE
    )
    
    # Si la section ne doit pas être affichée, validation automatique
    if (!should_show) {
      cat("Validation: Section", section, "désactivée → validation automatique\n")
      return(TRUE)
    }
    
    grille_type <- get_grille_type_for_section(section, rv)
    if (!is.null(grille_type)) {
      input_name <- get_input_name_for_type(grille_type, optional = TRUE)
      return(!is.null(input[[input_name]]) && input[[input_name]] != "")
    }
    return(TRUE)  # Si pas de grille à cette section, validation réussie
  }
  
  # Section 12 : Introduction questionnaire (pas de validation nécessaire)
  if (section == 12) return(TRUE)
  
  # Section 13 : Usages numériques
  if (section == 13) {
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
  
  # Section 14 : Santé
  if (section == 14) {
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
  
  # Sections 15-17 : IA/Usages santé (2 randomisations indépendantes)
  if (section >= 15 && section <= 17) {
    # Déterminer le type de section selon les 2 randomisations
    if (rv$usages_sante_first) {
      if (section == 15) {
        section_type <- "usages_sante"
      } else if (section == 16) {
        section_type <- ifelse(rv$benefices_first, "benefices", "craintes")
      } else {
        section_type <- ifelse(rv$benefices_first, "craintes", "benefices")
      }
    } else {
      if (section == 15) {
        section_type <- ifelse(rv$benefices_first, "benefices", "craintes")
      } else if (section == 16) {
        section_type <- ifelse(rv$benefices_first, "craintes", "benefices")
      } else {
        section_type <- "usages_sante"
      }
    }
    
    # Valider selon le type
    if (section_type == "benefices" || section_type == "craintes") {
      return(TRUE)  # Les sliders ont une valeur par défaut
    } else if (section_type == "usages_sante") {
      teleconsult_ok <- !is.null(input$teleconsult_usage) && input$teleconsult_usage != ""
      doctolib_ok <- !is.null(input$doctolib_usage) && input$doctolib_usage != ""
      ens_ok <- !is.null(input$ens_connaissance) && input$ens_connaissance != ""
      carte_vitale_ok <- !is.null(input$carte_vitale) && input$carte_vitale != ""
      objets_ok <- !is.null(input$objets_connectes) && input$objets_connectes != ""
      chatbot_ok <- !is.null(input$chatbot_sante) && input$chatbot_sante != ""
      
      return(teleconsult_ok && doctolib_ok && ens_ok && carte_vitale_ok && 
               objets_ok && chatbot_ok)
    }
  }
  
  # Section 18 : Sociodémographiques
  if (section == 18) {
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
  
  # Sections 4-7 : Grilles obligatoires (sauvegarder selon le type de grille)
  if (section >= 4 && section <= 7) {
    grille_type <- get_grille_type_for_section(section, rv)
    input_name <- get_input_name_for_type(grille_type, optional = FALSE)
    
    # Sauvegarder la valeur de l'investissement
    rv$participant_data[[input_name]] <- input[[input_name]]
    
    # Sauvegarder l'ordre de présentation
    position <- section - 3  # position 1-4
    rv$participant_data[[paste0("grille_obligatoire_", position, "_type")]] <- grille_type
    
    # Déterminer si la grille optionnelle correspondante doit être affichée
    cat("Section", section, "→ Type:", grille_type, "→ Investissement:", input[[input_name]], "\n")
    
    if (grille_type == "risque_gains") {
      rv$show_section_8 <- (input[[input_name]] == 10)
      cat("  → show_section_8 =", rv$show_section_8, "(investissement = 10 ?)\n")
    } else if (grille_type == "risque_pertes") {
      rv$show_section_9 <- (input[[input_name]] == 0)
      cat("  → show_section_9 =", rv$show_section_9, "(investissement = 0 ?)\n")
    } else if (grille_type == "ambiguite_gains") {
      rv$show_section_10 <- (input[[input_name]] == 10)
      cat("  → show_section_10 =", rv$show_section_10, "(investissement = 10 ?)\n")
    } else if (grille_type == "ambiguite_pertes") {
      rv$show_section_11 <- (input[[input_name]] == 0)
      cat("  → show_section_11 =", rv$show_section_11, "(investissement = 0 ?)\n")
    }
    
    cat("État des sections conditionnelles: 8=", rv$show_section_8, 
        " 9=", rv$show_section_9, " 10=", rv$show_section_10, " 11=", rv$show_section_11, "\n")
  }
  
  # Sections 8-11 : Grilles optionnelles (sauvegarder selon le type de grille)
  if (section >= 8 && section <= 11) {
    grille_type <- get_grille_type_for_section(section, rv)
    if (!is.null(grille_type)) {
      input_name <- get_input_name_for_type(grille_type, optional = TRUE)
      
      # Sauvegarder le choix
      rv$participant_data[[input_name]] <- input[[input_name]]
      
      # Sauvegarder l'ordre de présentation
      position <- section - 7  # position 1-4
      rv$participant_data[[paste0("grille_optionnelle_", position, "_type")]] <- grille_type
    }
  }
  
  # Section 13 : Usages numériques
  if (section == 13) {
    # Fréquences d'usage
    for (i in 1:7) {
      rv$participant_data[[paste0("usage_freq_", i)]] <- input[[paste0("usage_freq_", i)]]
    }
    rv$participant_data$connaissance_ia <- input$connaissance_ia
    rv$participant_data$opinion_ia <- input$opinion_ia
    rv$participant_data$raisons_usage <- paste(input$raisons_usage, collapse = ";")
    rv$participant_data$freins_usage <- paste(input$freins_usage, collapse = ";")
  }
  
  # Section 14 : Santé
  if (section == 14) {
    sante_vars <- c(
      "activite_physique", "fruits_legumes", "produits_transformes",
      "alcool", "gestion_stress", "sommeil", "tabac",
      "bilan_sante", "depistage_organise", "depistage_volontaire"
    )
    
    for (var in sante_vars) {
      rv$participant_data[[var]] <- input[[var]]
    }
  }
  
  # Sections 15-17 : IA/Usages santé (2 randomisations indépendantes)
  if (section >= 15 && section <= 17) {
    # Déterminer le type de section selon les 2 randomisations
    if (rv$usages_sante_first) {
      # Usages santé en section 15, puis Bénéfices/Craintes en 16-17
      if (section == 15) {
        section_type <- "usages_sante"
      } else if (section == 16) {
        section_type <- ifelse(rv$benefices_first, "benefices", "craintes")
      } else {  # section == 17
        section_type <- ifelse(rv$benefices_first, "craintes", "benefices")
      }
    } else {
      # Bénéfices/Craintes en sections 15-16, puis Usages santé en 17
      if (section == 15) {
        section_type <- ifelse(rv$benefices_first, "benefices", "craintes")
      } else if (section == 16) {
        section_type <- ifelse(rv$benefices_first, "craintes", "benefices")
      } else {  # section == 17
        section_type <- "usages_sante"
      }
    }
    
    # Sauvegarder selon le type de section
    if (section_type == "benefices") {
      for (i in 1:10) {
        rv$participant_data[[paste0("B", i)]] <- input[[paste0("B", i)]]
      }
    } else if (section_type == "craintes") {
      for (i in 1:10) {
        rv$participant_data[[paste0("C", i)]] <- input[[paste0("C", i)]]
      }
    } else if (section_type == "usages_sante") {
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
  }
  
  # Section 18 : Sociodémographiques
  if (section == 18) {
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
  
  # Ajouter les ordres de randomisation IA/Usages santé (sections 15-17)
  rv$participant_data$benefices_first <- rv$benefices_first
  rv$participant_data$usages_sante_first <- rv$usages_sante_first
  # Créer un label descriptif de l'ordre complet
  if (rv$usages_sante_first) {
    ordre_label <- ifelse(rv$benefices_first, 
                          "Usages_puis_Benefices_puis_Craintes", 
                          "Usages_puis_Craintes_puis_Benefices")
  } else {
    ordre_label <- ifelse(rv$benefices_first, 
                          "Benefices_puis_Craintes_puis_Usages", 
                          "Craintes_puis_Benefices_puis_Usages")
  }
  rv$participant_data$ordre_ia_usages <- ordre_label
  
  # Ajouter l'ordre de randomisation des grilles obligatoires
  rv$participant_data$ordre_grilles_obligatoires <- paste(rv$order_grilles_obligatoires, collapse = ";")
  
  # Ajouter l'ordre de randomisation des grilles optionnelles (si applicable)
  if (!is.null(rv$order_grilles_optionnelles) && length(rv$order_grilles_optionnelles) > 0) {
    rv$participant_data$ordre_grilles_optionnelles <- paste(rv$order_grilles_optionnelles, collapse = ";")
  } else {
    rv$participant_data$ordre_grilles_optionnelles <- NA
  }
  
  # Ajouter les résultats du tirage au sort final
  if (!is.null(rv$lottery_results)) {
    results <- rv$lottery_results
    
    # Décision sélectionnée
    rv$participant_data$lottery_decision_number <- results$selected_grille$decision_number
    rv$participant_data$lottery_decision_type <- results$selected_grille$type
    rv$participant_data$lottery_decision_optional <- results$selected_grille$optional
    rv$participant_data$lottery_response <- results$selected_grille$response
    
    # Résultats du tirage
    if (!results$selected_grille$optional) {
      # Grille obligatoire
      rv$participant_data$lottery_result <- results$lottery_result$lottery_result
      rv$participant_data$lottery_kept_tokens <- results$lottery_result$kept_tokens
      rv$participant_data$lottery_tokens <- results$lottery_result$lottery_tokens
    } else {
      # Grille optionnelle (urne)
      rv$participant_data$lottery_urn_yellow <- results$lottery_result$urn_composition$yellow
      rv$participant_data$lottery_urn_purple <- results$lottery_result$urn_composition$purple
      rv$participant_data$lottery_urn_blue <- results$lottery_result$urn_composition$blue
      rv$participant_data$lottery_drawn_color <- results$lottery_result$drawn_color
    }
    
    # Gain net et rémunération finale
    rv$participant_data$lottery_net_change <- results$lottery_result$net_change
    rv$participant_data$final_payoff <- results$final_payoff
  }
  
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
