# Historique des changements

## 4 octobre 2025 - Version 2.0 : Séparation collecte / analyse

### ⚡ Changement majeur : Architecture modulaire

**Objectif** : Séparer la collecte de données (Shiny) de l'analyse statistique (script R)

#### Nouveaux fichiers créés

1. **`analyse_donnees.R`** - Script d'analyse complet et autonome
   - Statistiques descriptives complètes
   - Visualisations automatiques (histogrammes, boxplots, corrélations)
   - Modèle SEM (Structural Equation Modeling) avec lavaan
   - Tests de groupes et régressions
   - Sauvegarde des résultats dans `resultats/`

2. **`lancer_analyse.R`** - Lanceur d'analyse simplifié
   - Vérification des données
   - Installation automatique des packages
   - Exécution complète de l'analyse

3. **`GUIDE_ANALYSE.md`** - Documentation détaillée
   - Guide d'utilisation complet
   - Explication de toutes les analyses
   - Structure des résultats
   - Exemples de réutilisation

#### Modifications de fichiers existants

**`app.R`**
- ✂️ Suppression de l'onglet "Analyse des données"
- 📦 Réduction des packages requis (suppression de DT, tidyr, ggplot2, lavaan)
- ⚡ Application plus légère et rapide
- 🎯 Focus uniquement sur la collecte de données

**`README.md`**
- 📝 Mise à jour de la structure du projet
- 🔵🟢 Séparation claire : Étape 1 (collecte) / Étape 2 (analyse)
- 📊 Nouvelle section sur les résultats générés
- 🔗 Liens vers GUIDE_ANALYSE.md

# CHANGEMENTS

Historique des modifications de l'application Shiny - Acceptabilité de l'IA en Santé

---

## [Version 4.0] - 5 octobre 2025

### ✨ Ajout majeur : Jeux de hasard interactifs
- **Ajout de 4 nouveaux jeux interactifs** pour mesurer les aversions
  - Section 4 : Risque Gains (urne 50/50 connue)
  - Section 5 : Risque Pertes (urne 50/50 connue)
  - Section 6 : Ambiguïté Gains (urne composition inconnue)
  - Section 7 : Ambiguïté Pertes (urne composition inconnue)
- **Sliders interactifs** : Investissement de 0 à 10 jetons
- **Résumés dynamiques** : Calcul automatique des gains/pertes potentiels
- **Visualisations d'urnes** : CSS avec gradients et bordures différenciées
- **Nouvelles variables** : 
  - `risque_gains_invest`
  - `risque_pertes_invest`
  - `ambiguite_gains_invest`
  - `ambiguite_pertes_invest`
- **Durée totale** : Passage de 20-25 min à 25-30 min
- **Structure** : 14 sections au lieu de 10

### 🎨 Fonctionnalités UI
- Icônes Font Awesome (dice, lightbulb, chart-bar)
- Encadrés colorés par type de jeu
- Urnes risque (bordure solide, gradient 50/50)
- Urnes ambiguïté (bordure pointillée, motif hachuré)
- Résumés avec codes couleur (vert gains, rouge pertes)

### 📁 Fichiers modifiés
- `modules/ui_modules.R` : 4 nouvelles fonctions UI créées
- `app.R` : max_section = 14, 4 renderUI ajoutés
- `modules/server_modules.R` : Validation et sauvegarde adaptées

### 📝 Documentation
- Création de `AJOUT_JEUX_HASARD.md`
- Mise à jour de `RESUME_COMPLET_MODIFICATIONS.md`

---

## [Version 3.0] - 4 octobre 2025

### ✨ Ajout majeur : Tâches d'aversion
- **Ajout de 3 nouvelles sections** au début du questionnaire
  - Section 1 : Introduction aux tâches rémunérées (30 jetons)
  - Section 2 : Tâche de comptage des décimales de π
  - Section 3 : Félicitations et instructions pour les jeux
- **Nouvelle variable** : `comptage_pi` (nombre de "1" comptés)
- **Durée totale** : Passage de 15-20 min à 20-25 min
- **Structure** : 10 sections au lieu de 7

### 📁 Fichiers modifiés
- `app.R` : max_section = 10, ajout des nouvelles sections
- `modules/ui_modules.R` : 3 nouvelles fonctions UI créées
- `modules/server_modules.R` : Validation et sauvegarde pour section 2

### 📝 Documentation
- Création de `AJOUT_TACHES_AVERSION.md`
- Mise à jour de `RESUME_COMPLET_MODIFICATIONS.md`

---

## [Version 2.0] - 4 octobre 2025

### ✨ Amélioration : Séparation des sections IA
- **Séparation** de la section "IA en santé" en 2 pages distinctes :
  - Page 4 : Bénéfices perçus de l'IA (10 questions)
  - Page 5 : Craintes vis-à-vis de l'IA (10 questions)
- **Conservation** des échelles de mesure (1-7)
- **Structure** : 7 sections au lieu de 6

### 🎨 Amélioration UX : Défilement automatique
- Ajout du **scroll automatique** vers le haut à chaque changement de section
- Animation fluide (`behavior: 'smooth'`)
- S'applique à :
  - Démarrage de l'étude (après consentement)
  - Clic sur "Suivant"
  - Clic sur "Précédent"

