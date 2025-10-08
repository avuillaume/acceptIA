# Guide d'analyse des données

## 📊 Séparation des fonctionnalités

Le projet a été restructuré pour séparer clairement :
- **Application Shiny** (`app.R`) : collecte de données uniquement
- **Script d'analyse** (`analyse_donnees.R`) : analyse statistique complète

## 🚀 Comment utiliser

### 1. Collecter les données avec Shiny

```r
# Lancer l'application de collecte
source("lancer_app.R")
# OU
shiny::runApp("app.R")
```

L'application Shiny :
- Présente le questionnaire aux participants
- Collecte les réponses
- Sauvegarde automatiquement dans `data/study_data.csv` et `data/study_data.RData`

### 2. Analyser les données

Une fois les données collectées, lancez le script d'analyse :

```r
# Exécuter l'analyse complète
source("analyse_donnees.R")
```

## 📈 Analyses réalisées

Le script `analyse_donnees.R` génère automatiquement :

### Statistiques descriptives
- Caractéristiques sociodémographiques
- Moyennes et écarts-types des scores
- Distribution des variables

### Visualisations
Tous les graphiques sont sauvegardés dans le dossier `resultats/` :
- `correlation_matrix.png` : Matrice de corrélations entre les scores
- `distribution_aversions.png` : Histogrammes des scores d'aversion
- `distribution_perceptions.png` : Histogrammes des bénéfices et craintes
- `benefices_vs_craintes.png` : Nuage de points avec tendance
- `boxplots_scores.png` : Comparaison visuelle de tous les scores

### Modèle SEM (Structural Equation Modeling)
- Modèle d'équations structurelles complet
- Relations entre aversions et perceptions de l'IA
- Indices d'ajustement du modèle
- Résultats sauvegardés dans `resultats/sem_results.txt`
- Objet modèle sauvegardé dans `resultats/sem_model_fit.rds`

### Analyses complémentaires
- Tests t pour comparaisons de groupes (par sexe)
- Régressions linéaires multiples

## 📁 Structure des fichiers

```
accep_IA/
│
├── app.R                    # Application Shiny (collecte uniquement)
├── analyse_donnees.R        # Script d'analyse (statistiques et SEM)
├── lancer_app.R             # Lanceur de l'app Shiny
│
├── modules/
│   ├── ui_modules.R         # Modules UI Shiny
│   ├── ui_modules_suite.R   # Suite des modules UI
│   ├── server_modules.R     # Fonctions serveur
│   └── data_functions.R     # Fonctions utilitaires
│
├── data/
│   ├── study_data.csv       # Données collectées (CSV)
│   └── study_data.RData     # Données collectées (RData)
│
└── resultats/               # Dossier créé automatiquement
    ├── correlation_matrix.png
    ├── distribution_aversions.png
    ├── distribution_perceptions.png
    ├── benefices_vs_craintes.png
    ├── boxplots_scores.png
    ├── sem_results.txt
    └── sem_model_fit.rds
```

## 🔧 Packages requis

### Pour l'application Shiny
```r
install.packages(c("shiny", "shinyjs", "shinythemes", "dplyr"))
```

### Pour l'analyse
```r
install.packages(c("dplyr", "tidyr", "ggplot2", "lavaan", "psych", "corrplot"))
```

## 💡 Avantages de cette séparation

1. **Performance** : L'application Shiny est plus légère et rapide
2. **Modularité** : Analyse et collecte sont indépendantes
3. **Reproductibilité** : Le script d'analyse peut être réexécuté facilement
4. **Flexibilité** : Possibilité d'analyser sans relancer l'application
5. **Clarté** : Chaque fichier a un rôle bien défini

## 📊 Réutiliser le modèle SEM

Pour recharger et examiner un modèle SEM déjà estimé :

```r
# Charger le modèle sauvegardé
fit <- readRDS("resultats/sem_model_fit.rds")

# Afficher le résumé
summary(fit, fit.measures = TRUE, standardized = TRUE)

# Extraire les paramètres
library(lavaan)
parameterEstimates(fit, standardized = TRUE)

# Indices d'ajustement
fitMeasures(fit)

# Visualiser (si semPlot est installé)
library(semPlot)
semPaths(fit, what = "std", layout = "tree")
```

## 📧 Support

Pour toute question sur l'utilisation ou l'analyse, consultez les commentaires dans les fichiers ou contactez l'équipe de recherche.

---

*Dernière mise à jour : 4 octobre 2025*
