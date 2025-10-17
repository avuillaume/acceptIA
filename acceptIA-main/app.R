# ============================================================================
# Application R Shiny - Acceptabilité de l'IA en Santé
# Projet de recherche sur les déterminants comportementaux
# ============================================================================

# Chargement des packages nécessaires
if (!require("shiny")) install.packages("shiny")
if (!require("shinyjs")) install.packages("shinyjs")
if (!require("shinythemes")) install.packages("shinythemes")
if (!require("dplyr")) install.packages("dplyr")

library(shiny)
library(shinyjs)
library(shinythemes)
library(dplyr)
library(writexl)
# Source des modules
source("modules/ui_modules.R")
source("modules/ui_modules_suite.R")
source("modules/server_modules.R")
source("modules/data_functions.R")

# ============================================================================
# INTERFACE UTILISATEUR (UI)
# ============================================================================

ui <- navbarPage(
  title = "Étude : Acceptabilité de l'IA en Santé",
  theme = shinytheme("flatly"),
  id = "main_navbar",
  
  # Onglet 1 : Collecte de données
  tabPanel(
    "Collecte de données",
    value = "collecte",
    useShinyjs(),
    
    # CSS personnalisé
    tags$head(
      tags$style(HTML("
        .main-container { max-width: 900px; margin: auto; padding: 20px; }
        .section-title { 
          background-color: #3498db; 
          color: white; 
          padding: 15px; 
          margin-top: 20px;
          border-radius: 5px;
          font-size: 20px;
          font-weight: bold;
        }
        .question-text { 
          font-size: 16px; 
          margin-bottom: 10px; 
          font-weight: 500;
        }
        .choice-box {
          border: 2px solid #ecf0f1;
          padding: 20px;
          margin: 10px 0;
          border-radius: 8px;
          cursor: pointer;
          transition: all 0.3s;
        }
        .choice-box:hover {
          background-color: #ecf0f1;
          border-color: #3498db;
        }
        .choice-selected {
          background-color: #3498db;
          color: white;
          border-color: #2980b9;
        }
        .progress-bar-custom {
          height: 30px;
          font-size: 16px;
          line-height: 30px;
        }
        .btn-custom {
          font-size: 18px;
          padding: 12px 30px;
          margin: 10px 5px;
        }
        .likert-scale {
          display: flex;
          justify-content: space-between;
          margin: 15px 0;
        }
        .likert-item {
          text-align: center;
          flex: 1;
        }
      "))
    ),
    
    div(class = "main-container",
        
        # En-tête
        div(
          style = "text-align: center; margin-bottom: 30px;",
          h1("Les déterminants comportementaux de l'acceptabilité de l'IA en santé"),
          p(style = "font-size: 16px; color: #7f8c8d;",
            "Cette étude vise à mieux comprendre vos comportements et perceptions en lien avec le numérique et la santé.",
            br(),
            "Durée estimée : 20-25 minutes")
        ),
        
        # Barre de progression
        div(
          style = "margin-bottom: 30px;",
          h4("Progression", style = "text-align: center;"),
          uiOutput("progress_bar")
        ),
        
        # Zone de consentement
        conditionalPanel(
          condition = "input.consent_given == false || input.consent_given == null",
          wellPanel(
            h3("Consentement éclairé"),
            p("Dans le cadre de cette recherche scientifique, vos réponses seront collectées de manière anonyme.",
              "Les données seront utilisées uniquement à des fins de recherche académique."),
            p("En participant, vous acceptez que vos réponses anonymisées puissent être analysées",
              "et que les résultats agrégés puissent être publiés dans des revues scientifiques."),
            checkboxInput("consent_check", 
                          "Je consens à participer à cette étude et j'ai compris les conditions ci-dessus.", 
                          value = FALSE),
            actionButton("consent_given", "Commencer l'étude", 
                         class = "btn btn-primary btn-lg btn-custom",
                         style = "width: 100%;")
          )
        ),
        
        # Contenu principal de l'étude
        conditionalPanel(
          condition = "input.consent_given > 0",
          
          # Section actuelle
          uiOutput("current_section"),
          
          # Boutons de navigation
          div(
            style = "text-align: center; margin-top: 30px;",
            actionButton("btn_previous", "← Précédent", 
                         class = "btn btn-default btn-custom"),
            actionButton("btn_next", "Suivant →", 
                         class = "btn btn-primary btn-custom")
          )
        )
    )
  ),
  
  # Onglet 2 : À propos
  tabPanel(
    "À propos",
    value = "about",
    
    div(class = "main-container",
        h2("À propos de cette étude"),
        
        h4("Objectif"),
        p("Cette étude vise à mieux comprendre les attitudes et comportements ",
          "face aux technologies émergentes dans le domaine de la santé, ",
          "en particulier l'intelligence artificielle."),
        
        h4("Méthodologie"),
        p("Le protocole comprend :"),
        tags$ul(
          tags$li("Évaluation des usages numériques dans votre quotidien"),
          tags$li("Questions sur vos habitudes de santé"),
          tags$li("Mesure des perceptions (bénéfices et craintes) vis-à-vis de l'IA en santé"),
          tags$li("Évaluation de l'usage des outils numériques en santé"),
          tags$li("Collecte de variables sociodémographiques")
        ),
        
        h4("Analyse"),
        p("Les données seront analysées à l'aide de méthodes statistiques avancées ",
          "pour comprendre les liens entre usages numériques, perceptions et comportements de santé."),
        
        h4("Contact"),
        p("Pour toute question concernant cette recherche, veuillez contacter : [Votre email]"),
        
        hr(),
        p(style = "text-align: center; color: #7f8c8d;",
          "© 2025 - Tous droits réservés")
    )
  )
)

# ============================================================================
# SERVEUR
# ============================================================================

server <- function(input, output, session) {
  
  # Reactive values pour stocker les données
  rv <- reactiveValues(
    current_section = 0,
    max_section = 19,  # 3 intro + 8 jeux hasard + 7 sections questionnaire + 1 fin
    participant_data = list(),
    participant_id = paste0("P", format(Sys.time(), "%Y%m%d%H%M%S")),
    # Randomisation 1 : Ordre Bénéfices/Craintes (TRUE = Bénéfices en premier, FALSE = Craintes en premier)
    benefices_first = sample(c(TRUE, FALSE), 1),
    # Randomisation 2 : Position Usages santé (TRUE = avant IA, FALSE = après IA)
    usages_sante_first = sample(c(TRUE, FALSE), 1),
    # Variables pour la tâche de comptage
    digit_to_count = NULL,
    correct_count = NULL,
    counting_error = FALSE,
    # Variables pour les décisions conditionnelles (sections 8-11)
    show_section_8 = FALSE,  # Risque Gains 2 - montré si section 4 = 10
    show_section_9 = FALSE,  # Risque Pertes 2 - montré si section 5 = 0
    show_section_10 = FALSE, # Ambiguïté Gains 2 - montré si section 6 = 10
    show_section_11 = FALSE, # Ambiguïté Pertes 2 - montré si section 7 = 0
    # Randomisation de l'ordre des grilles obligatoires (sections 4-7)
    # Ordre aléatoire des 4 types: "risque_gains", "risque_pertes", "ambiguite_gains", "ambiguite_pertes"
    order_grilles_obligatoires = sample(c("risque_gains", "risque_pertes", "ambiguite_gains", "ambiguite_pertes")),
    # Randomisation de l'ordre des grilles optionnelles (sections 8-11) - sera calculé après section 7
    order_grilles_optionnelles = NULL,
    # Résultats du tirage au sort final
    lottery_executed = FALSE,
    lottery_results = NULL
  )
  
  # Initialiser la tâche de comptage au démarrage
  observe({
    if (is.null(rv$digit_to_count)) {
      counting_task <- initialize_counting_task()
      rv$digit_to_count <- counting_task$digit
      rv$correct_count <- counting_task$correct_count
    }
  })
  
  # Désactiver le bouton "Commencer" tant que le consentement n'est pas donné
  observe({
    shinyjs::toggleState("consent_given", input$consent_check)
  })
  
  # Commencer l'étude après consentement
  observeEvent(input$consent_given, {
    rv$current_section <- 1
    # Remonter en haut de page
    shinyjs::runjs("window.scrollTo({top: 0, behavior: 'smooth'});")
  })
  
  # Barre de progression
  output$progress_bar <- renderUI({
    if (rv$current_section == 0) return(NULL)
    
    # Calculer la position et le max effectifs en tenant compte des sections conditionnelles
    effective_position <- calculate_effective_position(rv$current_section, rv)
    effective_max <- calculate_effective_max_section(rv)
    progress_pct <- round((effective_position / effective_max) * 100)
    
    div(
      class = "progress",
      div(
        class = "progress-bar progress-bar-custom bg-info",
        role = "progressbar",
        style = paste0("width: ", progress_pct, "%;"),
        paste0(progress_pct, "%")
      )
    )
  })
  
  # Outputs pour afficher le chiffre à compter
  output$digit_to_count_display <- renderUI({
    if (!is.null(rv$digit_to_count)) {
      tags$span(style = "color: #e74c3c; font-size: 28px; font-weight: bold; padding: 0 5px;", 
                rv$digit_to_count)
    } else {
      tags$span("...")
    }
  })
  
  output$digit_to_count_text_label <- renderUI({
    if (!is.null(rv$digit_to_count)) {
      tags$span(style = "color: #e74c3c; font-weight: bold; font-size: 18px;", 
                rv$digit_to_count)
    } else {
      tags$span("...")
    }
  })
  
  output$digit_to_count_error <- renderUI({
    if (!is.null(rv$digit_to_count)) {
      tags$strong(style = "color: #721c24; font-size: 18px;", 
                  rv$digit_to_count)
    } else {
      tags$span("")
    }
  })
  
  output$show_counting_error <- reactive({
    rv$counting_error
  })
  outputOptions(output, "show_counting_error", suspendWhenHidden = FALSE)
  
  # Afficher la section courante
  output$current_section <- renderUI({
    section <- rv$current_section
    
    # DEBUG : Afficher quelle section est demandée
    cat("=== Affichage de la section", section, "===\n")
    
    if (section == 0) return(NULL)
    
    # Sections 4-7 : Grilles obligatoires randomisées
    if (section >= 4 && section <= 7) {
      grille_type <- get_grille_type_for_section(section, rv)
      return(get_ui_for_grille_type(grille_type, optional = FALSE))
    }
    
    # Sections 8-11 : Grilles optionnelles randomisées
    if (section >= 8 && section <= 11) {
      # Vérifier si cette section conditionnelle doit être affichée
      should_show <- switch(
        as.character(section),
        "8" = rv$show_section_8,
        "9" = rv$show_section_9,
        "10" = rv$show_section_10,
        "11" = rv$show_section_11,
        FALSE
      )
      
      if (!should_show) {
        cat("ATTENTION: Section", section, "conditionnelle pas activée!\n")
        cat("Flags: 8=", rv$show_section_8, " 9=", rv$show_section_9, 
            " 10=", rv$show_section_10, " 11=", rv$show_section_11, "\n")
        # Cette section ne devrait JAMAIS être affichée
        # C'est un bug si on arrive ici - afficher un message d'erreur
        return(div(
          class = "alert alert-warning",
          h3("Navigation incorrecte"),
          p("Cette section (", section, ") ne devrait pas être affichée."),
          p("Cliquez sur 'Suivant' pour continuer.")
        ))
      }
      
      # Initialiser l'ordre des optionnelles si ce n'est pas déjà fait
      if (is.null(rv$order_grilles_optionnelles)) {
        cat("Initialisation de order_grilles_optionnelles\n")
        rv$order_grilles_optionnelles <- initialize_optional_grilles_order(rv)
        cat("Ordre optionnelles:", paste(rv$order_grilles_optionnelles, collapse=", "), "\n")
      }
      
      grille_type <- get_grille_type_for_section(section, rv)
      cat("Section", section, "→ Type de grille:", grille_type, "\n")
      
      if (!is.null(grille_type)) {
        return(get_ui_for_grille_type(grille_type, optional = TRUE))
      } else {
        cat("ERREUR: grille_type NULL pour section", section, "\n")
        cat("order_grilles_optionnelles:", paste(rv$order_grilles_optionnelles, collapse=", "), "\n")
        return(div(
          class = "alert alert-danger",
          h3("Erreur de configuration"),
          p("Impossible de déterminer le type de grille pour la section", section),
          p("Cliquez sur 'Suivant' pour continuer au questionnaire.")
        ))
      }
    }
    
    # Sections 15, 16, 17 : 2 randomisations indépendantes
    # 1) Bénéfices avant/après Craintes
    # 2) Usages santé avant/après les questions IA
    if (section >= 15 && section <= 17) {
      if (rv$usages_sante_first) {
        # Usages santé en premier (section 15), puis Bénéfices/Craintes (16-17)
        if (section == 15) {
          return(section_usages_sante_ui())
        } else if (section == 16) {
          # Section 16 : Bénéfices ou Craintes selon randomisation
          if (rv$benefices_first) {
            return(section_ia_benefices_ui(section_number = "1"))
          } else {
            return(section_ia_craintes_ui(section_number = "1"))
          }
        } else if (section == 17) {
          # Section 17 : L'autre (Craintes ou Bénéfices)
          if (rv$benefices_first) {
            return(section_ia_craintes_ui(section_number = "2"))
          } else {
            return(section_ia_benefices_ui(section_number = "2"))
          }
        }
      } else {
        # Questions IA en premier (sections 15-16), puis Usages santé (17)
        if (section == 15) {
          # Section 15 : Bénéfices ou Craintes selon randomisation
          if (rv$benefices_first) {
            return(section_ia_benefices_ui(section_number = "1"))
          } else {
            return(section_ia_craintes_ui(section_number = "1"))
          }
        } else if (section == 16) {
          # Section 16 : L'autre (Craintes ou Bénéfices)
          if (rv$benefices_first) {
            return(section_ia_craintes_ui(section_number = "2"))
          } else {
            return(section_ia_benefices_ui(section_number = "2"))
          }
        } else if (section == 17) {
          return(section_usages_sante_ui())
        }
      }
    }
    
    # Autres sections dans l'ordre normal
    result <- switch(
      as.character(section),
      "1" = section_aversion_intro_ui(),
      "2" = section_tache_comptage_ui(digit_to_count = rv$digit_to_count, show_error = rv$counting_error),
      "3" = section_felicitations_ui(),
      "12" = section_intro_ui(),
      "13" = section_usages_numeriques_ui(),
      "14" = section_sante_ui(),
      "18" = section_sociodemographiques_ui(),
      "19" = section_fin_ui(),
      NULL  # Cas par défaut : retourner NULL au lieu de la page de fin
    )
    
    # Si result est NULL, c'est qu'il y a un problème
    if (is.null(result)) {
      cat("ERREUR: Section", section, "non gérée par le switch!\n")
      return(div(
        class = "alert alert-danger",
        h3("Erreur de navigation"),
        p("Section non trouvée:", section),
        p("Veuillez signaler ce problème à l'administrateur.")
      ))
    }
    
    return(result)
  })
  
  # Navigation : Bouton Précédent
  observeEvent(input$btn_previous, {
    if (rv$current_section > 1) {
      rv$current_section <- previous_section_logic(rv$current_section, rv)
      # Remonter en haut de page
      shinyjs::runjs("window.scrollTo({top: 0, behavior: 'smooth'});")
    }
  })
  
  # Navigation : Bouton Suivant
  observeEvent(input$btn_next, {
    # Validation des réponses avant de passer à la section suivante
    if (validate_current_section(input, rv$current_section, rv)) {
      # Sauvegarder les réponses
      save_section_data(input, rv$current_section, rv)
      
      # Réinitialiser le flag d'erreur de comptage
      if (rv$current_section == 2) {
        rv$counting_error <- FALSE
      }
      
      # La dernière section est toujours 19 (section fin)
      if (rv$current_section < 19) {
        next_sec <- next_section_logic(rv$current_section, rv)
        
        # DEBUG : Afficher la progression
        cat("Navigation: Section", rv$current_section, "→ Section", next_sec, "\n")
        
        # IMPORTANT : La loterie s'exécute UNIQUEMENT quand on passe de la section 18 à 19
        # (après avoir terminé toutes les questions)
        if (next_sec == 19 && rv$current_section == 18 && !rv$lottery_executed) {
          cat("Exécution de la loterie finale (après questionnaire)...\n")
          rv$lottery_results <- execute_final_lottery(rv)
          rv$lottery_executed <- TRUE
        }
        
        rv$current_section <- next_sec
        # Remonter en haut de page
        shinyjs::runjs("window.scrollTo({top: 0, behavior: 'smooth'});")
      } else {
        # Fin de l'étude - sauvegarder toutes les données dans MongoDB
        success <- save_participant_data_mongo(rv)
        
        if (success) {
          showModal(modalDialog(
            title = "Merci !",
            "Votre participation est terminée. Vos données ont été sauvegardées avec succès. Merci beaucoup pour votre contribution à cette recherche !",
            footer = modalButton("Fermer")
          ))
        } else {
          showModal(modalDialog(
            title = "Erreur",
            "Une erreur est survenue lors de la sauvegarde de vos données. Veuillez contacter l'administrateur.",
            footer = modalButton("Fermer"),
            easyClose = FALSE
          ))
        }
      }
    } else {
      # Message d'erreur spécifique pour la section de comptage
      if (rv$current_section == 2) {
        # Le message d'erreur s'affichera automatiquement via conditionalPanel
        shinyjs::runjs("window.scrollTo({top: 0, behavior: 'smooth'});")
      } else {
        showNotification(
          "Veuillez répondre à toutes les questions avant de continuer.",
          type = "warning",
          duration = 3
        )
      }
    }
  })
  
  # Gestion des boutons de navigation
  observe({
    shinyjs::toggle("btn_previous", condition = rv$current_section > 1)
  })
  
  # ========================================================================
  # AFFICHAGE DES RÉSULTATS DU TIRAGE AU SORT FINAL
  # ========================================================================
  
  output$lottery_results_display <- renderUI({
    if (is.null(rv$lottery_results)) {
      return(div(
        style = "text-align: center; padding: 20px;",
        p(icon("spinner", class = "fa-spin"), " Tirage en cours...")
      ))
    }
    
    results <- rv$lottery_results
    selected <- results$selected_grille
    lottery <- results$lottery_result
    payoff <- results$final_payoff
    
    # Nom de la décision
    type_names <- list(
      "risque_gains" = "Risque et Gains",
      "risque_pertes" = "Risque et Pertes",
      "ambiguite_gains" = "Ambiguïté et Gains",
      "ambiguite_pertes" = "Ambiguïté et Pertes"
    )
    
    decision_name <- type_names[[selected$type]]
    decision_version <- ifelse(selected$optional, " (version 2)", " (version 1)")
    
    div(
      style = "background-color: #e8f5e9; padding: 25px; border-radius: 10px; border: 3px solid #4caf50;",
      
      h5(icon("trophy"), " Décision sélectionnée"),
      p(strong("Décision n°", selected$decision_number, " : "), decision_name, decision_version),
      
      if (!selected$optional) {
        # Grille obligatoire
        tagList(
          p(strong("Votre investissement : "), selected$response, " jetons"),
          hr(),
          h5(icon("dice"), " Résultat du tirage"),
          if (grepl("gains", selected$type)) {
            tagList(
              p("Tirage : ", ifelse(lottery$lottery_result, "🟢 SUCCÈS", "🔴 ÉCHEC")),
              p("• Jetons conservés : ", lottery$kept_tokens),
              p("• Jetons de la loterie : ", lottery$lottery_tokens),
              if (lottery$net_change >= 0) {
                p(style = "color: green; font-size: 18px; font-weight: bold;",
                  "✅ Vous gagnez ", lottery$net_change, " jetons")
              } else {
                p(style = "color: red; font-size: 18px; font-weight: bold;",
                  "❌ Vous perdez ", abs(lottery$net_change), " jetons")
              }
            )
          } else {
            tagList(
              p("Tirage : ", ifelse(lottery$lottery_result, "🔴 PERTE", "🟢 ÉVITÉ")),
              p("• Jetons conservés : ", lottery$kept_tokens),
              p("• Jetons de la loterie : ", lottery$lottery_tokens),
              if (lottery$net_change >= 0) {
                p(style = "color: green; font-size: 18px; font-weight: bold;",
                  "✅ Vous gagnez ", lottery$net_change, " jetons")
              } else {
                p(style = "color: red; font-size: 18px; font-weight: bold;",
                  "❌ Vous perdez ", abs(lottery$net_change), " jetons")
              }
            )
          }
        )
      } else {
        # Grille optionnelle (urnes)
        color_names <- list(
          "yellow" = list(emoji = "🟡", name = "JAUNE"),
          "purple" = list(emoji = "🟣", name = "VIOLETTE"),
          "blue" = list(emoji = "🔵", name = "BLEUE")
        )
        
        drawn_color_info <- color_names[[lottery$drawn_color]]
        
        tagList(
          p(strong("Votre choix : "), "Urne ", selected$response),
          p(strong("Composition de l'urne : "), 
            lottery$urn_composition$yellow, " 🟡 / ",
            lottery$urn_composition$purple, " 🟣 / ",
            lottery$urn_composition$blue, " 🔵"),
          hr(),
          h5(icon("dice"), " Résultat du tirage"),
          p(style = "font-size: 20px;", "Boule tirée : ", drawn_color_info$emoji, " ", drawn_color_info$name),
          if (lottery$net_change > 0) {
            p(style = "color: green; font-size: 18px; font-weight: bold;",
              "✅ Vous gagnez ", lottery$net_change, " jetons")
          } else if (lottery$net_change < 0) {
            p(style = "color: red; font-size: 18px; font-weight: bold;",
              "❌ Vous perdez ", abs(lottery$net_change), " jetons")
          } else {
            p(style = "font-size: 18px; font-weight: bold;",
              "➖ Vous ne gagnez ni ne perdez de jetons")
          }
        )
      },
      
      hr(),
      
      div(
        style = "background-color: #fff9c4; padding: 15px; border-radius: 5px; border-left: 4px solid #fbc02d;",
        h5(icon("coins"), " Votre rémunération finale"),
        p(style = "font-size: 22px; font-weight: bold; color: #f57c00;",
          payoff, " jetons",
          span(style = "font-size: 14px; color: #666; margin-left: 10px;",
               "(30 jetons initiaux ", 
               ifelse(results$lottery_result$net_change >= 0, "+ ", ""),
               results$lottery_result$net_change, " jetons)")
        )
      )
    )
  })
  
  # ========================================================================
  # RÉSUMÉS DYNAMIQUES POUR LES JEUX DE HASARD
  # ========================================================================
  
  # Résumé Risque Gains
  output$risque_gains_summary <- renderUI({
    invest <- input$risque_gains_invest
    if (is.null(invest)) invest <- 0
    conserve <- 10 - invest
    gain_jaune <- conserve + (invest * 3)
    gain_violet <- conserve
    
    div(
      style = "background-color: #f0f4f8; padding: 20px; border-radius: 10px; margin-top: 20px; border: 2px solid #3498db;",
      h5(icon("chart-bar"), " Résumé de votre investissement"),
      p(strong("Vous misez ", invest, " jeton(s) et conservez ", conserve, " jeton(s).")),
      hr(),
      p(strong("Vos jetons après tirage :")),
      div(style = "margin-left: 20px;",
        p("🟡 ", strong("Tirage JAUNE :"), " ", conserve, " jetons conservés + ", invest * 3, " jetons gagnés = ", 
          strong(style = "color: #27ae60; font-size: 18px;", gain_jaune, " jetons")),
        p("🟣 ", strong("Tirage VIOLET :"), " ", conserve, " jetons conservés = ",
          strong(style = "color: #e74c3c; font-size: 18px;", gain_violet, " jetons"))
      )
    )
  })
  
  # Résumé Risque Pertes
  output$risque_pertes_summary <- renderUI({
    invest <- input$risque_pertes_invest
    if (is.null(invest)) invest <- 0
    non_invest <- 10 - invest
    perte_jaune <- non_invest
    perte_violet <- non_invest + (invest * 3)
    
    div(
      style = "background-color: #fef5e7; padding: 20px; border-radius: 10px; margin-top: 20px; border: 2px solid #e67e22;",
      h5(icon("chart-bar"), " Résumé de votre investissement"),
      p(strong("Vous misez ", invest, " jeton(s) et ", non_invest, " jeton(s) seront définitivement perdus.")),
      hr(),
      p(strong("Vos pertes après tirage :")),
      div(style = "margin-left: 20px;",
        p("🟡 ", strong("Tirage JAUNE :"), " Vous perdez les ", non_invest, " jetons non-investis = ",
          strong(style = "color: #27ae60; font-size: 18px;", perte_jaune, " jetons perdus")),
        p("🟣 ", strong("Tirage VIOLET :"), " Vous perdez ", non_invest, " + (3 × ", invest, ") = ",
          strong(style = "color: #e74c3c; font-size: 18px;", perte_violet, " jetons perdus"))
      )
    )
  })
  
  # Résumé Ambiguïté Gains
  output$ambiguite_gains_summary <- renderUI({
    invest <- input$ambiguite_gains_invest
    if (is.null(invest)) invest <- 0
    conserve <- 10 - invest
    gain_jaune <- conserve + (invest * 3)
    gain_violet <- conserve
    
    div(
      style = "background-color: #fff9e6; padding: 20px; border-radius: 10px; margin-top: 20px; border: 2px dashed #ff9800;",
      h5(icon("chart-bar"), " Résumé de votre investissement"),
      p(icon("exclamation-triangle"), " ", em("Rappel : composition de l'urne inconnue")),
      p(strong("Vous misez ", invest, " jeton(s) et conservez ", conserve, " jeton(s).")),
      hr(),
      p(strong("Vos jetons après tirage :")),
      div(style = "margin-left: 20px;",
        p("🟡 ", strong("Tirage JAUNE :"), " ", conserve, " jetons conservés + ", invest * 3, " jetons gagnés = ", 
          strong(style = "color: #27ae60; font-size: 18px;", gain_jaune, " jetons")),
        p("🟣 ", strong("Tirage VIOLET :"), " ", conserve, " jetons conservés = ",
          strong(style = "color: #e74c3c; font-size: 18px;", gain_violet, " jetons"))
      )
    )
  })
  
  # Résumé Ambiguïté Pertes
  output$ambiguite_pertes_summary <- renderUI({
    invest <- input$ambiguite_pertes_invest
    if (is.null(invest)) invest <- 0
    non_invest <- 10 - invest
    perte_jaune <- non_invest
    perte_violet <- non_invest + (invest * 3)
    
    div(
      style = "background-color: #ffe6e6; padding: 20px; border-radius: 10px; margin-top: 20px; border: 2px dashed #ff5252;",
      h5(icon("chart-bar"), " Résumé de votre investissement"),
      p(icon("exclamation-triangle"), " ", em("Rappel : composition de l'urne inconnue")),
      p(strong("Vous misez ", invest, " jeton(s) et ", non_invest, " jeton(s) seront définitivement perdus.")),
      hr(),
      p(strong("Vos pertes après tirage :")),
      div(style = "margin-left: 20px;",
        p("🟡 ", strong("Tirage JAUNE :"), " Vous perdez les ", non_invest, " jetons non-investis = ",
          strong(style = "color: #27ae60; font-size: 18px;", perte_jaune, " jetons perdus")),
        p("🟣 ", strong("Tirage VIOLET :"), " Vous perdez ", non_invest, " + (3 × ", invest, ") = ",
          strong(style = "color: #e74c3c; font-size: 18px;", perte_violet, " jetons perdus"))
      )
    )
  })
  
}

# ============================================================================
# LANCEMENT DE L'APPLICATION
# ============================================================================

shinyApp(ui = ui, server = server)
