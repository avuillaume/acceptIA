# ============================================================================
# MODULES UI - Définition de toutes les sections du questionnaire
# ============================================================================

# Section tâches d'aversion - Introduction et tâche rémunérée
section_aversion_intro_ui <- function() {
  tagList(
    div(class = "section-title", "Tâche rémunérée"),
    wellPanel(
      h4("Cette étape comprend :"),
      tags$ul(
        tags$li(icon("check-circle"), " ", strong("Une tâche rémunérée qui vous permettra de gagner 30 jetons")),
        tags$li(icon("lightbulb"), " ", strong("Une série de décisions mettant en jeu tout ou partie des 30 jetons que vous aurez gagnés"))
      ),
      
      hr(),
      
      p(strong("Pour le calcul de vos gains finaux, le taux de conversion sera le suivant :")),
      p(style = "font-size: 18px; text-align: center; background-color: #e8f4f8; padding: 15px; border-radius: 5px;",
        "1 jeton = 50 centimes d'euros",
        br(),
        "Ainsi, ", strong("30 jetons valent 15 euros"), " et ", strong("10 jetons valent 5 euros")
      ),
      
      hr(),
      
      div(
        style = "background-color: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107;",
        p(icon("bolt"), " ", strong("À la fin de cette série de jeux, une seule de vos décisions est tirée au sort pour déterminer votre gain ou perte final.")),
        p("Cela signifie que chaque décision compte :", br(),
          strong("il est donc important de répondre à chaque décision avec attention."))
      )
    )
  )
}

# Section tâche de comptage (décimales de pi)
section_tache_comptage_ui <- function() {
  tagList(
    div(class = "section-title", "Tâche de comptage"),
    wellPanel(
      p(strong("Vous allez maintenant accomplir une tâche qui vous permettra de gagner 30 jetons.")),
      
      hr(),
      
      h5("Trouvez le nombre d'occurrences du chiffre 1 dans les 200 premières décimales du nombre π"),
      
      div(
        style = "background-color: #f8f9fa; padding: 15px; border-radius: 5px; font-family: monospace; word-wrap: break-word; margin: 20px 0;",
        "π = 3,141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521"
      ),
      
      numericInput(
        "comptage_pi",
        "Combien de fois le chiffre 1 apparaît-il ?",
        value = NULL,
        min = 0,
        max = 200,
        step = 1
      ),
      
      p(style = "color: #6c757d; font-style: italic;",
        "Prenez le temps de compter attentivement.")
    )
  )
}

# Section félicitations et instructions jeux
section_felicitations_ui <- function() {
  tagList(
    div(class = "section-title", "Félicitations !"),
    wellPanel(
      div(
        style = "text-align: center; background-color: #d4edda; padding: 20px; border-radius: 5px; margin-bottom: 20px;",
        h3(style = "color: #155724;", icon("trophy"), " Félicitations !"),
        h4(style = "color: #155724;", "Vous avez gagné 30 jetons")
      ),
      
      hr(),
      
      h5("Instructions pour la suite :"),
      p("Ces jetons vous serviront lors d'une série de jeux de hasard (entre 4 et 8 jeux)."),
      p("Au cours de chaque jeu, vous devrez prendre une décision."),
      
      div(
        style = "background-color: #e7f3ff; padding: 15px; border-radius: 5px; margin: 15px 0;",
        p(strong("Les décisions sont indépendantes les unes des autres :"), 
          " cela signifie que ce que vous choisirez dans un jeu n'aura aucune influence sur vos gains et pertes des autres jeux."),
        p(strong("À la fin de l'expérimentation, une seule de vos décisions sera tirée au sort"), 
          " pour déterminer votre gain final."),
        p("Ainsi, tout se passe comme si vous commenciez chaque jeu avec vos 30 jetons de départ.")
      ),
      
      div(
        style = "background-color: #fff3cd; padding: 15px; border-radius: 5px; border-left: 4px solid #ffc107;",
        p(icon("exclamation-triangle"), " ", 
          strong("Il est donc essentiel de traiter chaque décision avec attention, comme si elle seule comptait."))
      )
    )
  )
}

