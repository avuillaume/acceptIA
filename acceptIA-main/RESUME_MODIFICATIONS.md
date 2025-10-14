# Résumé des modifications - Application Shiny

**Date** : 4 octobre 2025  
**Application** : Acceptabilité de l'IA en Santé

---

## 🎯 Objectifs des modifications

1. Séparer les sections "Bénéfices" et "Craintes" de l'IA en santé en deux pages distinctes
2. Améliorer l'expérience utilisateur avec un défilement automatique vers le haut

---

## ✅ Modifications réalisées

### 1. Séparation des sections IA (2 pages distinctes)

#### **Page 4 : Bénéfices perçus de l'IA en santé**
- 10 questions sur les aspects positifs de l'IA
- Échelle de 1 (Tout à fait en désaccord) à 7 (Tout à fait d'accord)
- Variables : B1 à B10

#### **Page 5 : Craintes vis-à-vis de l'IA en santé**
- 10 questions sur les préoccupations liées à l'IA
- Échelle de 1 (Tout à fait en désaccord) à 7 (Tout à fait d'accord)
- Variables : C1 à C10

### 2. Défilement automatique

**Fonctionnalité ajoutée** : À chaque changement de section, la page remonte automatiquement en haut avec une animation fluide.

**Points d'application** :
- ✓ Démarrage de l'étude (après consentement)
- ✓ Navigation "Suivant"
- ✓ Navigation "Précédent"

**Code utilisé** :
```javascript
window.scrollTo({top: 0, behavior: 'smooth'});
```

---

## 📊 Nouvelle structure du questionnaire

| # | Section | Changement |
|---|---------|-----------|
| 1 | Introduction | *(inchangé)* |
| 2 | Usages numériques | *(inchangé)* |
| 3 | Santé | *(inchangé)* |
| 4 | **Bénéfices de l'IA** | **✨ Nouveau** |
| 5 | **Craintes vis-à-vis de l'IA** | **✨ Nouveau** |
| 6 | Usages numériques en santé | *(anciennement section 5)* |
| 7 | Sociodémographiques | *(anciennement section 6)* |

**Total** : 7 sections (au lieu de 6)

---

## 📁 Fichiers modifiés

### 1. **app.R**
- `max_section` : 6 → 7
- Ajout de `section_ia_benefices_ui()` (section 4)
- Ajout de `section_ia_craintes_ui()` (section 5)
- Défilement automatique dans :
  - `observeEvent(input$consent_given)`
  - `observeEvent(input$btn_previous)`
  - `observeEvent(input$btn_next)`

### 2. **modules/ui_modules_suite.R**
- Création de `section_ia_benefices_ui()` (nouvelle fonction)
- Création de `section_ia_craintes_ui()` (nouvelle fonction)
- Suppression de `section_ia_sante_ui()` (remplacée par les deux fonctions ci-dessus)

### 3. **modules/ui_modules.R**
- Mise à jour de la liste des parties dans `section_intro_ui()`

### 4. **modules/server_modules.R**
- Validation section 4 : Bénéfices uniquement
- Validation section 5 : Craintes uniquement
- Sauvegarde section 4 : Variables B1-B10
- Sauvegarde section 5 : Variables C1-C10
- Sections 6-7 : Renumérisation des anciennes sections 5-6

---

## 🎨 Avantages pour l'utilisateur

| Avantage | Description |
|----------|-------------|
| 📖 **Lisibilité améliorée** | Focus sur un seul aspect à la fois (bénéfices OU craintes) |
| 🎯 **Navigation intuitive** | Progression claire avec 7 étapes distinctes |
| 🧠 **Charge cognitive réduite** | Pages plus courtes et plus focalisées |
| 🔝 **Défilement automatique** | Retour en haut à chaque changement de page |
| ⚡ **Expérience fluide** | Animation smooth pour une transition agréable |

---

## 💾 Données collectées

**Aucun changement dans la structure des données** :
- Variables B1-B10 : Bénéfices perçus (échelle 1-7)
- Variables C1-C10 : Craintes perçues (échelle 1-7)
- Fichier de sortie : `data/study_data.csv` et `data/study_data.RData`

➡️ **Les scripts d'analyse existants restent valides sans modification**

---

## 🚀 Prochaines étapes

1. **Tester l'application** : Vérifier le bon fonctionnement du défilement automatique
2. **Tester la navigation** : S'assurer que les données sont bien sauvegardées
3. **Vérifier la barre de progression** : Confirmer qu'elle affiche 7 étapes
4. **Valider l'expérience utilisateur** : Tester avec des participants pilotes

---

## 📝 Notes techniques

### Package requis
- `shinyjs` : Utilisé pour le défilement automatique avec `runjs()`

### Compatibilité
- ✅ Tous les navigateurs modernes (Chrome, Firefox, Safari, Edge)
- ✅ Compatible mobile et tablette
- ✅ Animation smooth supportée nativement

---

## 📞 Support

Pour toute question ou problème technique :
- Consulter `MODIFICATIONS_SEPARATION_IA.md` pour les détails complets
- Vérifier les fichiers sources dans `modules/`
- Tester avec `lancer_app.R`

---

**Statut** : ✅ Modifications terminées et prêtes à tester
