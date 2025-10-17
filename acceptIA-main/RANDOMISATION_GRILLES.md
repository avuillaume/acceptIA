# Randomisation des Grilles de Décision - Documentation

## Vue d'ensemble

L'application randomise l'ordre de présentation des grilles de décision pour éviter les biais d'ordre :
1. Les **4 grilles obligatoires** (sections 4-7) sont présentées dans un ordre aléatoire
2. Les **grilles optionnelles** (sections 8-11) sont également randomisées si plusieurs sont affichées

## Grilles de décision

### Types de grilles
1. **Risque Gains** : Investissement avec gains certains vs risqués
2. **Risque Pertes** : Investissement avec pertes certaines vs risquées  
3. **Ambiguïté Gains** : Investissement avec gains connus vs ambigus
4. **Ambiguïté Pertes** : Investissement avec pertes connues vs ambiguës

Chaque type existe en **deux versions** :
- **Version 1** (obligatoire) : Slider d'investissement 0-10 jetons
- **Version 2** (optionnelle) : Choix entre urnes A/B/C/D(ou E)

## Randomisation des grilles obligatoires

### Sections 4-7
Les 4 types de grilles sont présentés dans un ordre aléatoire :

**Exemple de randomisation** :
- Participant 1 : Risque Gains → Ambiguïté Pertes → Risque Pertes → Ambiguïté Gains
- Participant 2 : Ambiguïté Gains → Risque Pertes → Risque Gains → Ambiguïté Pertes
- Participant 3 : Risque Pertes → Ambiguïté Gains → Ambiguïté Pertes → Risque Gains

### Implémentation
```r
# Dans app.R, initialisation de rv
order_grilles_obligatoires = sample(c("risque_gains", "risque_pertes", 
                                      "ambiguite_gains", "ambiguite_pertes"))
```

### Mapping section → type
La fonction `get_grille_type_for_section(section, rv)` retourne le type de grille pour chaque section :
- Section 4 → `rv$order_grilles_obligatoires[1]`
- Section 5 → `rv$order_grilles_obligatoires[2]`
- Section 6 → `rv$order_grilles_obligatoires[3]`
- Section 7 → `rv$order_grilles_obligatoires[4]`

## Randomisation des grilles optionnelles

### Sections 8-11
Les grilles optionnelles sont affichées selon les réponses aux grilles obligatoires :
- **Risque Gains 2** : Si réponse = 10 dans Risque Gains 1
- **Risque Pertes 2** : Si réponse = 0 dans Risque Pertes 1
- **Ambiguïté Gains 2** : Si réponse = 10 dans Ambiguïté Gains 1
- **Ambiguïté Pertes 2** : Si réponse = 0 dans Ambiguïté Pertes 1

### Ordre aléatoire
Si **plusieurs grilles optionnelles** doivent être affichées, elles sont randomisées :

**Exemple** : Participant répond 10 à Risque Gains et 0 à Risque Pertes
- Grilles optionnelles activées : Risque Gains 2 + Risque Pertes 2
- Ordre possible : Risque Pertes 2 → Risque Gains 2 (randomisé)

**Exemple 2** : Participant répond 10 partout
- Grilles optionnelles activées : Risque Gains 2 + Ambiguïté Gains 2
- Ordre possible : Ambiguïté Gains 2 → Risque Gains 2 (randomisé)

### Implémentation
```r
# Après la section 7, initialisation de l'ordre optionnel
initialize_optional_grilles_order <- function(rv) {
  optional_types <- c()
  if (rv$show_section_8) optional_types <- c(optional_types, "risque_gains")
  if (rv$show_section_9) optional_types <- c(optional_types, "risque_pertes")
  if (rv$show_section_10) optional_types <- c(optional_types, "ambiguite_gains")
  if (rv$show_section_11) optional_types <- c(optional_types, "ambiguite_pertes")
  
  # Randomiser si plusieurs grilles
  if (length(optional_types) > 1) {
    optional_types <- sample(optional_types)
  }
  return(optional_types)
}
```

## Fonctions utilitaires

### `get_grille_type_for_section(section, rv)`
Retourne le type de grille ("risque_gains", "risque_pertes", etc.) pour une section donnée.