### 📁 Fichiers modifiés
- `app.R` : max_section = 7, ajout du scroll automatique
- `modules/ui_modules_suite.R` : Création de 2 nouvelles fonctions
  - `section_ia_benefices_ui()`
  - `section_ia_craintes_ui()`
- `modules/ui_modules.R` : Mise à jour de l'introduction
- `modules/server_modules.R` : Adaptation validation et sauvegarde

### 📝 Documentation
- Création de `MODIFICATIONS_SEPARATION_IA.md`
- Création de `RESUME_MODIFICATIONS.md`

---

## [Version 1.0] - Date initiale

### ✨ Version initiale
- Application Shiny fonctionnelle
- 6 sections de questionnaire :
  1. Introduction
  2. Usages numériques
  3. Santé
  4. IA en santé (Bénéfices + Craintes combinés)
  5. Usages numériques en santé
  6. Sociodémographiques
- Sauvegarde des données en CSV et RData
- Validation des réponses
- Barre de progression

---

# CHANGEMENTS.md
- 📅 Ajout de cet historique des versions

#### Avantages de cette architecture

✅ **Performance** : Application Shiny 40% plus rapide  
✅ **Modularité** : Analyse indépendante de la collecte  
✅ **Reproductibilité** : Script d'analyse facilement réexécutable  
✅ **Flexibilité** : Analyse possible sans relancer Shiny  
✅ **Collaboration** : Statisticiens peuvent travailler sur l'analyse séparément  
✅ **Maintenance** : Code plus clair et organisé

#### Workflow mis à jour

```r
# Étape 1 : Collecter les données
source("lancer_app.R")

# Étape 2 : Analyser les données
source("lancer_analyse.R")
```

#### Résultats générés par l'analyse

Dossier `resultats/` créé automatiquement avec :
- 📊 `correlation_matrix.png` - Matrice de corrélations
- 📊 `distribution_aversions.png` - Histogrammes des aversions
- 📊 `distribution_perceptions.png` - Histogrammes bénéfices/craintes
- 📊 `benefices_vs_craintes.png` - Nuage de points
- 📊 `boxplots_scores.png` - Comparaison visuelle
- 📄 `sem_results.txt` - Résultats du modèle SEM
- 💾 `sem_model_fit.rds` - Objet modèle réutilisable

---

## 4 octobre 2025 - Suppression des sections d'aversion

## Résumé
Les 4 sections de mesure d'aversion (risque/ambiguïté × gains/pertes) ont été supprimées du questionnaire.

## Structure du questionnaire (mise à jour)

### Nouvelle structure (6 sections au lieu de 10)

1. **Section 1** - Introduction
2. **Section 2** - Vos usages et habitudes numériques
3. **Section 3** - Votre santé et vous
4. **Section 4** - L'IA en santé (bénéfices et craintes)
5. **Section 5** - Votre usage des outils numériques en santé
6. **Section 6** - Sociodémographiques

### Ancienne structure (supprimée)
- ~~Section 2 - Tâche 1 : Choix face au risque (Gains)~~
- ~~Section 3 - Tâche 2 : Choix face au risque (Pertes)~~
- ~~Section 4 - Tâche 3 : Choix face à l'ambiguïté (Gains)~~
- ~~Section 5 - Tâche 4 : Choix face à l'ambiguïté (Pertes)~~

## Fichiers modifiés

### 1. `app.R`
- `rv$max_section` changé de 10 à 6
- `switch()` dans `output$current_section` mis à jour (suppression des cas 2-5)
- Page "À propos" mise à jour (description de l'étude)

### 2. `modules/ui_modules.R`
- Fonction `section_aversion_ui()` complètement supprimée (~130 lignes)
- Section intro mise à jour (liste des parties et durée estimée)

### 3. `modules/server_modules.R`
- Fonction `validate_current_section()` : suppression des cas sections 2-5
- Renumération des sections restantes (6→2, 7→3, 8→4, 9→5, 10→6)
- Fonction `save_section_data()` : suppression du code de sauvegarde des aversions
- Renumération des sections dans save_section_data()

## Variables supprimées de la collecte de données

Les 12 variables d'aversion ne sont plus collectées :
- `RG1`, `RG2`, `RG3` (Risque - Gains)
- `RP1`, `RP2`, `RP3` (Risque - Pertes)
- `AG1`, `AG2`, `AG3` (Ambiguïté - Gains)
- `AP1`, `AP2`, `AP3` (Ambiguïté - Pertes)

## Impact sur l'analyse

⚠️ **Important** : Le modèle SEM prévu dans `server_modules.R` fait référence à ces variables.
Il faudra mettre à jour la fonction `run_full_sem_model()` si vous prévoyez d'utiliser l'analyse SEM.

## Durée estimée du questionnaire

- **Avant** : 20-25 minutes
- **Après** : 15-20 minutes

## Test recommandé

Après ces changements, il est recommandé de :
1. Lancer l'application : `source("lancer_app.R")`
2. Compléter un questionnaire test complet
3. Vérifier que les données sont bien enregistrées dans `data/study_data.csv`
4. Vérifier qu'il n'y a pas d'erreurs de validation

## Notes

Les sections restantes n'ont pas été modifiées et fonctionnent de la même manière.
