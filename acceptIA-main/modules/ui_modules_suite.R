# ============================================================================
# MODULES UI - Suite (IA en santé, usages santé, socio-démographiques, fin)
# ============================================================================

# Section IA en santé - Partie A : Bénéfices perçus
section_ia_benefices_ui <- function(section_number = "A") {
  
  # Liste des items pour les bénéfices (25 items)
  benefices_items <- c(
    # Prévention et suivi
    "L'IA peut aider à détecter plus tôt certaines maladies",
    "L'IA peut encourager les comportements préventifs",
    "L'IA peut personnaliser les recommandations de prévention",
    "L'IA peut améliorer la qualité du suivi médical en continu",
    "L'IA peut alerter en cas de risque accru",
    
    # Qualité et précision
    "L'IA peut fournir des diagnostics plus rapides",
    "L'IA peut améliorer la précision des diagnostics",
    "L'IA peut réduire les erreurs médicales",
    "L'IA peut suggérer des options thérapeutiques adaptées",
    "L'IA peut compléter l'expertise humaine des médecins",
    
    # Accessibilité et équité
    "L'IA peut rendre l'accès à l'information médicale plus facile",
    "L'IA peut réduire les inégalités d'accès aux soins",
    "L'IA peut donner un accès plus rapide à un avis médical",
    
    # Coût et efficacité
    "L'IA peut réduire le coût global des soins de santé",
    "L'IA peut optimiser l'utilisation des ressources médicales",
    "L'IA peut réduire les délais d'attente pour les patients",
    "L'IA peut aider à mieux gérer la charge de travail des soignants",
    
    # Autonomie et expérience patient
    "L'IA peut donner aux patients plus de contrôle sur leur santé",
    "L'IA peut améliorer la compréhension des patients sur leur état de santé",
    "L'IA peut renforcer l'adhésion aux traitements",
    "L'IA peut favoriser un suivi personnalisé au quotidien",
    
    # Bénéfices collectifs
    "L'IA peut améliorer la recherche médicale",
    "L'IA peut contribuer à une meilleure anticipation des épidémies",
    "L'IA peut soutenir la santé publique par des programmes de prévention ciblés",
    "L'IA peut améliorer la planification du système de santé"
  )
  
  tagList(
    div(class = "section-title", paste0(section_number, ". Bénéfices perçus de l'IA en santé")),
    wellPanel(
      p("Cette partie porte sur vos perceptions de l'intelligence artificielle appliquée à la santé."),
      p("Pour chaque affirmation, indiquez dans quelle mesure vous êtes d'accord."),
      p(strong("Échelle : 1 = Tout à fait en désaccord, 7 = Tout à fait d'accord")),
      
      # Générer les questions pour les bénéfices (sélection de 10 items pour ne pas surcharger)
      lapply(1:10, function(i) {
        div(
          style = "margin-bottom: 30px;",
          div(class = "question-text", paste0(i, ". ", benefices_items[i])),
          sliderInput(
            paste0("B", i),
            NULL,
            min = 1,
            max = 7,
            value = 4,
            step = 1,
            ticks = TRUE,
            width = "100%"
          ),
          div(
            style = "display: flex; justify-content: space-between; font-size: 12px; color: #6c757d; font-style: italic; margin-top: -10px;",
            tags$span("1 = Tout à fait en désaccord"),
            tags$span("7 = Tout à fait d'accord")
          )
        )
      })
    )
  )
}