# ============================================================================
# SECTIONS JEUX DE HASARD - AVERSIONS
# ============================================================================

# Section Risque Gains - Décision 1
section_risque_gains_ui <- function() {
  tagList(
    div(class = "section-title", "Décision 1 - Investissez vos jetons"),
    wellPanel(
      div(
        style = "background-color: #e7f3ff; padding: 15px; border-radius: 5px; margin-bottom: 20px;",
        p(strong("Avec 10 de vos 30 jetons, vous pouvez :")),
        tags$ul(
          tags$li("Conserver les 10 jetons"),
          tags$li("OU investir tout ou une partie des 10 jetons dans un jeu de hasard")
        )
      ),
      
      hr(),
      
      h5(icon("dice"), " Comment fonctionne le jeu de hasard ?"),
      
      p("Une urne contient 60 boules : ", 
        strong("30 boules JAUNES"), " et ", strong("30 boules VIOLETTES"), "."),
      
      # Visualisation de l'urne
      div(
        style = "text-align: center; background-color: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;",
        div(
          style = "display: inline-block; border: 3px solid #333; border-radius: 50%; width: 200px; height: 200px; padding: 20px; background: linear-gradient(to bottom, #ffeb3b 50%, #9c27b0 50%);",
          div(style = "padding-top: 70px; font-size: 18px; font-weight: bold; color: #333;",
              "30 🟡 / 30 🟣")
        ),
        p(style = "margin-top: 15px; font-style: italic;", 
          "⚠️ Avec autant de boules de chaque couleur, vous avez donc ", 
          strong("1 chance sur 2"), " de tirer chaque couleur.")
      ),
      
      p(strong("On tire au hasard une boule de l'urne. Deux possibilités se présentent à vous :")),
      
      div(style = "margin: 15px 0;",
        div(style = "background-color: #fff9c4; padding: 10px; border-left: 4px solid #fbc02d; margin-bottom: 10px;",
            p(strong("🟡 Tirage JAUNE :"), " vous gagnez ", strong("3 fois"), " les jetons investis")),
        div(style = "background-color: #f3e5f5; padding: 10px; border-left: 4px solid #9c27b0;",
            p(strong("🟣 Tirage VIOLET :"), " vous perdez les jetons investis"))
      ),
      
      hr(),
      
      div(
        style = "background-color: #e8f5e9; padding: 15px; border-radius: 5px; border-left: 4px solid #4caf50;",
        h5(icon("lightbulb"), " Exemple : Avec 4 jetons investis (et 6 jetons conservés) :"),
        tags$ul(
          tags$li(strong("🟡 Tirage JAUNE :"), " vous gagnez 3 × 4 jetons = 12 jetons",
                  br(), "→ Après tirage, vous avez donc 12 + 6 (jetons conservés) = ", strong("18 jetons")),
          tags$li(strong("🟣 Tirage VIOLET :"), " vous perdez les 4 jetons investis et ne gagnez donc rien",
                  br(), "→ Après tirage, il vous reste donc les ", strong("6 jetons conservés"))
        )
      ),
      
      hr(),
      
      h5("💰 Combien souhaitez-vous investir ?"),
      
      sliderInput(
        "risque_gains_invest",
        "Je décide d'investir :",
        min = 0,
        max = 10,
        value = 0,
        step = 1,
        post = " jetons",
        width = "100%"
      ),
      
      # Résumé dynamique
      uiOutput("risque_gains_summary")
    )
  )
}

