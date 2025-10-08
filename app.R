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
    max_section = 14,  # 3 intro + 4 jeux hasard + 7 sections questionnaire
    participant_data = list(),
    participant_id = paste0("P", format(Sys.time(), "%Y%m%d%H%M%S"))
  )
  
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
    
    progress_pct <- round((rv$current_section / rv$max_section) * 100)
    
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
  
  # Afficher la section courante
  output$current_section <- renderUI({
    section <- rv$current_section
    
    if (section == 0) return(NULL)
    
    switch(
      section,
      "1" = section_aversion_intro_ui(),
      "2" = section_tache_comptage_ui(),
      "3" = section_felicitations_ui(),
      "4" = section_risque_gains_ui(),
      "5" = section_risque_pertes_ui(),
      "6" = section_ambiguite_gains_ui(),
      "7" = section_ambiguite_pertes_ui(),
      "8" = section_intro_ui(),
      "9" = section_usages_numeriques_ui(),
      "10" = section_sante_ui(),
      "11" = section_ia_benefices_ui(),
      "12" = section_ia_craintes_ui(),
      "13" = section_usages_sante_ui(),
      "14" = section_sociodemographiques_ui(),
      section_fin_ui()
    )
  })
  
  # Navigation : Bouton Précédent
  observeEvent(input$btn_previous, {
    if (rv$current_section > 1) {
      rv$current_section <- rv$current_section - 1
      # Remonter en haut de page
      shinyjs::runjs("window.scrollTo({top: 0, behavior: 'smooth'});")
    }
  })
  
  # Navigation : Bouton Suivant
  observeEvent(input$btn_next, {
    # Validation des réponses avant de passer à la section suivante
    if (validate_current_section(input, rv$current_section)) {
      # Sauvegarder les réponses
      save_section_data(input, rv$current_section, rv)
      
      if (rv$current_section < rv$max_section) {
        rv$current_section <- rv$current_section + 1
        # Remonter en haut de page
        shinyjs::runjs("window.scrollTo({top: 0, behavior: 'smooth'});")
      } else {
        # Fin de l'étude - sauvegarder toutes les données
        save_participant_data(rv)
        showModal(modalDialog(
          title = "Merci !",
          "Votre participation est terminée. Merci beaucoup pour votre contribution à cette recherche !",
          footer = modalButton("Fermer")
        ))
      }
    } else {
      showNotification(
        "Veuillez répondre à toutes les questions avant de continuer.",
        type = "warning",
        duration = 3
      )
    }
  })
  
  # Gestion des boutons de navigation
  observe({
    shinyjs::toggle("btn_previous", condition = rv$current_section > 1)
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
