# Ajout des jeux de hasard interactifs

**Date** : 5 octobre 2025  
**Modification** : Ajout des 4 jeux de hasard interactifs pour mesurer les aversions

---

## 🎯 Objectif

Implémenter les 4 jeux de hasard interactifs basés sur le document "Ecrans seuls aversions.docx.md" pour mesurer :
- **Aversion au risque en gains**
- **Aversion au risque en pertes**
- **Aversion à l'ambiguïté en gains**
- **Aversion à l'ambiguïté en pertes**

---

## ✅ Nouvelles sections ajoutées

### Section 4 : Risque Gains - Décision 1
**Fonction** : `section_risque_gains_ui()`

**Principe** :
- Investir tout ou partie de 10 jetons dans un jeu de hasard
- Urne avec **30 boules jaunes** et **30 boules violettes** (50/50)
- 🟡 **Jaune** : Gagner **3× les jetons investis**
- 🟣 **Violet** : Perdre les jetons investis

**Variables collectées** :
- `risque_gains_invest` : Nombre de jetons investis (0-10)

**Visualisation** :
- Urne avec gradient 50/50 jaune/violet
- Résumé dynamique avec calcul automatique des gains potentiels
- Slider interactif 0-10 jetons

---

### Section 5 : Risque Pertes - Décision 2
**Fonction** : `section_risque_pertes_ui()`

**Principe** :
- Sans investissement : **perte certaine de 10 jetons**
- Investir pour tenter de réduire la perte
- Urne avec **30 boules jaunes** et **30 boules violettes** (50/50)
- 🟡 **Jaune** : Récupérer les jetons investis (réduction de la perte)
- 🟣 **Violet** : Perdre **3× les jetons investis** (aggravation de la perte)

**Variables collectées** :
- `risque_pertes_invest` : Nombre de jetons investis (0-10)

**Visualisation** :
- Urne avec gradient 50/50 jaune/violet
- Résumé dynamique avec calcul des pertes potentielles
- Slider interactif 0-10 jetons

---

### Section 6 : Ambiguïté Gains - Décision 3
**Fonction** : `section_ambiguite_gains_ui()`

**Principe** :
- Investir tout ou partie de 10 jetons dans un jeu de hasard
- Urne avec boules jaunes ET/OU violettes (composition **inconnue**)
- 🟡 **Jaune** : Gagner **3× les jetons investis**
- 🟣 **Violet** : Perdre les jetons investis

**Variables collectées** :
- `ambiguite_gains_invest` : Nombre de jetons investis (0-10)

**Visualisation** :
- Urne avec bordure **pointillée** (ambiguïté)
- Motif hachuré jaune/violet
- Mention "Composition inconnue !"
- Résumé dynamique avec avertissement ambiguïté

---

### Section 7 : Ambiguïté Pertes - Décision 4
**Fonction** : `section_ambiguite_pertes_ui()`

**Principe** :
- Sans investissement : **perte certaine de 10 jetons**
- Investir pour tenter de réduire la perte
- Urne avec boules jaunes ET/OU violettes (composition **inconnue**)
- 🟡 **Jaune** : Récupérer les jetons investis (réduction de la perte)
- 🟣 **Violet** : Perdre **3× les jetons investis** (aggravation de la perte)

**Variables collectées** :
- `ambiguite_pertes_invest` : Nombre de jetons investis (0-10)

**Visualisation** :
- Urne avec bordure **pointillée** (ambiguïté)
- Motif hachuré jaune/violet
- Mention "Composition inconnue !"
- Résumé dynamique avec avertissement ambiguïté

---

## 📊 Structure complète mise à jour

| # | Section | Type | Durée |
|---|---------|------|-------|
| 0 | Consentement | Information | 1 min |
| 1 | Intro tâches rémunérées | Information | 1 min |
| 2 | Tâche de comptage π | Tâche | 2-3 min |
| 3 | Félicitations | Information | 30 sec |
| **4** | **Risque Gains** | **Jeu interactif** | **1-2 min** ✨ |
| **5** | **Risque Pertes** | **Jeu interactif** | **1-2 min** ✨ |
| **6** | **Ambiguïté Gains** | **Jeu interactif** | **1-2 min** ✨ |
| **7** | **Ambiguïté Pertes** | **Jeu interactif** | **1-2 min** ✨ |
| 8 | Introduction questionnaire | Information | 30 sec |
| 9 | Usages numériques | Questionnaire | 3 min |
| 10 | Santé | Questionnaire | 3 min |
| 11 | Bénéfices IA | Échelles | 2 min |
| 12 | Craintes IA | Échelles | 2 min |
| 13 | Usages santé numériques | Questionnaire | 3 min |
| 14 | Sociodémographiques | Questionnaire | 2 min |