# Section Risque Pertes - Décision 2
section_risque_pertes_ui <- function() {
  tagList(
    div(class = "section-title", "Décision 2 - Investissez vos jetons"),
    wellPanel(
      div(
        style = "background-color: #fff3cd; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #ffc107;",
        p(icon("info-circle"), " ", 
          "Le tirage au sort de la décision donnant lieu à votre rémunération finale n'a lieu qu'à la fin de tous les jeux. ",
          strong("Vous disposez donc toujours à ce stade de vos 30 jetons initiaux."))
      ),
      
      div(
        style = "background-color: #ffebee; padding: 15px; border-radius: 5px; margin-bottom: 20px;",
        p(strong("Avec 10 de vos 30 jetons, vous pouvez :")),
        tags$ul(
          tags$li("Ne rien faire et ", strong("perdre les 10 jetons")),
          tags$li("OU investir tout ou une partie des 10 jetons dans un jeu de hasard")
        )
      ),
      
      hr(),
      
      h5(icon("dice"), " Comment fonctionne le jeu de hasard ?"),
      
      p("Une urne contient 60 boules : ", 
        strong("30 boules JAUNES"), " et ", strong("30 boules VIOLETTES"), "."),
      
      # Visualisation de l'urne
      div(
        style = "text-align: center; background-color: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;",
        div(
          style = "display: inline-block; border: 3px solid #333; border-radius: 50%; width: 200px; height: 200px; padding: 20px; background: linear-gradient(to bottom, #ffeb3b 50%, #9c27b0 50%);",
          div(style = "padding-top: 70px; font-size: 18px; font-weight: bold; color: #333;",
              "30 🟡 / 30 🟣")
        ),
        p(style = "margin-top: 15px; font-style: italic;", 
          "⚠️ Avec autant de boules de chaque couleur, vous avez donc ", 
          strong("1 chance sur 2"), " de tirer chaque couleur.")
      ),
      
      p(strong("On tire au hasard une boule de l'urne. Deux possibilités se présentent à vous :")),
      
      div(style = "margin: 15px 0;",
        div(style = "background-color: #fff9c4; padding: 10px; border-left: 4px solid #fbc02d; margin-bottom: 10px;",
            p(strong("🟡 Tirage JAUNE :"), " vous récupérez les jetons investis et réduisez donc votre perte d'autant")),
        div(style = "background-color: #f3e5f5; padding: 10px; border-left: 4px solid #9c27b0;",
            p(strong("🟣 Tirage VIOLET :"), " vous perdez ", strong("3 fois"), " les jetons investis (en plus des jetons non investis) et aggravez donc votre perte d'autant"))
      ),
      
      hr(),
      
      div(
        style = "background-color: #e8f5e9; padding: 15px; border-radius: 5px; border-left: 4px solid #4caf50;",
        h5(icon("lightbulb"), " Exemple : Avec 4 jetons investis (et 6 jetons non investis) :"),
        tags$ul(
          tags$li(strong("🟡 Tirage JAUNE :"), " vous récupérez les 4 jetons investis",
                  br(), "→ Total perdu : les ", strong("6 jetons non-investis"), " (au lieu des 10 jetons initiaux)"),
          tags$li(strong("🟣 Tirage VIOLET :"), " vous perdez 3 × 4 = 12 jetons",
                  br(), "→ Total perdu : 12 + 6 (jetons non-investis) = ", strong("18 jetons"), " (au lieu des 10 jetons initiaux)")
        )
      ),
      
      hr(),
      
      h5("💰 Combien souhaitez-vous investir ?"),
      
      sliderInput(
        "risque_pertes_invest",
        "Je décide d'investir :",
        min = 0,
        max = 10,
        value = 0,
        step = 1,
        post = " jetons",
        width = "100%"
      ),
      
      # Résumé dynamique
      uiOutput("risque_pertes_summary")
    )
  )
}

