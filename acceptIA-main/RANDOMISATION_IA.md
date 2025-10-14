# Randomisation de l'ordre Bénéfices/Craintes de l'IA

## Description

Pour éviter les biais d'ordre dans l'évaluation des perceptions de l'IA en santé, l'ordre de présentation des sections **"Bénéfices perçus de l'IA"** et **"Craintes vis-à-vis de l'IA"** est randomisé pour chaque participant.

## Fonctionnement

- **50% des participants** verront d'abord la section "Bénéfices" (section A), puis "Craintes" (section B)
- **50% des participants** verront d'abord la section "Craintes" (section A), puis "Bénéfices" (section B)

La randomisation est effectuée au moment où le participant clique sur "Commencer l'étude" et reste constante pour toute la durée de sa session.

## Variables sauvegardées

Dans le fichier de données `data/study_data.csv`, deux variables permettent de savoir quel ordre a été présenté à chaque participant :

1. **`benefices_first`** : Variable booléenne
   - `TRUE` = Le participant a vu les Bénéfices en premier
   - `FALSE` = Le participant a vu les Craintes en premier

2. **`ordre_IA`** : Variable texte plus lisible
   - `"Benefices_puis_Craintes"` = Le participant a vu les Bénéfices en premier
   - `"Craintes_puis_Benefices"` = Le participant a vu les Craintes en premier

## Utilisation dans l'analyse

Ces variables permettent de :
- Contrôler les effets d'ordre dans les analyses statistiques
- Tester si l'ordre de présentation influence les réponses
- Équilibrer les groupes dans les analyses comparatives

## Exemple de code R pour l'analyse

```r
# Charger les données
data <- read.csv("data/study_data.csv")

# Vérifier la distribution de la randomisation
table(data$ordre_IA)

# Tester l'effet d'ordre sur les scores moyens
library(dplyr)

# Score moyen Bénéfices selon l'ordre
data %>%
  group_by(ordre_IA) %>%
  summarise(
    score_benefices_moyen = mean(c_across(starts_with("B")), na.rm = TRUE),
    score_craintes_moyen = mean(c_across(starts_with("C")), na.rm = TRUE)
  )

# Test statistique de l'effet d'ordre
t.test(score_benefices ~ benefices_first, data = data)
```

## Implémentation technique

La randomisation est implémentée dans `app.R` via :
```r
rv <- reactiveValues(
  benefices_first = sample(c(TRUE, FALSE), 1)
)
```

L'affichage conditionnel est géré dans la fonction `output$current_section` qui affiche les sections 11 et 12 dans l'ordre randomisé.

---

**Date de mise en œuvre :** Octobre 2025
