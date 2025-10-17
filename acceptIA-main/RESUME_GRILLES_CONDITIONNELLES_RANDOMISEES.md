# Résumé Complet : Grilles Conditionnelles et Randomisées

## Date
15 octobre 2025

## Vue d'ensemble

Deux fonctionnalités majeures ont été implémentées pour les grilles de décision (jeux d'aversion) :

### 1. **Grilles conditionnelles**
Les 4 premières grilles sont obligatoires, les 4 suivantes sont optionnelles et conditionnelles.

### 2. **Randomisation**
L'ordre de présentation des grilles obligatoires ET optionnelles est randomisé pour chaque participant.

---

## Fonctionnalité 1 : Grilles conditionnelles

### Structure
- **Sections 4-7** : 4 grilles obligatoires (tous les participants)
- **Sections 8-11** : 4 grilles optionnelles (selon réponses aux obligatoires)

### Conditions d'affichage

| Grille optionnelle | Condition | Variable testée |
|-------------------|-----------|-----------------|
| Risque Gains 2 (section 8) | Si investissement = **10** dans Risque Gains 1 | `risque_gains_invest == 10` |
| Risque Pertes 2 (section 9) | Si investissement = **0** dans Risque Pertes 1 | `risque_pertes_invest == 0` |
| Ambiguïté Gains 2 (section 10) | Si investissement = **10** dans Ambiguïté Gains 1 | `ambiguite_gains_invest == 10` |
| Ambiguïté Pertes 2 (section 11) | Si investissement = **0** dans Ambiguïté Pertes 1 | `ambiguite_pertes_invest == 0` |

### Navigation intelligente
- Le participant **saute automatiquement** les grilles optionnelles non activées
- La barre de progression s'ajuste dynamiquement
- Les boutons Précédent/Suivant tiennent compte des sauts

---

## Fonctionnalité 2 : Randomisation

### Randomisation des grilles obligatoires
Les 4 types de grilles (Risque Gains, Risque Pertes, Ambiguïté Gains, Ambiguïté Pertes) sont présentés dans un **ordre aléatoire** aux sections 4-7.

**Exemple** :
- Participant A : Risque Pertes → Ambiguïté Gains → Risque Gains → Ambiguïté Pertes
- Participant B : Ambiguïté Pertes → Risque Gains → Risque Pertes → Ambiguïté Gains

### Randomisation des grilles optionnelles
Si **plusieurs grilles optionnelles** sont activées, elles sont également présentées dans un ordre aléatoire.

**Exemple** :
- Participant répond 10 à Risque Gains et 0 à Risque Pertes
- Grilles optionnelles : Risque Gains 2 + Risque Pertes 2
- Ordre randomisé : peut être Risque Gains 2 → Risque Pertes 2 OU Risque Pertes 2 → Risque Gains 2

---

## Architecture technique

### Nouvelles variables dans `rv`
```r
# Flags conditionnels
show_section_8 = FALSE   # Risque Gains 2
show_section_9 = FALSE   # Risque Pertes 2
show_section_10 = FALSE  # Ambiguïté Gains 2
show_section_11 = FALSE  # Ambiguïté Pertes 2

# Ordres de randomisation
order_grilles_obligatoires   # Ordre aléatoire des 4 types obligatoires
order_grilles_optionnelles   # Ordre aléatoire des types optionnels activés
```

### Nouvelles fonctions dans `server_modules.R`

#### Gestion de la randomisation
- `get_grille_type_for_section(section, rv)` : Retourne le type de grille à une section
- `get_ui_for_grille_type(type, optional)` : Retourne l'UI correspondant au type
- `get_input_name_for_type(type, optional)` : Retourne le nom de l'input Shiny
- `initialize_optional_grilles_order(rv)` : Initialise l'ordre des grilles optionnelles

#### Gestion du flux conditionnel
- `next_section_logic(current, rv)` : Détermine la section suivante (saute les non-activées)
- `previous_section_logic(current, rv)` : Détermine la section précédente
- `calculate_effective_max_section(rv)` : Calcule le nombre total de sections affichées
- `calculate_effective_position(current, rv)` : Calcule la position effective pour la progression

### Modifications des fonctions existantes

#### `validate_current_section()`
- Sections 4-7 : Validation basée sur le type de grille (automatique pour sliders)
- Sections 8-11 : Validation basée sur le type de grille optionnelle (radio buttons)

#### `save_section_data()`
- Sauvegarde selon le type de grille (pas selon le numéro de section fixe)
- Sauvegarde l'ordre de présentation : `grille_obligatoire_X_type` et `grille_optionnelle_X_type`
- Met à jour les flags conditionnels après chaque grille obligatoire

#### `save_participant_data()`
- Sauvegarde les ordres complets : `ordre_grilles_obligatoires` et `ordre_grilles_optionnelles`

---

## Données collectées

### Variables de réponse
Les noms restent **invariants** (indépendants de l'ordre de présentation) :

**Grilles obligatoires** (0-10 jetons) :
- `risque_gains_invest`
- `risque_pertes_invest`
- `ambiguite_gains_invest`
- `ambiguite_pertes_invest`

**Grilles optionnelles** (choix A/B/C/D/E) :
- `risque_gains_2_choix`
- `risque_pertes_2_choix`
- `ambiguite_gains_2_choix`
- `ambiguite_pertes_2_choix`

### Variables d'ordre

**Ordre de présentation des obligatoires** :
- `grille_obligatoire_1_type` : Type à la section 4
- `grille_obligatoire_2_type` : Type à la section 5
- `grille_obligatoire_3_type` : Type à la section 6
- `grille_obligatoire_4_type` : Type à la section 7
- `ordre_grilles_obligatoires` : String séparé par ";" (ex: "risque_gains;ambiguite_pertes;risque_pertes;ambiguite_gains")

**Ordre de présentation des optionnelles** :
- `grille_optionnelle_1_type` : Type à la section 8 (NA si non affichée)
- `grille_optionnelle_2_type` : Type à la section 9 (NA si non affichée)
- `grille_optionnelle_3_type` : Type à la section 10 (NA si non affichée)
- `grille_optionnelle_4_type` : Type à la section 11 (NA si non affichée)
- `ordre_grilles_optionnelles` : String séparé par ";" ou NA (ex: "risque_pertes;ambiguite_gains")

---

## Scénarios de navigation

### Scénario 1 : Participant répondant 5 partout
- Sections obligatoires : 4, 5, 6, 7 (ordre randomisé)
- Sections optionnelles : **aucune** (toutes sautées)
- Après section 7 → Passe directement à section 12
- **Total : 15 sections** (19 - 4 optionnelles)

### Scénario 2 : Participant répondant 10 partout
- Sections obligatoires : 4, 5, 6, 7 (ordre randomisé)
- Sections optionnelles : 8 (Risque Gains 2), 10 (Ambiguïté Gains 2) - **ordre randomisé**
- Sections sautées : 9, 11
- **Total : 17 sections** (19 - 2)

### Scénario 3 : Participant répondant 0 partout
- Sections obligatoires : 4, 5, 6, 7 (ordre randomisé)
- Sections optionnelles : 9 (Risque Pertes 2), 11 (Ambiguïté Pertes 2) - **ordre randomisé**
- Sections sautées : 8, 10
- **Total : 17 sections** (19 - 2)

### Scénario 4 : Participant avec réponses mixtes (10, 0, 5, 0)
Supposons ordre obligatoire : Risque Gains → Risque Pertes → Ambiguïté Gains → Ambiguïté Pertes
- Section 4 (Risque Gains) : répond **10** → active section 8
- Section 5 (Risque Pertes) : répond **0** → active section 9
- Section 6 (Ambiguïté Gains) : répond **5** → n'active rien
- Section 7 (Ambiguïté Pertes) : répond **0** → active section 11
- Sections optionnelles : 8, 9, 11 dans un **ordre randomisé** (ex: 9→11→8)
- Section sautée : 10
- **Total : 18 sections** (19 - 1)

---

## Corrections supplémentaires

### Décision 7 (section 10 - Ambiguïté Gains 2), option C
Les 3 résultats ont été corrigés :
- Boule 🟡 — vous gagnez **5** jetons
- Boule 🟣 — vous gagnez **10** jetons
- Boule 🔵 — vous gagnez **15** jetons

---

## Fichiers modifiés

### `app.R`
- Ajout des variables de randomisation et flags conditionnels
- Modification de `output$current_section` pour utiliser le mapping
- Modification des boutons navigation pour utiliser les logiques next/previous
- Modification de la barre de progression pour calcul effectif

### `modules/server_modules.R`
- Ajout de 9 nouvelles fonctions (randomisation + navigation conditionnelle)
- Refonte de `validate_current_section()` pour sections 4-11
- Refonte de `save_section_data()` pour sections 4-11
- Modification de `save_participant_data()` pour sauvegarder les ordres

### `modules/ui_modules.R`
- Correction de la décision 7, option C (3 résultats au lieu d'1)

---

## Documentation créée

### `DECISIONS_CONDITIONNELLES.md`
- Explication détaillée des conditions d'affichage
- Description de l'implémentation technique
- Exemples de flux de navigation
- Notes pour l'analyse des données

### `RANDOMISATION_GRILLES.md`
- Explication du système de randomisation
- Fonctions utilitaires
- Structure des données sauvegardées
- Exemples complets avec reconstruction de l'ordre
- Guide pour l'analyse statistique des effets d'ordre

### `RESUME_GRILLES_CONDITIONNELLES_RANDOMISEES.md` (ce fichier)
- Vue d'ensemble complète
- Synthèse des deux fonctionnalités
- Scénarios de navigation
- Liste des modifications

---

## Pour tester

1. Lancer l'application : `source("lancer_app.R")`
2. Parcourir les sections 1-3
3. **Observer la randomisation** : Les sections 4-7 affichent les grilles dans un ordre aléatoire
4. **Tester les conditions** :
   - Répondre 10 à une grille de gains → Voir la grille optionnelle correspondante
   - Répondre 0 à une grille de pertes → Voir la grille optionnelle correspondante
   - Répondre 5 partout → Sauter toutes les grilles optionnelles
5. **Vérifier les données** : Dans `data/study_data.csv`, vérifier les variables `ordre_grilles_*` et `grille_*_type`

---

## Notes pour l'analyse

### Contrôler les effets d'ordre
```r
# Exemple de code pour l'analyse
data$position_risque_gains <- sapply(strsplit(data$ordre_grilles_obligatoires, ";"), 
                                      function(x) which(x == "risque_gains"))

# Modèle avec effet de position
lm(acceptabilite_ia ~ aversion_risque_gains + position_risque_gains, data = data)
```

### Analyser les réponses extrêmes
```r
# Proportion de participants avec réponses extrêmes
mean(data$risque_gains_invest == 10 | data$risque_gains_invest == 0)

# Combien ont vu au moins une grille optionnelle ?
mean(!is.na(data$ordre_grilles_optionnelles))
```

### Tester la randomisation
```r
# Vérifier que la randomisation est équilibrée
table(data$grille_obligatoire_1_type)  # Doit être ~ équilibré
```

---

## Avantages de cette implémentation

✅ **Réduit les biais d'ordre** : Chaque grille apparaît à toutes les positions avec la même probabilité  
✅ **Évite la fatigue** : Seuls les participants avec réponses extrêmes voient les grilles optionnelles  
✅ **Navigation fluide** : Le participant ne voit pas les sauts (transition transparente)  
✅ **Données analysables** : L'ordre est enregistré et peut être contrôlé dans les analyses  
✅ **Flexible** : Facile d'ajouter de nouvelles grilles ou de modifier les conditions  

---

## Contact et support

Pour toute question sur l'implémentation, consulter :
- `DECISIONS_CONDITIONNELLES.md` pour les détails techniques des conditions
- `RANDOMISATION_GRILLES.md` pour les détails de la randomisation
- Le code source dans `modules/server_modules.R` (commenté)

**Version** : 6.0  
**Date** : 15 octobre 2025
