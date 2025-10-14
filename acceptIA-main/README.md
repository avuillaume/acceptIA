# Application R Shiny - Acceptabilité de l'IA en Santé

## Description

Ce projet de recherche sur les **déterminants comportementaux de l'acceptabilité de l'intelligence artificielle en santé** comprend :

1. **Application Shiny** : Collecte de données auprès des participants via un questionnaire interactif
2. **Script d'analyse** : Analyse statistique complète avec modèles SEM (Structural Equation Modeling)

### ⚡ Nouveauté : Séparation collecte / analyse

Le projet est maintenant divisé en deux parties distinctes :
- **`app.R`** : Application Shiny pour la collecte de données uniquement (plus rapide et légère)
- **`analyse_donnees.R`** : Script d'analyse statistique complet et autonome

## Structure du projet

```
accep_IA/
├── app.R                           # Application Shiny (collecte uniquement)
├── analyse_donnees.R               # Script d'analyse statistique
├── lancer_app.R                    # Lanceur de l'application Shiny
├── lancer_analyse.R                # Lanceur de l'analyse
├── GUIDE_ANALYSE.md                # Guide détaillé de l'analyse
├── modules/
│   ├── ui_modules.R                # Modules UI (sections 1-7)
│   ├── ui_modules_suite.R          # Modules UI (sections 8-fin)
│   ├── server_modules.R            # Fonctions serveur et validation
│   └── data_functions.R            # Fonctions de gestion des données
├── data/                           # Dossier créé automatiquement
│   ├── study_data.csv              # Données collectées (CSV)
│   └── study_data.RData            # Données collectées (RData)
├── resultats/                      # Dossier créé par l'analyse
│   ├── *.png                       # Graphiques générés
│   ├── sem_results.txt             # Résultats du modèle SEM
│   └── sem_model_fit.rds           # Modèle SEM sauvegardé
└── README.md                       # Ce fichier
```

## Installation

### Prérequis

- R version 4.0 ou supérieure
- RStudio (recommandé)

### Packages nécessaires

#### Pour l'application Shiny (collecte de données)

```r
install.packages(c("shiny", "shinyjs", "shinythemes", "dplyr"))
```

#### Pour l'analyse statistique

```r
install.packages(c("dplyr", "tidyr", "ggplot2", "lavaan", "psych", "corrplot"))
```

Les packages manquants seront installés automatiquement au premier lancement.

## Utilisation

### 🔵 Étape 1 : Collecter les données

Lancez l'application Shiny pour la collecte de données :

```r
# Méthode 1 : Utiliser le lanceur
source("lancer_app.R")

# Méthode 2 : Lancer directement
shiny::runApp("app.R")
```

**OU** : Ouvrez le fichier `app.R` dans RStudio et cliquez sur le bouton "Run App"

### 🟢 Étape 2 : Analyser les données

Une fois les données collectées, lancez l'analyse :

```r
# Méthode 1 : Utiliser le lanceur (recommandé)
source("lancer_analyse.R")

# Méthode 2 : Lancer directement
source("analyse_donnees.R")
```

📊 Consultez le fichier **`GUIDE_ANALYSE.md`** pour plus de détails sur l'analyse.

### Navigation dans l'application

L'application comporte 2 onglets principaux :

#### 1. **Collecte de données**

Ce module permet aux participants de compléter l'étude. Les sections sont :

- **Consentement éclairé** : Les participants doivent accepter avant de commencer
- **Introduction** : Présentation de l'étude
- **Tâches d'aversion** (4 sections) :
  - Risque - Gains
  - Risque - Pertes
  - Ambiguïté - Gains
  - Ambiguïté - Pertes
- **Usages numériques** : Fréquence d'utilisation des outils numériques
- **Santé** : Habitudes de vie et comportements de prévention
- **IA en santé** : Perceptions des bénéfices et craintes
- **Usages numériques en santé** : Téléconsultation, Doctolib, ENS, etc.
- **Sociodémographiques** : Âge, sexe, éducation, etc.

**Navigation** : 
- Utilisez les boutons "Suivant" et "Précédent" pour naviguer
- La barre de progression indique l'avancement
- Les réponses sont validées avant de passer à la section suivante
- Les données sont sauvegardées automatiquement à la fin

#### 2. **À propos**

Informations sur l'étude, les objectifs et la méthodologie.

## Structure des données

### Variables collectées

**Aversions (12 variables)** :
- `RG1, RG2, RG3` : Risque - Gains (1 = option sûre, 2 = option risquée)
- `RP1, RP2, RP3` : Risque - Pertes
- `AG1, AG2, AG3` : Ambiguïté - Gains
- `AP1, AP2, AP3` : Ambiguïté - Pertes

**Perceptions IA (20 variables)** :
- `B1-B10` : Bénéfices perçus (échelle Likert 1-7)
- `C1-C10` : Craintes (échelle Likert 1-7)

**Usages numériques (12 variables)** :
- `usage_freq_1` à `usage_freq_7` : Fréquence d'utilisation
- `connaissance_ia` : Connaissance de l'IA
- `opinion_ia` : Opinion générale
- `raisons_usage` : Raisons d'utilisation (multiples, séparées par ";")
- `freins_usage` : Freins à l'utilisation (multiples)