# Section Ambiguïté Gains - Décision 3
section_ambiguite_gains_ui <- function() {
  tagList(
    div(class = "section-title", "Décision 3 - Investissez vos jetons"),
    wellPanel(
      div(
        style = "background-color: #fff3cd; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #ffc107;",
        p(icon("info-circle"), " ", 
          "Le tirage au sort de la décision donnant lieu à votre rémunération finale n'a lieu qu'à la fin de tous les jeux. ",
          strong("Vous disposez donc toujours à ce stade de vos 30 jetons initiaux."))
      ),
      
      div(
        style = "background-color: #e7f3ff; padding: 15px; border-radius: 5px; margin-bottom: 20px;",
        p(strong("Avec 10 de vos 30 jetons, vous pouvez :")),
        tags$ul(
          tags$li("Conserver les 10 jetons"),
          tags$li("OU investir tout ou une partie des 10 jetons dans un jeu de hasard")
        )
      ),
      
      hr(),
      
      h5(icon("dice"), " Comment fonctionne le jeu de hasard ?"),
      
      p("Une urne contient 60 boules : des boules ", 
        strong("JAUNES"), " et/ou des boules ", strong("VIOLETTES"), "."),
      
      div(
        style = "background-color: #fff3cd; padding: 15px; border-radius: 5px; margin: 15px 0; border-left: 4px solid #ff9800;",
        p(icon("exclamation-triangle"), " ", 
          strong("Vous ne savez pas combien il y a de boules de chaque couleur dans l'urne."),
          br(),
          "Il peut y avoir entre ", strong("0 et 60 boules 🟡"), " et entre ", strong("0 et 60 boules 🟣"), ".")
      ),
      
      # Visualisation de l'urne ambiguë
      div(
        style = "text-align: center; background-color: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;",
        div(
          style = "display: inline-block; border: 3px dashed #ff9800; border-radius: 50%; width: 200px; height: 200px; padding: 20px; background: linear-gradient(135deg, #ffeb3b 0%, #ffeb3b 25%, #9c27b0 25%, #9c27b0 50%, #ffeb3b 50%, #ffeb3b 75%, #9c27b0 75%);",
          div(style = "padding-top: 70px; font-size: 18px; font-weight: bold; color: #333; background-color: rgba(255,255,255,0.8); border-radius: 10px;",
              "🟡 ? / 🟣 ?")
        ),
        p(style = "margin-top: 15px; font-style: italic; color: #ff9800; font-weight: bold;", 
          "⚠️ Composition inconnue !")
      ),
      
      p(strong("On tire au hasard une boule de l'urne. Deux possibilités se présentent à vous :")),
      
      div(style = "margin: 15px 0;",
        div(style = "background-color: #fff9c4; padding: 10px; border-left: 4px solid #fbc02d; margin-bottom: 10px;",
            p(strong("🟡 Tirage JAUNE :"), " vous gagnez ", strong("3 fois"), " les jetons investis")),
        div(style = "background-color: #f3e5f5; padding: 10px; border-left: 4px solid #9c27b0;",
            p(strong("🟣 Tirage VIOLET :"), " vous perdez les jetons investis"))
      ),
      
      hr(),
      
      div(
        style = "background-color: #e8f5e9; padding: 15px; border-radius: 5px; border-left: 4px solid #4caf50;",
        h5(icon("lightbulb"), " Exemple : Avec 4 jetons investis (et 6 jetons conservés) :"),
        tags$ul(
          tags$li(strong("🟡 Tirage JAUNE :"), " vous gagnez 3 × 4 jetons = 12 jetons",
                  br(), "→ Après tirage, vous avez donc 12 + 6 (jetons conservés) = ", strong("18 jetons")),
          tags$li(strong("🟣 Tirage VIOLET :"), " vous perdez les 4 jetons investis et ne gagnez donc rien",
                  br(), "→ Après tirage, il vous reste donc les ", strong("6 jetons conservés"))
        )
      ),
      
      hr(),
      
      h5("💰 Combien souhaitez-vous investir ?"),
      
      sliderInput(
        "ambiguite_gains_invest",
        "Je décide d'investir :",
        min = 0,
        max = 10,
        value = 0,
        step = 1,
        post = " jetons",
        width = "100%"
      ),
      
      # Résumé dynamique
      uiOutput("ambiguite_gains_summary")
    )
  )
}

