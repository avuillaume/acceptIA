# 🔄 Modification des décisions 5-8 : Format "Choix d'urnes"

**Date** : 15 octobre 2025  
**Modification majeure** : Remplacement du format "slider d'investissement" par "choix multiple d'urnes"

---

## 🎯 Changement effectué

Les **décisions 5 à 8** sont passées d'un format avec **slider d'investissement (0-10 jetons)** à un format de **choix multiples entre différentes urnes** (options A, B, C, D, E).

### ❌ Ancien format (supprimé)
- Slider : "Je décide d'investir : ___ jetons"
- Résumé dynamique calculant gains/pertes
- Variables : `risque_gains_2_invest`, `risque_pertes_2_invest`, etc.

### ✅ Nouveau format (implémenté)
- **Choix d'urnes** : Sélection parmi plusieurs options (A-E)
- **Tableaux comparatifs** : Composition d'urnes + résultats possibles
- **Variables** : `risque_pertes_2_choix`, `ambiguite_pertes_2_choix`, `risque_gains_2_choix`, `ambiguite_gains_2_choix`

---

## 📋 Détail des 4 nouvelles décisions

### **Décision 5 : Risque Pertes** (Section 8)

**Type** : Choix entre 4 urnes connues (A-D)  
**Variable** : `risque_pertes_2_choix` (valeurs : A, B, C, D)

| Option | Contenu urne | Résultat | Description |
|--------|--------------|----------|-------------|
| **A** | 60 🟡 | 🟡 → perdez 10 jetons | Perte certaine |
| **B** | 30 🟡 / 30 🟣 | 🟡 → perdez 5 jetons<br>🟣 → perdez 15 jetons | Risque symétrique |
| **C** | 20 🟡 / 20 🟣 / 20 🔵 | 🟡 → perdez 5 jetons<br>🟣 → perdez 15 jetons<br>🔵 → perdez 10 jetons | 3 couleurs |
| **D** | 30 🟡 / 30 🟣 | 🟣 → perdez 20 jetons | Risque élevé |

---

### **Décision 6 : Ambiguïté Pertes** (Section 9)

**Type** : Choix entre 4 urnes inconnues (A-D)  
**Variable** : `ambiguite_pertes_2_choix` (valeurs : A, B, C, D)

| Option | Contenu urne | Résultat | Description |
|--------|--------------|----------|-------------|
| **A** | 🟡 boules | 🟡 → perdez 10 jetons | Composition inconnue |
| **B** | 🟡 / 🟣 boules | 🟡 → perdez 5 jetons<br>🟣 → perdez 15 jetons | Proportions inconnues |
| **C** | 🟡 / 🟣 / 🔵 boules | 🟡 → perdez 5 jetons<br>🟣 → perdez 10 jetons<br>🔵 → perdez 15 jetons | 3 couleurs inconnues |
| **D** | 🟡 / 🟣 boules | 🟡 → perdez 10 jetons<br>🟣 → perdez 20 jetons | Ambiguïté forte |

---

### **Décision 7 : Risque Gains** (Section 10)

**Type** : Choix entre 5 urnes connues (A-E)  
**Variable** : `risque_gains_2_choix` (valeurs : A, B, C, D, E)

| Option | Contenu urne | Résultat | Description |
|--------|--------------|----------|-------------|
| **A** | 60 🟡 | 🟡 → gagnez 10 jetons | Gain certain |
| **B** | 30 🟡 / 30 🟣 | 🟡 → gagnez 15 jetons | Risque modéré |
| **C** | 20 🟡 / 20 🟣 / 20 🔵 | 🟡 → gagnez 5 jetons | Gain faible |
| **D** | 30 🟡 / 30 🟣 | 🟣 → gagnez 10 jetons | Alternative |
| **E** | 20 🟡 / 20 🟣 / 20 🔵 | 🟣 → gagnez 20 jetons | Gain élevé |

---

### **Décision 8 : Ambiguïté Gains** (Section 11)

**Type** : Choix entre 4 urnes inconnues (A-D)  
**Variable** : `ambiguite_gains_2_choix` (valeurs : A, B, C, D)

| Option | Contenu urne | Résultat | Description |
|--------|--------------|----------|-------------|
| **A** | 🟡 boules | 🟡 → gagnez 10 jetons | Composition inconnue |
| **B** | 🟡 / 🟣 boules | 🟡 → gagnez 5 jetons<br>🟣 → gagnez 15 jetons | Proportions inconnues |
| **C** | 🟡 / 🟣 / 🔵 boules | 🟡 → gagnez 5 jetons<br>🟣 → gagnez 10 jetons<br>🔵 → gagnez 15 jetons | 3 couleurs inconnues |
| **D** | 🟡 / 🟣 boules | 🟡 → gagnez 10 jetons<br>🟣 → gagnez 20 jetons | Ambiguïté forte |

---

## 💾 Variables dans `study_data.csv`

### Anciennes variables (supprimées)
```csv
❌ risque_gains_2_invest      (0-10)
❌ risque_pertes_2_invest     (0-10)
❌ ambiguite_gains_2_invest   (0-10)
❌ ambiguite_pertes_2_invest  (0-10)
```

### Nouvelles variables (ajoutées)
```csv
✅ risque_pertes_2_choix      (A/B/C/D)
✅ ambiguite_pertes_2_choix   (A/B/C/D)
✅ risque_gains_2_choix       (A/B/C/D/E)
✅ ambiguite_gains_2_choix    (A/B/C/D)
```

### Exemple de données
```csv
participant_id,risque_pertes_2_choix,ambiguite_pertes_2_choix,risque_gains_2_choix,ambiguite_gains_2_choix
P20251015123456,B,A,C,D
P20251015123457,C,B,A,B
```

