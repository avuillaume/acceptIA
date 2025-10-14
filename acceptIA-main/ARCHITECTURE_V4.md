# 📐 Architecture finale de l'application - Version 4.0

**Date** : 5 octobre 2025  
**Application** : Acceptabilité de l'IA en Santé

---

## 🗂️ Structure des 14 sections

```
┌─────────────────────────────────────────────────────────────┐
│                    CONSENTEMENT (Section 0)                  │
│                  ✅ Acceptation participation                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                 BLOC 1 : TÂCHES D'AVERSION                   │
│                     (Sections 1-7)                           │
├─────────────────────────────────────────────────────────────┤
│  Section 1 : Introduction tâches rémunérées                 │
│              📋 Explication 30 jetons + taux conversion     │
│                                                              │
│  Section 2 : Tâche de comptage π                            │
│              🔢 Compter les "1" dans 200 décimales          │
│              → Variable: comptage_pi                         │
│                                                              │
│  Section 3 : Félicitations                                  │
│              🏆 Confirmation 30 jetons gagnés               │
│              📝 Instructions pour les jeux                   │
│                                                              │
│  Section 4 : 🎲 Risque Gains                                │
│              Urne 50/50 connue | 🟡 Gagner 3× | 🟣 Perdre   │
│              → Variable: risque_gains_invest (0-10)         │
│                                                              │
│  Section 5 : 🎲 Risque Pertes                               │
│              Urne 50/50 connue | 🟡 Récupérer | 🟣 Perdre 3×│
│              → Variable: risque_pertes_invest (0-10)        │
│                                                              │
│  Section 6 : 🎲 Ambiguïté Gains                             │
│              Urne inconnue | 🟡 Gagner 3× | 🟣 Perdre       │
│              → Variable: ambiguite_gains_invest (0-10)      │
│                                                              │
│  Section 7 : 🎲 Ambiguïté Pertes                            │
│              Urne inconnue | 🟡 Récupérer | 🟣 Perdre 3×    │
│              → Variable: ambiguite_pertes_invest (0-10)     │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│           BLOC 2 : QUESTIONNAIRE IA EN SANTÉ                 │
│                    (Sections 8-14)                           │
├─────────────────────────────────────────────────────────────┤
│  Section 8 : Introduction questionnaire                     │
│              📋 Transition vers questions IA                │
│                                                              │
│  Section 9 : Usages numériques                              │
│              💻 7 fréquences + opinion IA + raisons/freins  │
│                                                              │
│  Section 10 : Santé                                         │
│              🏃 10 questions habitudes de vie               │
│                                                              │
│  Section 11 : Bénéfices IA                                  │
│              ✅ 10 échelles Likert (1-7)                    │
│              → Variables: B1-B10                             │
│                                                              │
│  Section 12 : Craintes IA                                   │
│              ⚠️ 10 échelles Likert (1-7)                    │
│              → Variables: C1-C10                             │
│                                                              │
│  Section 13 : Usages santé numériques                       │
│              📱 Téléconsultation, Doctolib, ENS, objets...  │
│                                                              │
│  Section 14 : Sociodémographiques                           │
│              👤 7 variables (âge, sexe, éducation...)       │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    📊 FIN - Données sauvegardées
```

---

## 📦 Architecture des fichiers

