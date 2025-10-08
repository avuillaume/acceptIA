# 🚀 Démarrage Rapide

## 📋 Prérequis

- R version 4.0+
- RStudio (recommandé)

## ⚡ Installation en 30 secondes

```r
# Cloner ou télécharger le projet
# Ouvrir RStudio dans le dossier accep_IA/

# Définir le répertoire de travail (si besoin)
setwd("c:/Users/antho/Documents/DCE/accep_IA")

# Les packages s'installent automatiquement au premier lancement
```

---

## 🎯 Utilisation

### Scénario 1 : Je veux collecter des données

```r
source("lancer_app.R")
```

→ L'application Shiny s'ouvre dans votre navigateur  
→ Faites compléter le questionnaire aux participants  
→ Les données sont sauvegardées automatiquement dans `data/`

### Scénario 2 : J'ai des données et je veux les analyser

```r
source("lancer_analyse.R")
```

→ Le script charge les données de `data/`  
→ Génère tous les graphiques et statistiques  
→ Sauvegarde les résultats dans `resultats/`

### Scénario 3 : Je veux tout faire d'affilée

```r
# 1. Collecte
source("lancer_app.R")
# [Compléter le questionnaire, puis fermer l'app]

# 2. Analyse
source("lancer_analyse.R")
```

---

## ✅ Checklist avant le premier lancement

- [ ] R et RStudio sont installés
- [ ] Tous les fichiers du projet sont présents
- [ ] Le répertoire de travail est correctement défini (`getwd()`)
- [ ] Connexion internet disponible (pour installer les packages)

---

## 📊 Workflow complet

1. **Collecte** : Participants complètent le questionnaire (15-20 min)
2. **Sauvegarde** : Données dans `data/study_data.csv` et `.RData`
3. **Analyse** : Lance le script d'analyse → Résultats dans `resultats/`

---

## 🔧 En cas de problème

### L'application ne démarre pas
```r
# Vérifier l'installation des packages
install.packages(c("shiny", "shinyjs", "shinythemes", "DT", 
                   "dplyr", "tidyr", "ggplot2", "lavaan"))
```

### Message d'erreur "cannot find function"
```r
# Recharger tous les modules
source("modules/ui_modules.R")
source("modules/ui_modules_suite.R")
source("modules/server_modules.R")
source("modules/data_functions.R")
```

### Les données ne s'enregistrent pas
```r
# Créer manuellement le dossier data
dir.create("data")
```

---

## 📁 Où sont mes fichiers ?

```
accep_IA/
├── lancer_app.R               ← 🔵 Lance la collecte
├── lancer_analyse.R           ← 🟢 Lance l'analyse
├── app.R                      ← Application Shiny
├── analyse_donnees.R          ← Script d'analyse
├── README.md                  ← Documentation complète
├── GUIDE_ANALYSE.md           ← Guide d'analyse détaillé
├── modules/                   ← Code modulaire
├── data/                      ← 📂 VOS DONNÉES
│   ├── study_data.csv
│   └── study_data.RData
└── resultats/                 ← 📊 VOS RÉSULTATS
    ├── *.png                  ← Tous les graphiques
    ├── sem_results.txt        ← Résultats SEM
    └── sem_model_fit.rds      ← Modèle SEM
```

---

## 💡 Conseils d'utilisation

### Pour les tests
- Créez 5-10 réponses test avant de partager avec les vrais participants
- Vérifiez que les données s'enregistrent dans `data/`
- Lancez l'analyse pour vérifier que tout fonctionne

### Pour la collecte réelle
- Déployez sur shinyapps.io pour les participants distants
- Ou lancez localement pour les participants à proximité

### Pour l'analyse
- Au moins 10-15 participants pour le modèle SEM
- 50-100 participants pour des résultats robustes
- Réexécutez `lancer_analyse.R` après chaque ajout de données

---

## 🌐 Déploiement en ligne (optionnel)

Pour partager l'application avec des participants distants :

### Via shinyapps.io (gratuit jusqu'à 5 applications)

```r
# Installer rsconnect
install.packages("rsconnect")

# Configurer votre compte (une seule fois)
library(rsconnect)
rsconnect::setAccountInfo(
  name = "votre-nom",
  token = "votre-token",
  secret = "votre-secret"
)

# Déployer l'application
rsconnect::deployApp()
```

Suivez les instructions sur https://www.shinyapps.io/

---

## 📞 Support

Pour toute question :
1. Consultez le README.md pour la documentation complète
2. Vérifiez les messages d'erreur dans la console R
3. Contactez l'équipe de recherche

---

## 🎓 Workflow typique de recherche

```r
# Phase 1 : Pilote (5-10 participants)
source("lancer_app.R")
# → Tester le questionnaire

# Phase 2 : Collecte principale (N participants)
source("lancer_app.R")
# → Collecter toutes les données

# Phase 3 : Analyses
source("lancer_analyse.R")
# → Générer tous les résultats

# Phase 4 : Analyses approfondies
load("data/study_data.RData")
fit <- readRDS("resultats/sem_model_fit.rds")
# → Analyses personnalisées
```

---

## 💡 Astuces

### Réexécuter l'analyse après ajout de données

```r
source("lancer_analyse.R")
# Les graphiques sont mis à jour automatiquement
```

### Analyser un sous-groupe

```r
# Éditer analyse_donnees.R, ajouter après le chargement :
data <- data %>% filter(age >= 18, age <= 65)
```

---

**Version** : 2.0 (Architecture modulaire)  
**Date** : 4 octobre 2025  
**Projet** : Acceptabilité de l'IA en Santé
