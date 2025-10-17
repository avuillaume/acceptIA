# Décisions Conditionnelles - Documentation

## Vue d'ensemble

Les 4 premières décisions (sections 4-7) sont **obligatoires** pour tous les participants.
Les 4 décisions suivantes (sections 8-11) sont **conditionnelles** et ne s'affichent que si certaines conditions sont remplies.

## Règles de conditionnalité

### Section 8 : Risque Gains 2 (Décision 5)
- **Condition** : Affichée seulement si le participant a investi **10 jetons** dans la section 4 (Risque Gains)
- **Variable** : `rv$show_section_8`
- **Test** : `input$risque_gains_invest == 10`

### Section 9 : Risque Pertes 2 (Décision 6)
- **Condition** : Affichée seulement si le participant a investi **0 jetons** dans la section 5 (Risque Pertes)
- **Variable** : `rv$show_section_9`
- **Test** : `input$risque_pertes_invest == 0`

### Section 10 : Ambiguïté Gains 2 (Décision 7)
- **Condition** : Affichée seulement si le participant a investi **10 jetons** dans la section 6 (Ambiguïté Gains)
- **Variable** : `rv$show_section_10`
- **Test** : `input$ambiguite_gains_invest == 10`

### Section 11 : Ambiguïté Pertes 2 (Décision 8)
- **Condition** : Affichée seulement si le participant a investi **0 jetons** dans la section 7 (Ambiguïté Pertes)
- **Variable** : `rv$show_section_11`
- **Test** : `input$ambiguite_pertes_invest == 0`

## Implémentation technique

### 1. Variables réactives
Les variables suivantes ont été ajoutées à `rv` dans `app.R` :
```r
show_section_8 = FALSE   # Risque Gains 2
show_section_9 = FALSE   # Risque Pertes 2  
show_section_10 = FALSE  # Ambiguïté Gains 2
show_section_11 = FALSE  # Ambiguïté Pertes 2
```

### 2. Mise à jour des flags
Dans `modules/server_modules.R`, la fonction `save_section_data()` met à jour ces flags après chaque section 4-7 :
```r
# Exemple pour la section 4
if (section == 4) {
  rv$participant_data$risque_gains_invest <- input$risque_gains_invest
  rv$show_section_8 <- (input$risque_gains_invest == 10)
}
```

### 3. Logique de navigation
Deux nouvelles fonctions dans `modules/server_modules.R` gèrent la navigation :

#### `next_section_logic(current_section, rv)`
- Détermine la prochaine section en sautant les sections conditionnelles non activées
- Appelée par le bouton "Suivant"

#### `previous_section_logic(current_section, rv)`
- Détermine la section précédente en sautant les sections conditionnelles non activées
- Appelée par le bouton "Précédent"

### 4. Barre de progression
Deux fonctions calculent la progression effective :

#### `calculate_effective_max_section(rv)`
- Calcule le nombre total de sections affichées (19 - sections sautées)
- Utilisé comme dénominateur pour la barre de progression

#### `calculate_effective_position(current_section, rv)`
- Calcule la position effective en soustrayant les sections sautées avant la section actuelle
- Utilisé comme numérateur pour la barre de progression

## Flux de navigation

### Exemple 1 : Participant qui répond 10 partout
- Section 4 → répond 10 → `show_section_8 = TRUE`
- Section 5 → répond 10 (≠ 0) → `show_section_9 = FALSE`
- Section 6 → répond 10 → `show_section_10 = TRUE`
- Section 7 → répond 10 (≠ 0) → `show_section_11 = FALSE`

**Sections affichées** : 4, 5, 6, 7, 8, 10, 12 (saute 9 et 11)
**Total effectif** : 17 sections (19 - 2)