```
accep_IA/
│
├── 📄 app.R                          [Application principale]
│   ├── UI (navbar, consentement, sections)
│   ├── Server (navigation, validation, sauvegarde)
│   └── Résumés dynamiques jeux de hasard
│
├── ▶️ lancer_app.R                   [Script de lancement]
│
├── 📁 modules/
│   ├── ui_modules.R                  [Sections 1-10 UI]
│   │   ├── section_aversion_intro_ui()
│   │   ├── section_tache_comptage_ui()
│   │   ├── section_felicitations_ui()
│   │   ├── section_risque_gains_ui()        ✨ NOUVEAU
│   │   ├── section_risque_pertes_ui()       ✨ NOUVEAU
│   │   ├── section_ambiguite_gains_ui()     ✨ NOUVEAU
│   │   ├── section_ambiguite_pertes_ui()    ✨ NOUVEAU
│   │   ├── section_intro_ui()
│   │   └── section_usages_numeriques_ui()
│   │
│   ├── ui_modules_suite.R            [Sections 11-14 UI]
│   │   ├── section_ia_benefices_ui()
│   │   ├── section_ia_craintes_ui()
│   │   ├── section_usages_sante_ui()
│   │   ├── section_sociodemographiques_ui()
│   │   └── section_fin_ui()
│   │
│   ├── server_modules.R              [Logique serveur]
│   │   ├── validate_current_section()
│   │   ├── save_section_data()
│   │   └── save_participant_data()
│   │
│   └── data_functions.R              [Fonctions analyses]
│
├── 📁 data/
│   ├── study_data.csv                [Données CSV]
│   └── study_data.RData              [Données R]
│
├── 📁 resultats/
│   └── [Analyses et graphiques]
│
└── 📁 Documentation/
    ├── AJOUT_JEUX_HASARD.md          ✨ NOUVEAU
    ├── RESUME_JEUX_HASARD.md         ✨ NOUVEAU
    ├── AJOUT_TACHES_AVERSION.md
    ├── MODIFICATIONS_SEPARATION_IA.md
    ├── RESUME_COMPLET_MODIFICATIONS.md
    ├── CHANGEMENTS.md
    ├── GUIDE_ANALYSE.md
    └── DEMARRAGE_RAPIDE.md
```

---

## 🔄 Flux de navigation

```
Démarrage
   ↓
Consentement
   ↓
Section 1 ──→ Suivant ──→ Section 2 ──→ ... ──→ Section 14
   ↑                                                ↓
   └────────── Précédent ───────────────────────────┘
                                                     ↓
                                            Sauvegarde + Fin
```

### À chaque changement de section :
1. ✅ Validation des réponses
2. 💾 Sauvegarde des données
3. ⬆️ Scroll automatique (smooth)
4. 📊 Mise à jour barre progression

---

## 💾 Variables collectées (par catégorie)

### 🎮 Aversions (4 variables)
```
risque_gains_invest          0-10 jetons
risque_pertes_invest         0-10 jetons
ambiguite_gains_invest       0-10 jetons
ambiguite_pertes_invest      0-10 jetons
```

### 🔢 Tâche
```
comptage_pi                  Nombre (réponse comptage)
```

### 💻 Usages numériques (12 variables)
```
usage_freq_1 à usage_freq_7  Échelles fréquence
connaissance_ia              Échelle connaissance
opinion_ia                   Échelle opinion
raisons_usage                Multi-choix (max 3)
freins_usage                 Multi-choix (max 3)
```

### 🏃 Santé (10 variables)
```
activite_physique, fruits_legumes, produits_transformes
alcool, gestion_stress, sommeil, tabac
bilan_sante, depistage_organise, depistage_volontaire
```

### 🤖 IA en santé (20 variables)
```
B1 à B10                     Bénéfices (échelles 1-7)
C1 à C10                     Craintes (échelles 1-7)
```

### 📱 Usages santé numériques (11 variables)
```
teleconsult_usage, teleconsult_motiv
doctolib_usage, doctolib_type, doctolib_documents, doctolib_medecin
ens_connaissance, ens_opinion
carte_vitale, objets_connectes, chatbot_sante
```

### 👤 Sociodémographiques (7 variables)
```
age, sexe, education, situation_pro
taille_ville, enfants, en_couple
```

**Total : ~65 variables collectées**

---

## 🎨 Éléments visuels

