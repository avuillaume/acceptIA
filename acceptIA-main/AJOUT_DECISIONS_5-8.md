# 📋 Ajout des 4 décisions supplémentaires (5-8)

**Date** : 15 octobre 2025  
**Modification** : Ajout de 4 nouvelles pages de décision de risque

---

## 🎯 Objectif

Compléter le protocole expérimental avec **8 décisions** au lieu de 4, en ajoutant une deuxième série de jeux de hasard identiques aux 4 premiers.

---

## ✅ Modifications effectuées

### 1. **Fichier `app.R`**

#### Changements du nombre de sections
- **Avant** : `max_section = 15` (3 intro + 4 jeux + 7 questionnaire + 1 fin)
- **Après** : `max_section = 19` (3 intro + **8 jeux** + 7 questionnaire + 1 fin)

#### Réorganisation des sections
```r
# Nouvelle numérotation :
Section 1  : Introduction tâches rémunérées
Section 2  : Tâche de comptage π
Section 3  : Félicitations

# ========== JEUX DE HASARD (8 décisions) ==========
Section 4  : Risque Gains (Décision 1)
Section 5  : Risque Pertes (Décision 2)
Section 6  : Ambiguïté Gains (Décision 3)
Section 7  : Ambiguïté Pertes (Décision 4)
Section 8  : Risque Gains 2 (Décision 5) ✨ NOUVEAU
Section 9  : Risque Pertes 2 (Décision 6) ✨ NOUVEAU
Section 10 : Ambiguïté Gains 2 (Décision 7) ✨ NOUVEAU
Section 11 : Ambiguïté Pertes 2 (Décision 8) ✨ NOUVEAU

# ========== QUESTIONNAIRE ==========
Section 12 : Introduction questionnaire
Section 13 : Usages numériques
Section 14 : Santé
Section 15 : Bénéfices IA (randomisé)
Section 16 : Craintes IA (randomisé)
Section 17 : Usages santé numériques
Section 18 : Sociodémographiques
Section 19 : Fin
```

#### Ajout des résumés dynamiques
- ✅ `risque_gains_2_summary` (décision 5)
- ✅ `risque_pertes_2_summary` (décision 6)
- ✅ `ambiguite_gains_2_summary` (décision 7)
- ✅ `ambiguite_pertes_2_summary` (décision 8)

---

### 2. **Fichier `modules/ui_modules.R`**

#### Ajout de 4 nouvelles fonctions UI

```r
✅ section_risque_gains_2_ui()      # Décision 5
✅ section_risque_pertes_2_ui()     # Décision 6
✅ section_ambiguite_gains_2_ui()   # Décision 7
✅ section_ambiguite_pertes_2_ui()  # Décision 8
```

**Caractéristiques** :
- Interface identique aux décisions 1-4
- Même structure (10 jetons, urnes, sliders)
- Résumés dynamiques intégrés
- Rappel systématique : "Vous disposez toujours de vos 30 jetons initiaux"

---

### 3. **Fichier `modules/server_modules.R`**

#### Validation ajoutée (sections 8-11)
```r
# Section 8 : Risque Gains 2 (les sliders ont toujours une valeur)
if (section == 8) return(TRUE)

# Section 9 : Risque Pertes 2 (les sliders ont toujours une valeur)
if (section == 9) return(TRUE)

# Section 10 : Ambiguïté Gains 2 (les sliders ont toujours une valeur)
if (section == 10) return(TRUE)

# Section 11 : Ambiguïté Pertes 2 (les sliders ont toujours une valeur)
if (section == 11) return(TRUE)
```

#### Sauvegarde des données ajoutée
```r
# Section 8 : Risque Gains 2
if (section == 8) {
  rv$participant_data$risque_gains_2_invest <- input$risque_gains_2_invest
}

# Section 9 : Risque Pertes 2
if (section == 9) {
  rv$participant_data$risque_pertes_2_invest <- input$risque_pertes_2_invest
}

# Section 10 : Ambiguïté Gains 2
if (section == 10) {
  rv$participant_data$ambiguite_gains_2_invest <- input$ambiguite_gains_2_invest
}

# Section 11 : Ambiguïté Pertes 2
if (section == 11) {
  rv$participant_data$ambiguite_pertes_2_invest <- input$ambiguite_pertes_2_invest
}
```

#### Renuméritation des autres sections
- Section 9 → Section 13 (Usages numériques)
- Section 10 → Section 14 (Santé)
- Section 11 → Section 15 (Bénéfices IA)
- Section 12 → Section 16 (Craintes IA)
- Section 13 → Section 17 (Usages santé)
- Section 14 → Section 18 (Sociodémographiques)
- Section 15 → Section 19 (Fin)

---

## 💾 Nouvelles variables collectées

Le fichier `data/study_data.csv` contiendra maintenant **8 variables d'investissement** :

| Variable | Description | Valeurs |
|----------|-------------|---------|
| `risque_gains_invest` | Décision 1 - Risque Gains | 0-10 |
| `risque_pertes_invest` | Décision 2 - Risque Pertes | 0-10 |
| `ambiguite_gains_invest` | Décision 3 - Ambiguïté Gains | 0-10 |
| `ambiguite_pertes_invest` | Décision 4 - Ambiguïté Pertes | 0-10 |
| **`risque_gains_2_invest`** ✨ | **Décision 5 - Risque Gains 2** | **0-10** |
| **`risque_pertes_2_invest`** ✨ | **Décision 6 - Risque Pertes 2** | **0-10** |
| **`ambiguite_gains_2_invest`** ✨ | **Décision 7 - Ambiguïté Gains 2** | **0-10** |
| **`ambiguite_pertes_2_invest`** ✨ | **Décision 8 - Ambiguïté Pertes 2** | **0-10** |

