# Ajout des tâches d'aversion au questionnaire

**Date** : 4 octobre 2025  
**Modification** : Ajout des tâches d'aversion au début du questionnaire

---

## 🎯 Objectif

Intégrer les tâches d'aversion (basées sur le document "Ecrans seuls aversions.docx.md") au début du questionnaire Shiny, avant les questions sur l'acceptabilité de l'IA en santé.

---

## ✅ Nouvelles sections ajoutées

### Section 1 : Introduction aux tâches rémunérées
**Fonction** : `section_aversion_intro_ui()`

**Contenu** :
- Présentation de la tâche rémunérée (30 jetons à gagner)
- Explication du taux de conversion (1 jeton = 50 centimes)
- Information sur le tirage au sort final
- Importance de chaque décision

**Éléments visuels** :
- ✅ Icône pour la tâche rémunérée
- 💡 Icône pour les décisions
- ⚡ Avertissement sur le tirage au sort

---

### Section 2 : Tâche de comptage (décimales de π)
**Fonction** : `section_tache_comptage_ui()`

**Contenu** :
- Tâche : Compter les occurrences du chiffre "1" dans les 200 premières décimales de π
- Affichage des décimales dans une zone monospace
- Input numérique pour la réponse

**Variables collectées** :
- `comptage_pi` : Nombre de fois que le chiffre 1 apparaît (réponse du participant)

**Validation** :
- Vérifie que l'input n'est pas null ou NA
- Valeur attendue : entre 0 et 200

---

### Section 3 : Félicitations et instructions
**Fonction** : `section_felicitations_ui()`

**Contenu** :
- Message de félicitations (30 jetons gagnés)
- Instructions pour les jeux de hasard à venir
- Explication de l'indépendance des décisions
- Rappel du tirage au sort final

**Éléments visuels** :
- 🏆 Icône trophée
- Encadré coloré pour les félicitations
- Zones d'information surlignées
- ⚠️ Avertissement sur l'importance de chaque décision

---

## 📊 Nouvelle structure du questionnaire

| # | Section | Description |
|---|---------|-------------|
| **0** | **Consentement** | *(écran initial, avant section 1)* |
| **1** | **Introduction tâches d'aversion** | Présentation des tâches rémunérées ✨ **NOUVEAU** |
| **2** | **Tâche de comptage** | Compter les "1" dans π ✨ **NOUVEAU** |
| **3** | **Félicitations** | Confirmation des 30 jetons gagnés ✨ **NOUVEAU** |
| **4** | **Introduction questionnaire** | Introduction au questionnaire IA santé |
| 5 | Usages numériques | *(anciennement section 2)* |
| 6 | Santé | *(anciennement section 3)* |
| 7 | Bénéfices de l'IA | *(anciennement section 4)* |
| 8 | Craintes vis-à-vis de l'IA | *(anciennement section 5)* |
| 9 | Usages numériques en santé | *(anciennement section 6)* |
| 10 | Sociodémographiques | *(anciennement section 7)* |

**Total** : **10 sections** (au lieu de 7)

---

## 📁 Fichiers modifiés

### 1. **modules/ui_modules.R**
✅ Ajout de 3 nouvelles fonctions :
- `section_aversion_intro_ui()` - Introduction tâches rémunérées
- `section_tache_comptage_ui()` - Tâche de comptage π
- `section_felicitations_ui()` - Félicitations et instructions

✅ Modification de `section_intro_ui()` :
- Nouveau titre : "Introduction au questionnaire"
- Texte adapté pour indiquer que c'est la suite après les tâches

### 2. **app.R**
✅ Mise à jour de `max_section` : 7 → **10**

✅ Mise à jour du switch statement :
- Section 1 : `section_aversion_intro_ui()`
- Section 2 : `section_tache_comptage_ui()`
- Section 3 : `section_felicitations_ui()`
- Sections 4-10 : Décalage des anciennes sections

### 3. **modules/server_modules.R**

#### Validation (`validate_current_section`) :
✅ Section 1 : Pas de validation (information)
✅ Section 2 : Validation du comptage π (vérifie que l'input existe)
✅ Section 3 : Pas de validation (information)
✅ Sections 4-10 : Renumérisation des validations existantes

#### Sauvegarde (`save_section_data`) :
✅ Section 2 : Sauvegarde de `comptage_pi`
✅ Sections 5-10 : Renumérisation des sauvegardes existantes

---

## 💾 Données collectées

### Nouvelle variable ajoutée :
| Variable | Type | Description | Valeurs possibles |
|----------|------|-------------|-------------------|
| `comptage_pi` | Numérique | Nombre de "1" comptés dans les décimales de π | 0-200 |

### Variables existantes :
Toutes les variables existantes restent inchangées (B1-B10, C1-C10, variables démographiques, etc.)

---

## 🎨 Éléments visuels ajoutés

### Icônes utilisées :
- ✅ `icon("check-circle")` - Tâche rémunérée
- 💡 `icon("lightbulb")` - Série de décisions  
- ⚡ `icon("bolt")` - Tirage au sort
- 🏆 `icon("trophy")` - Félicitations
- ⚠️ `icon("exclamation-triangle")` - Avertissements

### Styles appliqués :
- **Encadré conversion** : Fond bleu clair (#e8f4f8)
- **Avertissements** : Fond jaune (#fff3cd) avec bordure gauche orange
- **Félicitations** : Fond vert clair (#d4edda) avec texte vert foncé
- **Instructions** : Fond bleu clair (#e7f3ff)
- **Zone π** : Fond gris (#f8f9fa) avec police monospace

---

## 🔄 Impact sur la navigation

### Barre de progression :
- Maintenant sur **10 sections** au lieu de 7
- Chaque section représente 10% de progression

### Défilement automatique :
- ✅ S'applique également aux 3 nouvelles sections
- Animation smooth lors du passage entre sections

---

## 📝 Notes importantes

### Tâches d'aversion non implémentées dans cette version :

Les tâches suivantes du document "Ecrans seuls aversions" ne sont **PAS encore implémentées** :
- ❌ Risque gains (décision d'investissement avec urne 50/50)
- ❌ Risque pertes (décision d'investissement pour réduire les pertes)
- ❌ Ambiguïté gains (urne avec composition inconnue)
- ❌ Ambiguïté pertes (urne avec composition inconnue)
- ❌ Écrans optionnels (choix entre différents tirages)

### Prochaine étape (si souhaité) :
Pour ajouter les jeux de hasard complets, il faudra :
1. Créer des sections interactives avec des sliders pour l'investissement
2. Ajouter des visualisations d'urnes avec des boules colorées
3. Implémenter la logique de calcul des gains/pertes
4. Gérer le tirage au sort final

---

## ✅ Tests recommandés

1. **Navigation** : Vérifier que les 10 sections s'affichent correctement
2. **Validation** : Tester la validation de la tâche de comptage
3. **Sauvegarde** : Vérifier que `comptage_pi` est bien enregistré
4. **Défilement** : Confirmer le scroll automatique fonctionne
5. **Barre de progression** : Vérifier qu'elle affiche 10%, 20%, 30%...

---

## 🚀 Commandes pour tester

```r
# Lancer l'application
source("lancer_app.R")

# Ou directement
shiny::runApp("app.R")
```

---

**Statut** : ✅ Modifications terminées et prêtes à tester