### `get_ui_for_grille_type(type, optional = FALSE)`
Retourne la fonction UI correspondant au type de grille :
- `optional = FALSE` : Versions 1 (sliders)
- `optional = TRUE` : Versions 2 (choix d'urnes)

### `get_input_name_for_type(type, optional = FALSE)`
Retourne le nom de l'input Shiny pour un type de grille :
- Obligatoires : `"risque_gains_invest"`, `"risque_pertes_invest"`, etc.
- Optionnelles : `"risque_gains_2_choix"`, `"risque_pertes_2_choix"`, etc.

## Données sauvegardées

### Variables d'investissement
Les réponses aux grilles sont sauvegardées avec leurs noms standard :
- `risque_gains_invest` (0-10)
- `risque_pertes_invest` (0-10)
- `ambiguite_gains_invest` (0-10)
- `ambiguite_pertes_invest` (0-10)

### Variables de choix optionnels
- `risque_gains_2_choix` (A/B/C/D)
- `risque_pertes_2_choix` (A/B/C/D)
- `ambiguite_gains_2_choix` (A/B/C)
- `ambiguite_pertes_2_choix` (A/B/C/D)

### Variables d'ordre de présentation

#### Grilles obligatoires
Pour chaque position (1-4), le type de grille présenté :
- `grille_obligatoire_1_type` : Type à la section 4
- `grille_obligatoire_2_type` : Type à la section 5
- `grille_obligatoire_3_type` : Type à la section 6
- `grille_obligatoire_4_type` : Type à la section 7

**Exemple de données** :
```
grille_obligatoire_1_type = "ambiguite_pertes"
grille_obligatoire_2_type = "risque_gains"
grille_obligatoire_3_type = "ambiguite_gains"
grille_obligatoire_4_type = "risque_pertes"
```

#### Grilles optionnelles
Pour chaque position optionnelle affichée :
- `grille_optionnelle_1_type` : Type à la section 8
- `grille_optionnelle_2_type` : Type à la section 9
- `grille_optionnelle_3_type` : Type à la section 10
- `grille_optionnelle_4_type` : Type à la section 11

**Note** : Ces variables sont `NA` si la grille optionnelle n'a pas été affichée.

#### Ordre complet
- `ordre_grilles_obligatoires` : Liste séparée par ";" (ex: "risque_gains;ambiguite_pertes;risque_pertes;ambiguite_gains")
- `ordre_grilles_optionnelles` : Liste séparée par ";" des grilles optionnelles affichées (ex: "risque_pertes;ambiguite_gains") ou `NA` si aucune

## Exemple complet

### Participant A

**Randomisation** :
- Ordre obligatoire : `["risque_pertes", "ambiguite_gains", "risque_gains", "ambiguite_pertes"]`

**Sections 4-7 (obligatoires)** :
1. Section 4 : Risque Pertes → répond **0** → `show_section_9 = TRUE`
2. Section 5 : Ambiguïté Gains → répond **5** → `show_section_10 = FALSE`
3. Section 6 : Risque Gains → répond **10** → `show_section_8 = TRUE`
4. Section 7 : Ambiguïté Pertes → répond **3** → `show_section_11 = FALSE`

**Grilles optionnelles activées** : Risque Pertes 2, Risque Gains 2

**Randomisation optionnelle** : `["risque_gains", "risque_pertes"]`

**Sections 8-9 (optionnelles)** :
1. Section 8 : Risque Gains 2 → répond **B**
2. Section 9 : Risque Pertes 2 → répond **C**

**Données sauvegardées** :
```
risque_pertes_invest = 0
ambiguite_gains_invest = 5
risque_gains_invest = 10
ambiguite_pertes_invest = 3
risque_gains_2_choix = "B"
risque_pertes_2_choix = "C"
grille_obligatoire_1_type = "risque_pertes"
grille_obligatoire_2_type = "ambiguite_gains"
grille_obligatoire_3_type = "risque_gains"
grille_obligatoire_4_type = "ambiguite_pertes"
grille_optionnelle_1_type = "risque_gains"
grille_optionnelle_2_type = "risque_pertes"
ordre_grilles_obligatoires = "risque_pertes;ambiguite_gains;risque_gains;ambiguite_pertes"
ordre_grilles_optionnelles = "risque_gains;risque_pertes"
```

## Analyse des données

### Reconstruction de l'ordre de présentation
Pour chaque participant, vous pouvez reconstruire l'ordre exact de présentation :

```r
# Lire l'ordre obligatoire
ordre_oblig <- strsplit(data$ordre_grilles_obligatoires, ";")[[1]]

# Lire l'ordre optionnel (si applicable)
if (!is.na(data$ordre_grilles_optionnelles)) {
  ordre_opt <- strsplit(data$ordre_grilles_optionnelles, ";")[[1]]
}
```

### Contrôler pour les effets d'ordre
Dans vos analyses, vous pouvez :
1. Inclure la position de présentation comme covariable
2. Tester les effets d'ordre avec des modèles mixtes
3. Vérifier que la randomisation a bien équilibré les groupes

**Exemple** :
```r
# Quelle était la position de "risque_gains" pour ce participant ?
position_rg <- which(ordre_oblig == "risque_gains")

# Modèle avec effet de position
lm(acceptabilite ~ aversion_risque + position_rg, data = data)
```

## Modifications des fichiers

### `app.R`
- Ajout de `order_grilles_obligatoires` et `order_grilles_optionnelles` dans `rv`
- Modification de `output$current_section` pour utiliser les fonctions de mapping

### `modules/server_modules.R`
- Ajout de 5 fonctions utilitaires :
  * `get_grille_type_for_section()`
  * `get_ui_for_grille_type()`
  * `get_input_name_for_type()`
  * `initialize_optional_grilles_order()`
- Modification de `validate_current_section()` pour les sections 4-11
- Modification de `save_section_data()` pour sauvegarder types et ordre
- Modification de `save_participant_data()` pour sauvegarder les ordres complets

## Notes importantes

1. **La randomisation est par participant** : Chaque nouveau participant reçoit un ordre différent
2. **Les noms des variables sont conservés** : `risque_gains_invest` reste toujours `risque_gains_invest`, quelle que soit la position de présentation
3. **L'ordre est sauvegardé** : Les variables `_type` et `ordre_grilles_*` permettent de reconstruire l'ordre exact
4. **Les grilles optionnelles sont randomisées ensemble** : Si un participant voit 3 grilles optionnelles, elles seront dans un ordre aléatoire
5. **Une seule grille optionnelle n'est pas randomisée** : Si seule une grille optionnelle est affichée, elle apparaît directement (pas de randomisation nécessaire)