# Section Ambiguïté Pertes - Décision 4
section_ambiguite_pertes_ui <- function() {
  tagList(
    div(class = "section-title", "Décision 4 - Investissez vos jetons"),
    wellPanel(
      div(
        style = "background-color: #fff3cd; padding: 15px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #ffc107;",
        p(icon("info-circle"), " ", 
          "Le tirage au sort de la décision donnant lieu à votre rémunération finale n'a lieu qu'à la fin de tous les jeux. ",
          strong("Vous disposez donc toujours à ce stade de vos 30 jetons initiaux."))
      ),
      
      div(
        style = "background-color: #ffebee; padding: 15px; border-radius: 5px; margin-bottom: 20px;",
        p(strong("Avec 10 de vos 30 jetons, vous pouvez :")),
        tags$ul(
          tags$li("Ne rien faire et ", strong("perdre les 10 jetons")),
          tags$li("OU investir tout ou une partie des 10 jetons dans un jeu de hasard")
        )
      ),
      
      hr(),
      
      h5(icon("dice"), " Comment fonctionne le jeu de hasard ?"),
      
      p("Une urne contient 60 boules : des boules ", 
        strong("JAUNES"), " et/ou des boules ", strong("VIOLETTES"), "."),
      
      div(
        style = "background-color: #fff3cd; padding: 15px; border-radius: 5px; margin: 15px 0; border-left: 4px solid #ff9800;",
        p(icon("exclamation-triangle"), " ", 
          strong("Vous ne savez pas combien il y a de boules de chaque couleur dans l'urne."),
          br(),
          "Il peut y avoir entre ", strong("0 et 60 boules 🟡"), " et entre ", strong("0 et 60 boules 🟣"), ".")
      ),
      
      # Visualisation de l'urne ambiguë
      div(
        style = "text-align: center; background-color: #f8f9fa; padding: 20px; border-radius: 10px; margin: 20px 0;",
        div(
          style = "display: inline-block; border: 3px dashed #ff9800; border-radius: 50%; width: 200px; height: 200px; padding: 20px; background: linear-gradient(135deg, #ffeb3b 0%, #ffeb3b 25%, #9c27b0 25%, #9c27b0 50%, #ffeb3b 50%, #ffeb3b 75%, #9c27b0 75%);",
          div(style = "padding-top: 70px; font-size: 18px; font-weight: bold; color: #333; background-color: rgba(255,255,255,0.8); border-radius: 10px;",
              "🟡 ? / 🟣 ?")
        ),
        p(style = "margin-top: 15px; font-style: italic; color: #ff9800; font-weight: bold;", 
          "⚠️ Composition inconnue !")
      ),
      
      p(strong("On tire au hasard une boule de l'urne. Deux possibilités se présentent à vous :")),
      
      div(style = "margin: 15px 0;",
        div(style = "background-color: #fff9c4; padding: 10px; border-left: 4px solid #fbc02d; margin-bottom: 10px;",
            p(strong("🟡 Tirage JAUNE :"), " vous récupérez les jetons investis et réduisez donc votre perte d'autant")),
        div(style = "background-color: #f3e5f5; padding: 10px; border-left: 4px solid #9c27b0;",
            p(strong("🟣 Tirage VIOLET :"), " vous perdez ", strong("3 fois"), " les jetons investis (en plus des jetons non investis) et aggravez donc votre perte d'autant"))
      ),
      
      hr(),
      
      div(
        style = "background-color: #e8f5e9; padding: 15px; border-radius: 5px; border-left: 4px solid #4caf50;",
        h5(icon("lightbulb"), " Exemple : Avec 4 jetons investis (et 6 jetons non investis) :"),
        tags$ul(
          tags$li(strong("🟡 Tirage JAUNE :"), " vous récupérez les 4 jetons investis",
                  br(), "→ Total perdu : les ", strong("6 jetons non-investis"), " (au lieu des 10 jetons initiaux)"),
          tags$li(strong("🟣 Tirage VIOLET :"), " vous perdez 3 × 4 = 12 jetons",
                  br(), "→ Total perdu : 12 + 6 (jetons non-investis) = ", strong("18 jetons"), " (au lieu des 10 jetons initiaux)")
        )
      ),
      
      hr(),
      
      h5("💰 Combien souhaitez-vous investir ?"),
      
      sliderInput(
        "ambiguite_pertes_invest",
        "Je décide d'investir :",
        min = 0,
        max = 10,
        value = 0,
        step = 1,
        post = " jetons",
        width = "100%"
      ),
      
      # Résumé dynamique
      uiOutput("ambiguite_pertes_summary")
    )
  )
}

# ============================================================================
# FIN SECTIONS JEUX DE HASARD
# ============================================================================