### Exemple 2 : Participant qui répond 0 partout
- Section 4 → répond 0 (≠ 10) → `show_section_8 = FALSE`
- Section 5 → répond 0 → `show_section_9 = TRUE`
- Section 6 → répond 0 (≠ 10) → `show_section_10 = FALSE`
- Section 7 → répond 0 → `show_section_11 = TRUE`

**Sections affichées** : 4, 5, 6, 7, 9, 11, 12 (saute 8 et 10)
**Total effectif** : 17 sections (19 - 2)

### Exemple 3 : Participant qui répond 5 partout
- Section 4 → répond 5 (≠ 10) → `show_section_8 = FALSE`
- Section 5 → répond 5 (≠ 0) → `show_section_9 = FALSE`
- Section 6 → répond 5 (≠ 10) → `show_section_10 = FALSE`
- Section 7 → répond 5 (≠ 0) → `show_section_11 = FALSE`

**Sections affichées** : 4, 5, 6, 7, 12 (saute toutes les sections conditionnelles)
**Total effectif** : 15 sections (19 - 4)

## Structure complète des sections

1. Introduction tâches d'aversion (obligatoire)
2. Tâche de comptage (obligatoire)
3. Félicitations (obligatoire)
4. Risque Gains (obligatoire)
5. Risque Pertes (obligatoire)
6. Ambiguïté Gains (obligatoire)
7. Ambiguïté Pertes (obligatoire)
8. **Risque Gains 2 - Décision 5** (conditionnelle - si section 4 = 10)
9. **Risque Pertes 2 - Décision 6** (conditionnelle - si section 5 = 0)
10. **Ambiguïté Gains 2 - Décision 7** (conditionnelle - si section 6 = 10)
11. **Ambiguïté Pertes 2 - Décision 8** (conditionnelle - si section 7 = 0)
12. Introduction questionnaire (obligatoire)
13. Usages numériques (obligatoire)
14. Santé (obligatoire)
15. IA Bénéfices/Craintes A (obligatoire, randomisé)
16. IA Craintes/Bénéfices B (obligatoire, randomisé)
17. Usages santé (obligatoire)
18. Sociodémographiques (obligatoire)
19. Fin (obligatoire)

## Données collectées

Les variables suivantes sont sauvegardées pour chaque participant :
- `risque_gains_invest` (0-10)
- `risque_pertes_invest` (0-10)
- `ambiguite_gains_invest` (0-10)
- `ambiguite_pertes_invest` (0-10)
- `risque_gains_2_choix` (A/B/C/D) - seulement si section 8 affichée
- `risque_pertes_2_choix` (A/B/C/D) - seulement si section 9 affichée
- `ambiguite_gains_2_choix` (A/B/C) - seulement si section 10 affichée
- `ambiguite_pertes_2_choix` (A/B/C/D) - seulement si section 11 affichée

**Important** : Les variables `_2_choix` seront `NULL` ou absentes dans les données si la section conditionnelle n'a pas été affichée au participant.

## Modifications des fichiers

### `app.R`
- Ajout des variables `show_section_8`, `show_section_9`, `show_section_10`, `show_section_11` dans `rv`
- Modification du bouton "Suivant" pour utiliser `next_section_logic()`
- Modification du bouton "Précédent" pour utiliser `previous_section_logic()`
- Modification de la barre de progression pour utiliser les positions effectives

### `modules/server_modules.R`
- Ajout de `next_section_logic()` pour la navigation avant
- Ajout de `previous_section_logic()` pour la navigation arrière
- Ajout de `calculate_effective_max_section()` pour le calcul du total de sections
- Ajout de `calculate_effective_position()` pour la position dans la progression
- Modification de `save_section_data()` pour mettre à jour les flags conditionnels

## Notes pour l'analyse

Lors de l'analyse des données :
1. Vérifier la présence des variables `_2_choix` avant de les utiliser
2. Le taux de complétion des sections conditionnelles indique la distribution des réponses extrêmes (0 ou 10)
3. Analyser séparément les participants qui ont vu chaque section conditionnelle