# Section IA en santé - Partie B : Craintes
section_ia_craintes_ui <- function(section_number = "B") {
  
  # Liste des items pour les craintes (22 items)
  craintes_items <- c(
    # Fiabilité et qualité
    "L'IA peut donner des diagnostics erronés",
    "L'IA peut manquer de fiabilité dans certaines situations complexes",
    "L'IA peut être trop dépendante de la qualité des données",
    "L'IA peut ignorer certains facteurs cliniques importants",
    "L'IA peut conduire à une baisse de vigilance des médecins",
    
    # Perte de contrôle humain
    "L'IA peut réduire le rôle de décision des médecins",
    "L'IA peut diminuer la relation humaine entre patient et médecin",
    "L'IA peut rendre les patients plus dépendants de la technologie",
    "L'IA peut donner le sentiment d'un manque de contrôle sur sa propre santé",
    
    # Protection et utilisation des données
    "L'IA peut menacer la confidentialité des données médicales",
    "L'IA peut être utilisée à des fins commerciales non souhaitées",
    "L'IA peut conduire à des fuites ou piratages de données personnelles",
    "L'IA peut collecter plus d'informations que nécessaire",
    "L'IA peut utiliser les données de santé sans consentement éclairé",
    
    # Biais, inégalités et justice
    "L'IA peut reproduire des biais présents dans les données médicales",
    "L'IA peut entraîner des discriminations envers certains groupes",
    "L'IA peut aggraver les inégalités d'accès aux soins",
    "L'IA peut être conçue de manière non transparente",
    
    # Conséquences systémiques
    "L'IA peut augmenter la dépendance globale du système de santé à la technologie",
    "L'IA peut entraîner une déshumanisation de la médecine",
    "L'IA peut accroître la responsabilité légale en cas d'erreur",
    "L'IA peut détourner des ressources financières d'autres priorités"
  )
  
  tagList(
    div(class = "section-title", paste0(section_number, ". Craintes vis-à-vis de l'IA en santé")),
    wellPanel(
      p("Cette partie porte sur vos craintes concernant l'intelligence artificielle appliquée à la santé."),
      p("Pour chaque affirmation, indiquez dans quelle mesure vous êtes d'accord."),
      p(strong("Échelle : 1 = Tout à fait en désaccord, 7 = Tout à fait d'accord")),
      
      # Générer les questions pour les craintes (sélection de 10 items)
      lapply(1:10, function(i) {
        div(
          style = "margin-bottom: 30px;",
          div(class = "question-text", paste0(i, ". ", craintes_items[i])),
          sliderInput(
            paste0("C", i),
            NULL,
            min = 1,
            max = 7,
            value = 4,
            step = 1,
            ticks = TRUE,
            width = "100%"
          ),
          div(
            style = "display: flex; justify-content: space-between; font-size: 12px; color: #6c757d; font-style: italic; margin-top: -10px;",
            tags$span("1 = Tout à fait en désaccord"),
            tags$span("7 = Tout à fait d'accord")
          )
        )
      })
    )
  )
}