# Section d'introduction
section_intro_ui <- function() {
  tagList(
    div(class = "section-title", "Introduction au questionnaire"),
    wellPanel(
      h4("Bienvenue dans la suite de cette étude !"),
      p("Après avoir complété les tâches de décision, nous allons maintenant nous intéresser à vos perceptions et comportements concernant l'intelligence artificielle en santé."),
      p("Le questionnaire se déroule en plusieurs parties :"),
      tags$ol(
        tags$li("Questions sur vos usages numériques"),
        tags$li("Questions sur votre santé"),
        tags$li("Bénéfices perçus de l'IA en santé"),
        tags$li("Craintes vis-à-vis de l'IA en santé"),
        tags$li("Vos usages numériques en santé"),
        tags$li("Quelques questions démographiques")
      ),
      p(strong("Durée estimée : 15-20 minutes")),
      p("Cliquez sur 'Suivant' pour commencer le questionnaire.")
    )
  )
}

# Section usages numériques
section_usages_numeriques_ui <- function() {
  tagList(
    div(class = "section-title", "Vos usages et habitudes numériques"),
    wellPanel(
      p("Dans cette partie, nous vous invitons à décrire vos usages des outils numériques."),
      
      # Question 1 : Fréquence d'utilisation - Format tableau compact
      h5("1. Au cours des 6 derniers mois, à quelle fréquence avez-vous utilisé ces outils ou services ?"),
      
      # Tableau avec radioButtons en ligne
      div(
        style = "margin: 20px 0;",
        
        # Assistants vocaux
        div(
          style = "border-bottom: 1px solid #ddd; padding: 10px 0;",
          strong("Assistants vocaux (Siri, Alexa, Google Assistant)"),
          radioButtons(
            "usage_freq_1",
            NULL,
            choices = c("Jamais", "< 1/mois", "≈ 1/mois", "≈ 1/sem.", "Plus./sem.", "≈ 1/jour", "Plus./jour"),
            selected = character(0),
            inline = TRUE
          )
        ),
        
        # Plateformes
        div(
          style = "border-bottom: 1px solid #ddd; padding: 10px 0;",
          strong("Plateformes (Netflix, YouTube, Spotify, Amazon…)"),
          radioButtons(
            "usage_freq_2",
            NULL,
            choices = c("Jamais", "< 1/mois", "≈ 1/mois", "≈ 1/sem.", "Plus./sem.", "≈ 1/jour", "Plus./jour"),
            selected = character(0),
            inline = TRUE
          )
        ),
        
        # GPS
        div(
          style = "border-bottom: 1px solid #ddd; padding: 10px 0;",
          strong("Suggestions d'itinéraires (Google Maps, Waze)"),
          radioButtons(
            "usage_freq_3",
            NULL,
            choices = c("Jamais", "< 1/mois", "≈ 1/mois", "≈ 1/sem.", "Plus./sem.", "≈ 1/jour", "Plus./jour"),
            selected = character(0),
            inline = TRUE
          )
        ),
        
        # Applications santé
        div(
          style = "border-bottom: 1px solid #ddd; padding: 10px 0;",
          strong("Applications de santé ou de suivi d'activité (Apple Health, Fitbit)"),
          radioButtons(
            "usage_freq_4",
            NULL,
            choices = c("Jamais", "< 1/mois", "≈ 1/mois", "≈ 1/sem.", "Plus./sem.", "≈ 1/jour", "Plus./jour"),
            selected = character(0),
            inline = TRUE
          )
        ),
        
        # Traduction
        div(
          style = "border-bottom: 1px solid #ddd; padding: 10px 0;",
          strong("Outils de traduction automatique (Google Translate, DeepL)"),
          radioButtons(
            "usage_freq_5",
            NULL,
            choices = c("Jamais", "< 1/mois", "≈ 1/mois", "≈ 1/sem.", "Plus./sem.", "≈ 1/jour", "Plus./jour"),
            selected = character(0),
            inline = TRUE
          )
        ),
        
        # Agents conversationnels
        div(
          style = "border-bottom: 1px solid #ddd; padding: 10px 0;",
          strong("Agent conversationnel (ChatGPT, Copilot, Gemini…)"),
          radioButtons(
            "usage_freq_6",
            NULL,
            choices = c("Jamais", "< 1/mois", "≈ 1/mois", "≈ 1/sem.", "Plus./sem.", "≈ 1/jour", "Plus./jour"),
            selected = character(0),
            inline = TRUE
          )
        ),
        
        # Réseaux sociaux
        div(
          style = "border-bottom: 1px solid #ddd; padding: 10px 0;",
          strong("Réseaux sociaux (LinkedIn, Facebook, Instagram, Snapchat…)"),
          radioButtons(
            "usage_freq_7",
            NULL,
            choices = c("Jamais", "< 1/mois", "≈ 1/mois", "≈ 1/sem.", "Plus./sem.", "≈ 1/jour", "Plus./jour"),
            selected = character(0),
            inline = TRUE
          )
        )
      ),
      
      hr(),
      
      # Question 2 : Connaissance de l'IA
      h5("2. Dans quelle mesure estimez-vous connaître le fonctionnement global de l'intelligence artificielle ?"),
      radioButtons(
        "connaissance_ia",
        NULL,
        choices = c(
          "Je ne le connais pas du tout",
          "Je le connais un peu",
          "Je le connais assez bien",
          "Je le connais bien",
          "Je le connais très bien"
        ),
        selected = character(0)
      ),
      
      hr(),
      
      # Question 3 : Opinion générale
      h5("3. De manière générale, avez-vous une opinion plutôt positive ou négative de l'intelligence artificielle ?"),
      radioButtons(
        "opinion_ia",
        NULL,
        choices = c(
          "Très positive",
          "Plutôt positive",
          "Plutôt négative",
          "Très négative",
          "Je ne sais pas"
        ),
        selected = character(0)
      ),
      
      hr(),
      
      # Question 4 : Raisons d'utilisation
      h5("4. Pour quelles raisons principales utilisez-vous généralement ces outils numériques ? (jusqu'à 3 réponses)"),
      checkboxGroupInput(
        "raisons_usage",
        NULL,
        choices = c(
          "Pour gagner du temps / aller plus vite" = "temps",
          "Pour accéder facilement à un large choix d'options ou de contenus" = "choix",
          "Parce que c'est disponible à tout moment (24h/24, 7j/7)" = "disponibilite",
          "Parce que c'est pratique (moins d'effort, mains libres, centralisation des services)" = "praticite",
          "Pour personnaliser l'expérience (contenus, conseils, suivi)" = "personnalisation",
          "Pour rester en contact avec d'autres personnes / entretenir son réseau" = "contact",
          "Pour m'informer ou apprendre de nouvelles choses" = "information",
          "Parce que cela me motive ou m'aide à améliorer mon quotidien" = "motivation",
          "Autre" = "autre"
        )
      ),
      
      hr(),
      
      # Question 5 : Freins
      h5("5. Qu'est-ce qui pourrait vous freiner dans l'utilisation de ces outils numériques ? (jusqu'à 3 réponses)"),
      checkboxGroupInput(
        "freins_usage",
        NULL,
        choices = c(
          "Crainte pour la protection de mes données personnelles" = "donnees",
          "Manque de confiance dans la fiabilité des résultats ou recommandations" = "fiabilite",
          "Complexité d'utilisation / manque de maîtrise technique" = "complexite",
          "Sentiment que cela n'apporte pas de réelle valeur ajoutée" = "valeur",
          "Coût trop élevé (abonnements, équipements)" = "cout",
          "Peur de devenir dépendant ou d'y passer trop de temps" = "dependance",
          "Préférence pour des solutions humaines ou traditionnelles" = "humain",
          "Crainte d'effets négatifs (santé mentale, concentration, motivation)" = "effets",
          "Autre" = "autre"
        )
      )
    )
  )
}