---

## 🔄 Modifications techniques

### 1. **Fichier `modules/ui_modules.R`**

#### Avant (Sliders)
```r
sliderInput("risque_gains_2_invest", 
            "Je décide d'investir :", 
            min = 0, max = 10, value = 0, 
            step = 1, post = " jetons")
```

#### Après (Tableaux de choix)
```r
tags$table(
  # Tableau avec options A, B, C, D, E
  # Chaque ligne = une option avec radioButtons
)
```

### 2. **Fichier `modules/server_modules.R`**

#### Validation
```r
# Avant : Toujours TRUE (sliders ont valeur par défaut)
if (section == 8) return(TRUE)

# Après : Vérifier qu'un choix est fait
if (section == 8) {
  return(!is.null(input$risque_pertes_2_choix) && 
         input$risque_pertes_2_choix != "")
}
```

#### Sauvegarde
```r
# Avant : Sauvegarder valeur slider
rv$participant_data$risque_gains_2_invest <- input$risque_gains_2_invest

# Après : Sauvegarder choix (lettre)
rv$participant_data$risque_pertes_2_choix <- input$risque_pertes_2_choix
```

### 3. **Fichier `app.R`**

- ❌ Suppression des 4 résumés dynamiques (`risque_gains_2_summary`, etc.)
- ✅ Les tableaux sont maintenant statiques dans l'UI

---

## 📊 Implications pour l'analyse

### Ancien format (numérique continu)
```r
# Moyenne des investissements
mean(data$risque_gains_2_invest)  # 0-10

# Corrélation entre décisions 1 et 5
cor(data$risque_gains_invest, data$risque_gains_2_invest)
```

### Nouveau format (catégoriel)
```r
# Fréquence des choix
table(data$risque_pertes_2_choix)
#  A  B  C  D
# 10 25 30 15

# Tableau croisé
table(data$risque_gains_invest > 5, data$risque_gains_2_choix)

# Conversion en scores numériques (si nécessaire)
data$risque_pertes_2_score <- case_when(
  risque_pertes_2_choix == "A" ~ 1,  # Aversion faible
  risque_pertes_2_choix == "B" ~ 2,
  risque_pertes_2_choix == "C" ~ 3,
  risque_pertes_2_choix == "D" ~ 4   # Aversion forte
)
```

### Analyses recommandées

1. **Fréquences de choix**
```r
# Distribution des choix par décision
prop.table(table(data$risque_gains_2_choix))
prop.table(table(data$ambiguite_pertes_2_choix))
```

2. **Cohérence inter-décisions**
```r
# Chi² entre décisions 5 et 6
chisq.test(table(data$risque_pertes_2_choix, 
                 data$ambiguite_pertes_2_choix))
```

3. **Prédiction du comportement**
```r
# Régression logistique multinomiale
library(nnet)
model <- multinom(risque_gains_2_choix ~ age + sexe + education, 
                  data = data)
```

---

## 🎨 Interface utilisateur

### Présentation visuelle

Chaque décision affiche :
1. **Contexte** : Rappel des 30 jetons initiaux
2. **Instructions** : Explication du principe de tirage
3. **Légende** : Signification des urnes (60🟡, 30🟡/30🟣, etc.)
4. **Tableau de choix** : 
   - Colonne 1 : Option (A, B, C, D, E)
   - Colonne 2 : Contenu de l'urne
   - Colonne 3 : Résultats possibles
   - Colonne 4 : RadioButton pour choisir

### Différences visuelles

- **Risque** (décisions 5 et 7) : Nombres précis de boules (60🟡, 30🟡/30🟣)
- **Ambiguïté** (décisions 6 et 8) : Boules sans nombres (🟡, 🟡/🟣)

---

## ✅ Checklist de vérification

- [x] UI modifiée dans `ui_modules.R` (4 fonctions)
- [x] Validation modifiée dans `server_modules.R`
- [x] Sauvegarde modifiée dans `server_modules.R`
- [x] Résumés dynamiques supprimés dans `app.R`
- [x] Variables renommées (invest → choix)
- [x] Format de données changé (numérique → catégoriel)
- [x] Documentation créée

---

## 🚀 Test de l'application

```r
# Lancer l'application
source("lancer_app.R")

# Naviguer jusqu'aux sections 8-11
# Vérifier :
# 1. Tableaux d'options s'affichent correctement
# 2. Un seul choix possible par décision
# 3. Validation bloque si aucun choix
# 4. Données sauvegardées avec lettres (A/B/C/D/E)

# Vérifier les données
data <- read.csv("data/study_data.csv")
table(data$risque_gains_2_choix)  # Devrait montrer A, B, C, D, E
```

---

## 📚 Références du document source

Les nouveaux écrans sont basés sur :
- **Ecrans optionnels Risque perte** → Décision 5
- **Ecrans optionnels ambiguïté perte** → Décision 6
- **Ecrans optionnels Risque gains** → Décision 7
- **Ecrans optionnels ambiguïté gains** → Décision 8

---

## ⚠️ Points d'attention

1. **Incompatibilité des données** : Les anciennes données avec `_invest` et les nouvelles avec `_choix` ne sont pas directement comparables.

2. **Analyses différentes** : Le format catégoriel nécessite des tests chi² et régressions logistiques au lieu de corrélations et régressions linéaires.

3. **Codage des scores** : Si vous voulez des scores numériques, définir une règle de conversion claire (ex: A=1, B=2, C=3, D=4, E=5).

---

**Modification terminée avec succès !** ✅  
*Les décisions 5-8 utilisent maintenant le format "choix d'urnes" comme spécifié dans le document.*