# Section usages numériques en santé
section_usages_sante_ui <- function() {
  tagList(
    div(class = "section-title", "Votre usage des outils numériques en santé"),
    wellPanel(
      # Téléconsultations
      h5("Téléconsultations"),
      
      div(
        class = "question-text",
        "1. Avez-vous déjà eu recours à une téléconsultation médicale ?"
      ),
      radioButtons(
        "teleconsult_usage",
        NULL,
        choices = c(
          "Oui, à plusieurs reprises",
          "Oui, une fois",
          "Non, jamais"
        ),
        selected = character(0)
      ),
      
      div(
        class = "question-text",
        "2. Si vous avez eu recours à une téléconsultation, votre choix était principalement motivé par :"
      ),
      checkboxGroupInput(
        "teleconsult_motiv",
        NULL,
        choices = c(
          "Une préférence personnelle (plus pratique, gain de temps)" = "preference",
          "Une obligation (pas d'autre disponibilité)" = "obligation",
          "Une raison sanitaire (éviter les contacts)" = "sanitaire",
          "Autre" = "autre"
        )
      ),
      
      hr(),
      
      # Doctolib
      h5("Plateforme de prise de rendez-vous (Doctolib ou équivalent)"),
      
      div(
        class = "question-text",
        "3. Utilisez-vous une plateforme de type Doctolib pour prendre vos rendez-vous médicaux ?"
      ),
      radioButtons(
        "doctolib_usage",
        NULL,
        choices = c(
          "Oui, toujours",
          "Oui, parfois",
          "Non, jamais"
        ),
        selected = character(0)
      ),
      
      div(
        class = "question-text",
        "4. Votre utilisation de cette plateforme correspond plutôt à :"
      ),
      radioButtons(
        "doctolib_type",
        NULL,
        choices = c(
          "Un choix personnel (je trouve l'outil pratique)",
          "Une contrainte (mon médecin n'accepte que les rendez-vous via la plateforme)",
          "Je préfère appeler directement ou prendre rendez-vous sur place"
        ),
        selected = character(0)
      ),
      
      div(
        class = "question-text",
        "5. Déposez-vous personnellement des documents médicaux sur Doctolib ou autre plateforme similaire ?"
      ),
      radioButtons(
        "doctolib_documents",
        NULL,
        choices = c(
          "Oui, régulièrement",
          "Oui, parfois",
          "Non, jamais"
        ),
        selected = character(0)
      ),
      
      div(
        class = "question-text",
        "6. Êtes-vous à l'aise avec le fait que votre médecin dépose des documents sur ces plateformes ?"
      ),
      radioButtons(
        "doctolib_medecin",
        NULL,
        choices = c(
          "Tout à fait à l'aise",
          "Plutôt à l'aise",
          "Plutôt pas à l'aise",
          "Pas du tout à l'aise"
        ),
        selected = character(0)
      ),
      
      hr(),
      
      # Espace Numérique de Santé
      h5(" Mon Espace Santé ou Espace Numérique de Santé (ENS)"),
      
      div(
        class = "question-text",
        "7. Aviez-vous déjà entendu parler de l'Espace Numérique de Santé ou du dossier médical partagé ?"
      ),
      radioButtons(
        "ens_connaissance",
        NULL,
        choices = c("Oui", "Non"),
        selected = character(0)
      ),
      
      div(
        class = "question-text",
        "8. Que pensez-vous de l'existence d'un espace numérique centralisé regroupant vos données de santé ?"
      ),
      radioButtons(
        "ens_opinion",
        NULL,
        choices = c(
          "C'est une très bonne chose",
          "C'est utile mais je crains pour la confidentialité",
          "Je suis opposé(e) à ce type de dispositif",
          "Je n'ai pas d'opinion"
        ),
        selected = character(0)
      ),
      
      hr(),
      
      # Carte Vitale enrichie
      h5("Carte Vitale enrichie"),
      
      div(
        class = "question-text",
        "9. Seriez-vous favorable à ce que votre carte Vitale contienne l'ensemble de votre historique médical ?"
      ),
      radioButtons(
        "carte_vitale",
        NULL,
        choices = c(
          "Oui, tout à fait favorable",
          "Plutôt favorable",
          "Plutôt opposé(e)",
          "Tout à fait opposé(e)"
        ),
        selected = character(0)
      ),
      
      hr(),
      
      # Applications et objets connectés
      div(
        class = "question-text",
        "10. Utilisez-vous actuellement des applications ou objets connectés pour suivre votre santé ?"
      ),
      radioButtons(
        "objets_connectes",
        NULL,
        choices = c(
          "Oui, régulièrement",
          "Oui, parfois",
          "Non, jamais"
        ),
        selected = character(0)
      ),
      
      # Agent conversationnel pour la santé
      div(
        class = "question-text",
        "11. Avez-vous déjà utilisé un agent conversationnel (ChatGPT, Copilot, Gemini…) pour poser une question relative à votre santé ?"
      ),
      radioButtons(
        "chatbot_sante",
        NULL,
        choices = c(
          "Oui, régulièrement",
          "Oui, une fois ou quelques fois",
          "Non, jamais"
        ),
        selected = character(0)
      )
    )
  )
}