**Durée totale estimée** : **25-30 minutes**

---

## 🎨 Fonctionnalités interactives

### Sliders d'investissement
- **Plage** : 0-10 jetons
- **Pas** : 1 jeton
- **Valeur par défaut** : 0 (aucun investissement)
- **Affichage** : " jetons" en post-fixe

### Résumés dynamiques
Chaque jeu affiche un résumé qui se met à jour en temps réel :

#### Pour les jeux de gains :
```
Résumé de votre investissement
Vous misez X jeton(s) et conservez Y jeton(s).

Vos jetons après tirage :
🟡 Tirage JAUNE : Y jetons conservés + (X × 3) jetons gagnés = Z jetons
🟣 Tirage VIOLET : Y jetons conservés
```

#### Pour les jeux de pertes :
```
Résumé de votre investissement
Vous misez X jeton(s) et Y jeton(s) seront définitivement perdus.

Vos pertes après tirage :
🟡 Tirage JAUNE : Vous perdez Y jetons
🟣 Tirage VIOLET : Vous perdez Y + (X × 3) = Z jetons
```

### Visualisations d'urnes

#### Risque (composition connue 50/50) :
- Cercle avec bordure **solide**
- Gradient **50% jaune / 50% violet**
- Texte : "30 🟡 / 30 🟣"
- Légende : "⚠️ 1 chance sur 2"

#### Ambiguïté (composition inconnue) :
- Cercle avec bordure **pointillée orange**
- Motif **hachuré** jaune/violet
- Texte : "🟡 ? / 🟣 ?"
- Légende : "⚠️ Composition inconnue !"

---

## 💾 Variables collectées

| Variable | Type | Section | Valeurs | Description |
|----------|------|---------|---------|-------------|
| `risque_gains_invest` | Numérique | 4 | 0-10 | Jetons investis - Risque gains |
| `risque_pertes_invest` | Numérique | 5 | 0-10 | Jetons investis - Risque pertes |
| `ambiguite_gains_invest` | Numérique | 6 | 0-10 | Jetons investis - Ambiguïté gains |
| `ambiguite_pertes_invest` | Numérique | 7 | 0-10 | Jetons investis - Ambiguïté pertes |

### Interprétation des scores

**Aversion au risque** :
- Investissement faible en gains → Aversion au risque élevée
- Investissement élevé en pertes → Aversion au risque faible

**Aversion à l'ambiguïté** :
- Différence entre investissement Risque vs Ambiguïté
- Investissement plus faible en ambiguïté → Aversion à l'ambiguïté

---

## 📁 Fichiers modifiés

### 1. **modules/ui_modules.R**
✅ **4 nouvelles fonctions** créées :
- `section_risque_gains_ui()`
- `section_risque_pertes_ui()`
- `section_ambiguite_gains_ui()`
- `section_ambiguite_pertes_ui()`

**Éléments visuels** :
- Icônes Font Awesome (dice, lightbulb, chart-bar, info-circle, exclamation-triangle)
- Encadrés colorés avec bordures
- Urnes CSS avec gradients et motifs
- Résumés dynamiques stylisés

### 2. **app.R**
✅ **max_section** : 10 → **14**

✅ **switch statement** mis à jour :
- Sections 4-7 : Nouveaux jeux de hasard
- Sections 8-14 : Décalage des sections existantes

✅ **4 renderUI** ajoutés :
- `output$risque_gains_summary`
- `output$risque_pertes_summary`
- `output$ambiguite_gains_summary`
- `output$ambiguite_pertes_summary`

**Logique des résumés** :
- Calculs dynamiques des gains/pertes
- Affichage conditionnel des résultats
- Couleurs : Vert (gains), Rouge (pertes)

### 3. **modules/server_modules.R**

#### Validation (`validate_current_section`) :
✅ Sections 4-7 : Toujours valide (sliders ont toujours une valeur)
✅ Sections 8-14 : Renumérisation des validations existantes

#### Sauvegarde (`save_section_data`) :
✅ Sections 4-7 : Sauvegarde des investissements
✅ Sections 9-14 : Renumérisation des sauvegardes existantes

---

## 🎨 Design et UX

### Codes couleurs
| Élément | Couleur | Code | Usage |
|---------|---------|------|-------|
| Jaune | 🟡 | #ffeb3b | Résultat positif (gains, récupération) |
| Violet | 🟣 | #9c27b0 | Résultat négatif (pertes) |
| Vert | ✅ | #27ae60 | Gains potentiels |
| Rouge | ❌ | #e74c3c | Pertes potentielles |
| Orange | ⚠️ | #ff9800 | Ambiguïté, avertissement |
| Bleu | ℹ️ | #3498db | Information, risque |