# Section santé
section_sante_ui <- function() {
  tagList(
    div(class = "section-title", "Votre santé et vous"),
    wellPanel(
      p("Dans cette section, nous allons nous intéresser à vos habitudes de vie au cours des 6 derniers mois."),
      
      # Question 1 : Activité physique
      div(
        class = "question-text",
        "1. Sur les 6 derniers mois, en moyenne, combien de fois par semaine avez-vous pratiqué une activité physique d'au moins 30 minutes ?"
      ),
      radioButtons(
        "activite_physique",
        NULL,
        choices = c(
          "Jamais",
          "1 fois par semaine",
          "2 à 3 fois par semaine",
          "4 fois ou plus par semaine"
        ),
        selected = character(0)
      ),
      
      # Question 2 : Fruits et légumes
      div(
        class = "question-text",
        "2. Sur les 6 derniers mois, combien de portions de fruits et légumes avez-vous consommé en moyenne par jour ?"
      ),
      radioButtons(
        "fruits_legumes",
        NULL,
        choices = c("0-1", "2-3", "4-5", "Plus de 5"),
        selected = character(0)
      ),
      
      # Question 3 : Produits transformés
      div(
        class = "question-text",
        "3. Sur les 6 derniers mois, à quelle fréquence avez-vous consommé des produits transformés riches en sucre, en sel ou en graisses ?"
      ),
      radioButtons(
        "produits_transformes",
        NULL,
        choices = c(
          "Jamais ou rarement",
          "1 à 2 fois par semaine",
          "3 à 4 fois par semaine",
          "Presque tous les jours"
        ),
        selected = character(0)
      ),
      
      # Question 4 : Alcool
      div(
        class = "question-text",
        "4. Au cours des 7 derniers jours, combien de verres de boissons alcoolisées avez-vous consommés au total ?"
      ),
      radioButtons(
        "alcool",
        NULL,
        choices = c(
          "0 verre",
          "1 à 3 verres",
          "4 à 6 verres",
          "7 à 10 verres",
          "11 verres ou plus"
        ),
        selected = character(0)
      ),
      
      # Question 5 : Gestion du stress
      div(
        class = "question-text",
        "5. Sur les 6 derniers mois, avez-vous eu recours à des techniques de gestion du stress ?"
      ),
      radioButtons(
        "gestion_stress",
        NULL,
        choices = c(
          "Oui, régulièrement (au moins 1 fois par semaine)",
          "Oui, occasionnellement",
          "Non"
        ),
        selected = character(0)
      ),
      
      # Question 6 : Sommeil
      div(
        class = "question-text",
        "6. En moyenne, combien d'heures de sommeil avez-vous par nuit ?"
      ),
      radioButtons(
        "sommeil",
        NULL,
        choices = c(
          "Moins de 5 heures",
          "5-6 heures",
          "7-8 heures",
          "Plus de 8 heures"
        ),
        selected = character(0)
      ),
      
      # Question 7 : Tabac
      div(
        class = "question-text",
        "7. Fumez-vous actuellement du tabac (cigarettes, cigare, pipe, cigarette électronique avec nicotine) ?"
      ),
      radioButtons(
        "tabac",
        NULL,
        choices = c(
          "Oui, quotidiennement",
          "Oui, occasionnellement",
          "Non"
        ),
        selected = character(0)
      ),
      
      # Question 8 : Bilan de santé
      div(
        class = "question-text",
        "8. À quelle fréquence réalisez-vous un bilan de santé général ?"
      ),
      radioButtons(
        "bilan_sante",
        NULL,
        choices = c(
          "Moins d'une fois tous les 5 ans",
          "Tous les 3 à 5 ans",
          "Tous les 1 à 2 ans",
          "Chaque année"
        ),
        selected = character(0)
      ),
      
      # Question 9 : Dépistage organisé
      div(
        class = "question-text",
        "9. Avez-vous déjà participé à un programme de dépistage organisé lorsque vous en faisiez partie du public cible ?"
      ),
      radioButtons(
        "depistage_organise",
        NULL,
        choices = c(
          "Oui, toujours",
          "Oui, parfois",
          "Non, jamais",
          "Je n'étais pas concerné(e)"
        ),
        selected = character(0)
      ),
      
      # Question 10 : Dépistage volontaire
      div(
        class = "question-text",
        "10. Avez-vous déjà réalisé des tests de dépistage volontaire (VIH, diabète, cholestérol, hypertension, etc.) ?"
      ),
      radioButtons(
        "depistage_volontaire",
        NULL,
        choices = c(
          "Oui, plusieurs fois",
          "Oui, une fois",
          "Non"
        ),
        selected = character(0)
      )
    )
  )
}

# Continué dans le prochain fichier...