# Section sociodémographiques
section_sociodemographiques_ui <- function() {
  tagList(
    div(class = "section-title", "Questions socio-démographiques"),
    wellPanel(
      p("Ces dernières questions nous permettront de mieux comprendre les profils des participants."),
      p("Vos réponses resteront strictement confidentielles et anonymes."),
      
      # Âge
      div(
        class = "question-text",
        "1. Quel est votre âge ?"
      ),
      numericInput(
        "age",
        NULL,
        value = NULL,
        min = 18,
        max = 120,
        step = 1
      ),
      
      # Sexe
      div(
        class = "question-text",
        "2. Quel est votre sexe ?"
      ),
      radioButtons(
        "sexe",
        NULL,
        choices = c(
          "Homme",
          "Femme",
          "Préfère ne pas répondre"
        ),
        selected = character(0)
      ),
      
      # Niveau d'éducation
      div(
        class = "question-text",
        "3. Quel est le plus haut niveau d'éducation que vous ayez obtenu ?"
      ),
      radioButtons(
        "education",
        NULL,
        choices = c(
          "CAP, BEP",
          "Baccalauréat",
          "BTS, DUT",
          "Licence, BUT",
          "Master, diplôme d'ingénieur",
          "Doctorat",
          "Autre"
        ),
        selected = character(0)
      ),
      
      # Situation professionnelle
      div(
        class = "question-text",
        "4. Quelle est votre situation professionnelle ?"
      ),
      radioButtons(
        "situation_pro",
        NULL,
        choices = c(
          "Agriculteur exploitant",
          "Artisan, commerçant et chef d'entreprise",
          "Cadre et profession intellectuelle supérieure",
          "Professions intermédiaires",
          "Employés",
          "Ouvrier",
          "Retraité",
          "Étudiant",
          "Personne sans activité professionnelle",
          "Autre"
        ),
        selected = character(0)
      ),
      
      # Taille de la ville
      div(
        class = "question-text",
        "5. Quelle est la taille de la population de votre ville de résidence ?"
      ),
      radioButtons(
        "taille_ville",
        NULL,
        choices = c(
          "Moins de 20 000 habitants",
          "Entre 20 000 et 100 000 habitants",
          "Plus de 100 000 habitants"
        ),
        selected = character(0)
      ),
      
      # Enfants
      div(
        class = "question-text",
        "6. Avez-vous des enfants ?"
      ),
      radioButtons(
        "enfants",
        NULL,
        choices = c("Oui", "Non"),
        selected = character(0)
      ),
      
      # En couple
      div(
        class = "question-text",
        "7. Êtes-vous en couple ?"
      ),
      radioButtons(
        "en_couple",
        NULL,
        choices = c("Oui", "Non"),
        selected = character(0)
      )
    )
  )
}

# Section de fin
section_fin_ui <- function() {
  tagList(
    div(class = "section-title", "Merci pour votre participation !"),
    wellPanel(
      h4("Votre participation est terminée"),
      p("Merci beaucoup d'avoir pris le temps de répondre à ce questionnaire."),
      p("Vos réponses ont été enregistrées et seront utilisées de manière anonyme pour cette recherche."),
      
      hr(),
      
      h4(style = "color: #2c3e50;", "🎲 Résultat du tirage au sort"),
      p("Selon le protocole de l'étude, une de vos décisions a été sélectionnée aléatoirement et le tirage au sort a été effectué pour déterminer votre rémunération finale."),
      
      # Zone pour afficher les résultats du tirage
      uiOutput("lottery_results_display"),
      
      hr(),
      
      p("Si vous avez des questions concernant cette étude ou votre rémunération, n'hésitez pas à contacter les chercheurs."),
      
      div(
        style = "text-align: center; margin-top: 30px;",
        actionButton(
          "btn_fermer",
          "Fermer cette fenêtre",
          class = "btn-primary btn-lg",
          onclick = "window.close();"
        ),
        br(), br(),
        p(style = "color: #6c757d; font-style: italic;", 
          "Cette fenêtre se fermera automatiquement dans 1 minute.")
      ),
      
      # Script pour fermer automatiquement la fenêtre après 60 secondes
      tags$script(HTML("
        setTimeout(function() {
          window.close();
        }, 60000);
      "))
    )
  )
}
