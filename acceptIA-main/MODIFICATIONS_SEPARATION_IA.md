# Modifications - Séparation des sections IA en santé

## Date : 4 octobre 2025

## Modifications effectuées

### 1. Séparation de la section "IA en santé" en deux pages distinctes

La section originale qui combinait les bénéfices et les craintes de l'IA en santé a été divisée en deux sections séparées :

#### Page 4 : Bénéfices perçus de l'IA en santé
- **Fonction** : `section_ia_benefices_ui()`
- **Contenu** : 10 questions sur les bénéfices perçus de l'IA en santé
- **Échelle** : Slider de 1 à 7 (1 = Tout à fait en désaccord, 7 = Tout à fait d'accord)
- **Items** : Questions sur la prévention, la qualité des soins, l'accessibilité, l'efficacité, l'autonomie du patient, et les bénéfices collectifs

#### Page 5 : Craintes vis-à-vis de l'IA en santé
- **Fonction** : `section_ia_craintes_ui()`
- **Contenu** : 10 questions sur les craintes concernant l'IA en santé
- **Échelle** : Slider de 1 à 7 (1 = Tout à fait en désaccord, 7 = Tout à fait d'accord)
- **Items** : Questions sur la fiabilité, la perte de contrôle humain, la protection des données, les biais, et les conséquences systémiques

### 2. Mise à jour de la structure de navigation

#### Fichier `app.R` :
- **max_section** : Changé de 6 à 7 sections
- **switch statement** : Ajout des nouvelles sections :
  - Section 4 : `section_ia_benefices_ui()`
  - Section 5 : `section_ia_craintes_ui()`
  - Section 6 : `section_usages_sante_ui()` (anciennement section 5)
  - Section 7 : `section_sociodemographiques_ui()` (anciennement section 6)

#### Fichier `modules/ui_modules.R` :
- **section_intro_ui()** : Mise à jour de la liste des parties de l'étude pour refléter la séparation

### 3. Conservation des échelles de mesure

Chaque question conserve son échelle slider de 1 à 7 avec :
- Valeur minimale : 1
- Valeur maximale : 7
- Valeur par défaut : 4
- Pas : 1
- Affichage des graduations (ticks = TRUE)
- Largeur : 100%

### 4. Identifiants des inputs conservés

- **Bénéfices** : Les inputs conservent leurs identifiants `B1`, `B2`, ..., `B10`
- **Craintes** : Les inputs conservent leurs identifiants `C1`, `C2`, ..., `C10`

### 5. Défilement automatique vers le haut

- La page remonte automatiquement en haut lors de chaque changement de section
- Animation fluide (smooth scroll) pour une meilleure expérience utilisateur
- S'applique :
  - Au démarrage de l'étude (après consentement)
  - À chaque clic sur "Suivant"
  - À chaque clic sur "Précédent"

## Structure avant et après modification

### AVANT (6 sections) :
1. Introduction
2. Usages numériques
3. Santé
4. **IA en santé (Bénéfices + Craintes combinés)**
5. Usages numériques en santé
6. Sociodémographiques

### APRÈS (7 sections) :
1. Introduction
2. Usages numériques
3. Santé
4. **A. Bénéfices perçus de l'IA en santé**
5. **B. Craintes vis-à-vis de l'IA en santé**
6. Usages numériques en santé
7. Sociodémographiques

## Impact sur l'expérience utilisateur

1. **Meilleure lisibilité** : Les participants peuvent se concentrer sur un seul aspect à la fois (bénéfices OU craintes)
2. **Navigation claire** : La barre de progression reflète maintenant 7 étapes au lieu de 6
3. **Séparation conceptuelle** : Distinction claire entre les perceptions positives et négatives de l'IA
4. **Réduction de la charge cognitive** : Chaque page est plus courte et plus focalisée
5. **Défilement automatique** : La page remonte automatiquement en haut à chaque changement de section pour une meilleure expérience utilisateur

## Fichiers modifiés

1. **`app.R`** - Mise à jour de la navigation et du nombre de sections
   - `max_section` : 6 → 7
   - Ajout des sections 4 et 5 pour les bénéfices et craintes séparés
   - Ajout du défilement automatique vers le haut (`window.scrollTo`) à chaque changement de section
   
2. **`modules/ui_modules_suite.R`** - Création de deux fonctions séparées
   - `section_ia_benefices_ui()` - Nouvelle fonction pour la page des bénéfices
   - `section_ia_craintes_ui()` - Nouvelle fonction pour la page des craintes
   - Suppression de `section_ia_sante_ui()` (remplacée par les deux fonctions ci-dessus)
   
3. **`modules/ui_modules.R`** - Mise à jour de l'introduction
   - Liste des parties de l'étude mise à jour
   
4. **`modules/server_modules.R`** - Mise à jour de la validation et de la sauvegarde
   - Section 4 : Validation et sauvegarde des bénéfices uniquement
   - Section 5 : Validation et sauvegarde des craintes uniquement
   - Sections 6 et 7 : Renumérisation des anciennes sections 5 et 6

## Notes pour l'analyse des données

Les données collectées conservent la même structure :
- Variables `B1` à `B10` : Bénéfices perçus
- Variables `C1` à `C10` : Craintes perçues

Aucune modification n'est nécessaire dans les scripts d'analyse existants.