### Icônes Font Awesome
- ✅ `check-circle` - Validation
- 💡 `lightbulb` - Idées/Exemples
- ⚡ `bolt` - Important/Urgent
- 🏆 `trophy` - Félicitations
- 🎲 `dice` - Jeux de hasard
- 📊 `chart-bar` - Résumés
- ⚠️ `exclamation-triangle` - Avertissements
- ℹ️ `info-circle` - Informations

### Palette de couleurs

**Jeux de hasard :**
- 🔵 Bleu (#3498db) - Risque gains
- 🟠 Orange (#e67e22) - Risque pertes
- 🟡 Jaune (#ff9800) - Ambiguïté gains
- 🔴 Rouge (#ff5252) - Ambiguïté pertes

**Résultats :**
- 🟢 Vert (#27ae60) - Gains positifs
- 🔴 Rouge (#e74c3c) - Pertes négatives

**Interface :**
- 🔵 Bleu (#3498db) - Titres sections
- ⚪ Gris clair (#f8f9fa) - Fonds
- 🟡 Jaune pâle (#fff3cd) - Avertissements

---

## ⚙️ Fonctionnalités techniques

### Validation automatique
```r
validate_current_section(input, section)
  ├─ Sections 1,3,8 : Toujours valide (info)
  ├─ Section 2 : Vérifie comptage_pi
  ├─ Sections 4-7 : Toujours valide (sliders)
  ├─ Sections 9-13 : Vérifie réponses complètes
  └─ Section 14 : Vérifie toutes variables socio
```

### Sauvegarde progressive
```r
save_section_data(input, section, rv)
  ├─ Sections 2,4-7 : Sauvegarde valeurs jeux
  ├─ Sections 9-13 : Sauvegarde questionnaire
  └─ Section 14 : Sauvegarde socio + export CSV
```

### Résumés dynamiques
```r
output$risque_gains_summary <- renderUI({ ... })
  ├─ Calcul conservés = 10 - investis
  ├─ Calcul gains = conservés + (investis × 3)
  ├─ Affichage conditionnel résultats
  └─ Mise à jour temps réel
```

---

## 📊 Métriques de l'application

| Métrique | Valeur |
|----------|--------|
| **Sections totales** | 14 |
| **Variables collectées** | ~65 |
| **Jeux interactifs** | 4 |
| **Échelles Likert** | 20 |
| **Questions multi-choix** | 2 |
| **Lignes de code UI** | ~1500 |
| **Lignes de code Server** | ~400 |
| **Durée totale** | 25-30 min |
| **Taux de progression/section** | ~7.1% |

---

## 🚀 Points d'entrée

### Lancer l'application
```r
# Méthode 1 : Via script
source("lancer_app.R")

# Méthode 2 : Directe
shiny::runApp("app.R")

# Méthode 3 : Avec port
shiny::runApp("app.R", port = 8080)
```

### Accéder aux données
```r
# CSV
data <- read.csv("data/study_data.csv")

# RData
load("data/study_data.RData")

# Colonnes jeux de hasard
data[, c("risque_gains_invest", "risque_pertes_invest", 
         "ambiguite_gains_invest", "ambiguite_pertes_invest")]
```

---

## 📈 Analyses possibles

### Scores d'aversion
```r
# Aversion au risque
data$aversion_risque_gains <- 10 - data$risque_gains_invest
data$aversion_risque_pertes <- 10 - data$risque_pertes_invest

# Aversion à l'ambiguïté
data$diff_ambig_gains <- data$risque_gains_invest - data$ambiguite_gains_invest
data$diff_ambig_pertes <- data$risque_pertes_invest - data$ambiguite_pertes_invest
```

### Corrélations
```r
# Aversions vs Acceptabilité IA
cor.test(data$aversion_risque_gains, data$score_Benefices)
cor.test(data$diff_ambig_gains, data$score_Craintes)

# Modèle prédictif
lm(acceptabilite_ia ~ aversion_risque_gains + diff_ambig_gains + age + education)
```

---

**Architecture complète - Version 4.0**  
*Dernière mise à jour : 5 octobre 2025*