---

## 📊 Impact sur les analyses

### Calcul des scores d'aversion

Vous pouvez maintenant calculer des scores moyens sur **2 mesures répétées** :

```r
# Aversion au risque - Gains (moyenne des décisions 1 et 5)
data$aversion_risque_gains_moy <- (
  (10 - data$risque_gains_invest) + 
  (10 - data$risque_gains_2_invest)
) / 2

# Aversion au risque - Pertes (moyenne des décisions 2 et 6)
data$aversion_risque_pertes_moy <- (
  (10 - data$risque_pertes_invest) + 
  (10 - data$risque_pertes_2_invest)
) / 2

# Aversion à l'ambiguïté - Gains (moyenne des décisions 3 et 7)
data$aversion_ambig_gains_moy <- (
  (10 - data$ambiguite_gains_invest) + 
  (10 - data$ambiguite_gains_2_invest)
) / 2

# Aversion à l'ambiguïté - Pertes (moyenne des décisions 4 et 8)
data$aversion_ambig_pertes_moy <- (
  (10 - data$ambiguite_pertes_invest) + 
  (10 - data$ambiguite_pertes_2_invest)
) / 2
```

### Test de cohérence intra-individuelle

```r
# Corrélation test-retest
cor.test(data$risque_gains_invest, data$risque_gains_2_invest)
cor.test(data$risque_pertes_invest, data$risque_pertes_2_invest)
cor.test(data$ambiguite_gains_invest, data$ambiguite_gains_2_invest)
cor.test(data$ambiguite_pertes_invest, data$ambiguite_pertes_2_invest)

# Différences absolues moyennes
data$diff_RG <- abs(data$risque_gains_invest - data$risque_gains_2_invest)
data$diff_RP <- abs(data$risque_pertes_invest - data$risque_pertes_2_invest)
data$diff_AG <- abs(data$ambiguite_gains_invest - data$ambiguite_gains_2_invest)
data$diff_AP <- abs(data$ambiguite_pertes_invest - data$ambiguite_pertes_2_invest)

mean(data$diff_RG)  # Cohérence moyenne
```

---

## 🎮 Expérience utilisateur

### Durée estimée
- **Avant** : 25-30 minutes
- **Après** : **30-35 minutes** (+ 5 min pour 4 décisions supplémentaires)

### Barre de progression
- Chaque section = **~5.26%** de progression (19 sections)
- Les 8 décisions de risque = **42%** de l'étude

### Navigation
- ✅ Boutons Précédent/Suivant fonctionnent correctement
- ✅ Validation automatique avant passage à la section suivante
- ✅ Sauvegarde progressive des données
- ✅ Résumés dynamiques mis à jour en temps réel

---

## 🔄 Compatibilité

### Données existantes
⚠️ **Attention** : Les données collectées avant cette modification ne contiendront **pas** les 4 nouvelles variables. Elles auront des valeurs `NA` pour :
- `risque_gains_2_invest`
- `risque_pertes_2_invest`
- `ambiguite_gains_2_invest`
- `ambiguite_pertes_2_invest`

### Solution
Si vous avez déjà des participants :
1. **Option 1** : Filtrer les données complètes uniquement
   ```r
   data_complete <- data %>% 
     filter(!is.na(risque_gains_2_invest))
   ```

2. **Option 2** : Analyser séparément les deux vagues
   ```r
   data_vague1 <- data %>% filter(is.na(risque_gains_2_invest))  # 4 décisions
   data_vague2 <- data %>% filter(!is.na(risque_gains_2_invest)) # 8 décisions
   ```

---

## 📝 Fichiers modifiés

| Fichier | Lignes modifiées | Description |
|---------|------------------|-------------|
| `app.R` | ~50 lignes | Ajout sections 8-11, résumés, renumérotation |
| `modules/ui_modules.R` | ~200 lignes | 4 nouvelles fonctions UI |
| `modules/server_modules.R` | ~30 lignes | Validation et sauvegarde sections 8-11 |

---

## ✅ Checklist de vérification

- [x] Sections 8-11 ajoutées dans `app.R`
- [x] Fonctions UI créées dans `ui_modules.R`
- [x] Validation ajoutée dans `server_modules.R`
- [x] Sauvegarde ajoutée dans `server_modules.R`
- [x] Résumés dynamiques ajoutés dans `app.R`
- [x] `max_section` mis à jour (15 → 19)
- [x] Randomisation Bénéfices/Craintes adaptée (sections 15-16)
- [x] Navigation testée (sections 1-19)
- [x] Documentation créée (`AJOUT_DECISIONS_5-8.md`)

---

## 🚀 Test de l'application

Pour tester les nouvelles décisions :

```r
# Lancer l'application
source("lancer_app.R")

# Naviguer jusqu'aux sections 8-11
# Vérifier :
# 1. Affichage correct des instructions
# 2. Sliders fonctionnels (0-10 jetons)
# 3. Résumés dynamiques mis à jour
# 4. Sauvegarde des données dans study_data.csv
# 5. Colonnes risque_gains_2_invest, etc. présentes
```

---

## 📚 Références

- Architecture complète : `ARCHITECTURE_V4.md`
- Guide d'analyse : `GUIDE_ANALYSE.md`
- Documentation complète : `README.md`

---

**Modification terminée avec succès !** ✅  
*Votre application comporte maintenant 8 décisions de risque comme prévu.*