**Santé (10 variables)** :
- `activite_physique`, `fruits_legumes`, `produits_transformes`
- `alcool`, `gestion_stress`, `sommeil`, `tabac`
- `bilan_sante`, `depistage_organise`, `depistage_volontaire`

**Usages santé (11 variables)** :
- `teleconsult_usage`, `doctolib_usage`, `ens_connaissance`
- `carte_vitale`, `objets_connectes`, `chatbot_sante`, etc.

**Sociodémographiques (7 variables)** :
- `age`, `sexe`, `education`, `situation_pro`
- `taille_ville`, `enfants`, `en_couple`

**Métadonnées** :
- `participant_id` : Identifiant unique du participant
- `timestamp` : Date et heure de complétion

### Format des données exportées

Les données sont sauvegardées dans le dossier `data/` :

- **CSV** : `study_data.csv` - Format tableur, facilement importable
- **RData** : `study_data.RData` - Format R natif, conserve les types de données

## Analyse des données

### Qu'est-ce qui est analysé ?

Le script `analyse_donnees.R` génère automatiquement :

✅ **Statistiques descriptives** : moyennes, écarts-types, distributions  
✅ **Visualisations** : histogrammes, boxplots, nuages de points, corrélations  
✅ **Modèle SEM** : équations structurelles avec lavaan  
✅ **Régressions** : analyses de prédiction  
✅ **Tests de groupes** : comparaisons par sexe, âge, etc.

### Scores composites calculés

```r
# Scores d'aversion (moyenne de 3 items chacun)
score_Risk_Gains, score_Risk_Losses
score_Ambig_Gains, score_Ambig_Losses

# Scores de perception (moyenne de 10 items chacun)
score_Benefices, score_Craintes
```

### Résultats générés

Tous les résultats sont sauvegardés dans le dossier **`resultats/`** :

- 📊 Graphiques (PNG) : distributions, corrélations, relations
- 📄 Résultats SEM (TXT) : indices d'ajustement, paramètres
- 💾 Modèle SEM (RDS) : objet R réutilisable

📖 **Consultez `GUIDE_ANALYSE.md` pour le guide complet**

### Analyses personnalisées

Pour aller plus loin :

```r
# Charger les données
load("data/study_data.RData")

# Recharger un modèle SEM sauvegardé
fit <- readRDS("resultats/sem_model_fit.rds")
summary(fit, standardized = TRUE)

# Créer vos propres analyses
library(dplyr)
data %>% 
  group_by(sexe) %>%
  summarise(mean_benef = mean(score_Benefices, na.rm = TRUE))
```

## Personnalisation

### Modifier les questions

Pour modifier les questions, éditez les fichiers dans le dossier `modules/` :

- **Aversions** : `ui_modules.R` - Fonction `section_aversion_ui()`
- **IA en santé** : `ui_modules_suite.R` - Fonction `section_ia_sante_ui()`
- **Autres sections** : Recherchez la fonction correspondante

### Modifier le modèle SEM

Éditez le fichier `modules/server_modules.R`, fonction `run_full_sem_model()` :

```r
model <- '
  # Ajoutez vos spécifications ici
  # Exemple : ajouter une covariable
  Benefices ~ Risk_Gains + Risk_Losses + age
'
```

### Changer l'apparence

Modifiez le thème dans `app.R` :

```r
theme = shinytheme("flatly")  # Changez "flatly" par un autre thème
```

Thèmes disponibles : cerulean, cosmo, flatly, journal, lumen, paper, readable, sandstone, simplex, spacelab, superhero, united, yeti

## Dépannage

### L'application ne se lance pas

1. Vérifiez que tous les fichiers sont présents (app.R et dossier modules/)
2. Vérifiez l'installation des packages :
   ```r
   installed.packages()[, "Package"]
   ```
3. Réinstallez les packages manquants

### Les données ne sont pas sauvegardées

1. Vérifiez que le dossier `data/` existe (il est créé automatiquement)
2. Vérifiez les permissions d'écriture du dossier
3. Consultez la console R pour les messages d'erreur

### Le modèle SEM échoue

1. Assurez-vous d'avoir au moins 10-15 participants
2. Vérifiez qu'il n'y a pas trop de données manquantes
3. Essayez avec un modèle simplifié

### Les questions ne s'affichent pas correctement

1. Vérifiez que les fichiers `ui_modules.R` et `ui_modules_suite.R` sont bien sourcés
2. Rechargez l'application (fermez et relancez)

## Support

Pour toute question ou problème :
1. Consultez ce README
2. Vérifiez les messages d'erreur dans la console R
3. Contactez l'équipe de recherche

## Licence et Utilisation

Cette application a été développée pour un projet de recherche académique. 

**Utilisation** : Libre pour la recherche académique  
**Modification** : Autorisée avec mention de la source  
**Redistribution** : Autorisée avec mention de la source

## Auteur

Développé pour le projet "Les déterminants comportementaux de l'acceptabilité de l'IA en santé"

Date de création : Octobre 2025

---

**Note** : Cette application respecte les principes éthiques de la recherche. Les données collectées sont anonymes et utilisées uniquement à des fins de recherche académique.