### Encadrés
- **Risque gains** : Fond bleu clair, bordure bleue
- **Risque pertes** : Fond orange pâle, bordure orange
- **Ambiguïté gains** : Fond jaune pâle, bordure pointillée orange
- **Ambiguïté pertes** : Fond rouge pâle, bordure pointillée rouge

---

## 📊 Analyses possibles

### Variables d'aversion calculables

```r
# Scores d'aversion au risque
aversion_risque_gains <- 10 - risque_gains_invest
aversion_risque_pertes <- 10 - risque_pertes_invest

# Scores d'aversion à l'ambiguïté
aversion_ambig_gains <- 10 - ambiguite_gains_invest
aversion_ambig_pertes <- 10 - ambiguite_pertes_invest

# Différentiels (aversion à l'ambiguïté)
diff_ambig_gains <- risque_gains_invest - ambiguite_gains_invest
diff_ambig_pertes <- risque_pertes_invest - ambiguite_pertes_invest
```

### Comparaisons possibles
- Aversion risque gains vs pertes
- Aversion ambiguïté gains vs pertes
- Impact des aversions sur acceptabilité IA
- Corrélations avec variables démographiques

---

## 🔄 Logique du tirage au sort

**Important** : Dans le protocole original, une seule décision parmi les 4 jeux est tirée au sort pour déterminer le gain final du participant.

### À implémenter (si nécessaire) :
```r
# En fin d'étude
decision_tiree <- sample(1:4, 1)
investissement <- c(
  risque_gains_invest,
  risque_pertes_invest,
  ambiguite_gains_invest,
  ambiguite_pertes_invest
)[decision_tiree]

# Tirer couleur et calculer gain final
# (à implémenter selon le protocole de rémunération)
```

---

## ⚠️ Notes importantes

### Éléments non implémentés

Les **écrans optionnels** du document "Ecrans seuls aversions" ne sont **PAS implémentés** :
- ❌ Choix entre plusieurs urnes (risque gains)
- ❌ Choix entre plusieurs urnes (risque pertes)
- ❌ Choix entre plusieurs urnes (ambiguïté gains)
- ❌ Choix entre plusieurs urnes (ambiguïté pertes)

Ces écrans optionnels proposent des choix entre différentes loteries avec des probabilités et gains variés.

### Tirage au sort final
Le **tirage au sort effectif** et le **calcul de la rémunération** ne sont pas implémentés dans cette version. Il faudrait :
1. Tirer au sort une décision parmi les 4
2. Tirer une boule dans l'urne correspondante
3. Calculer le gain/perte effectif
4. Convertir en euros (1 jeton = 0,50€)

---

## ✅ Tests recommandés

### Test 1 : Sliders
- [ ] Déplacer les sliders de 0 à 10
- [ ] Vérifier que les résumés se mettent à jour

### Test 2 : Calculs
- [ ] Tester avec 0 jeton (pas de risque)
- [ ] Tester avec 10 jetons (risque maximal)
- [ ] Vérifier calculs gains : conservés + (investis × 3)
- [ ] Vérifier calculs pertes : non-investis + (investis × 3)

### Test 3 : Visualisations
- [ ] Vérifier affichage urnes risque (bordure solide)
- [ ] Vérifier affichage urnes ambiguïté (bordure pointillée)
- [ ] Vérifier icônes et couleurs

### Test 4 : Sauvegarde
- [ ] Compléter les 4 jeux
- [ ] Vérifier présence des 4 variables dans CSV
- [ ] Vérifier valeurs correctes (0-10)

### Test 5 : Navigation
- [ ] Défilement automatique fonctionne
- [ ] Barre de progression correcte (14 sections)
- [ ] Boutons précédent/suivant opérationnels

---

## 🚀 Commandes pour tester

```r
# Lancer l'application
source("lancer_app.R")

# Vérifier les données sauvegardées
data <- read.csv("data/study_data.csv")
View(data)

# Vérifier les colonnes des jeux
colnames(data)
# Devrait inclure : risque_gains_invest, risque_pertes_invest, 
#                    ambiguite_gains_invest, ambiguite_pertes_invest
```

---

## 📈 Exemple de sortie de données

```
participant_id,risque_gains_invest,risque_pertes_invest,ambiguite_gains_invest,ambiguite_pertes_invest,...
P20251005123456,7,3,5,2,...
P20251005123512,4,6,3,4,...
```

---

**Statut** : ✅ Modifications terminées et prêtes à tester

**Prochaine étape** : Tests utilisateurs avec les jeux de hasard interactifs
