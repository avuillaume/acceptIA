# Système de Tirage au Sort et Rémunération - Documentation

## Vue d'ensemble

À la fin de l'expérience, **une décision est sélectionnée aléatoirement** parmi toutes celles complétées par le participant, puis un tirage au sort est effectué pour déterminer la rémunération finale.

## Principe général

### Dotation initiale
Chaque participant commence avec **30 jetons**.

### Sélection de la décision
- Une décision est tirée au sort parmi **toutes les décisions complétées** (obligatoires + optionnelles)
- Chaque décision a la **même probabilité** d'être sélectionnée
- Le participant ne sait pas quelle décision sera sélectionnée avant la fin

### Tirage au sort
Selon la décision sélectionnée et la réponse du participant, un tirage au sort détermine le gain/perte.

### Rémunération finale
```
Rémunération finale = 30 jetons initiaux + gain/perte du tirage
```

---

## Grilles obligatoires (Décisions 1-4)

### Format
Le participant choisit combien investir (0-10 jetons) :
- **Jetons invest**is : Soumis au tirage au sort
- **Jetons conservés** : Gardés avec certitude (10 - investissement)

### Décision 1 : Risque et Gains
**Réponse** : Investissement de 0 à 10 jetons

**Tirage** :
- 50% de chances : L'investissement est **doublé** (×2)
- 50% de chances : L'investissement est **perdu** (×0)

**Calcul** :
- Jetons conservés = 10 - investissement
- Si succès : Jetons finaux = conservés + (investissement × 2)
- Si échec : Jetons finaux = conservés

**Exemple** : Investissement de 6 jetons
- Conservés = 4 jetons
- Succès (50%) → 4 + 12 = 16 jetons → Gain de +6 jetons
- Échec (50%) → 4 + 0 = 4 jetons → Perte de -6 jetons

### Décision 2 : Risque et Pertes
**Réponse** : Investissement de 0 à 10 jetons

**Tirage** :
- 50% de chances : L'investissement est **perdu**
- 50% de chances : **Aucune perte**

**Calcul** :
- Jetons conservés = 10 - investissement
- Si perte (50%) : Jetons finaux = conservés - investissement
- Si pas de perte (50%) : Jetons finaux = conservés

**Exemple** : Investissement de 3 jetons
- Conservés = 7 jetons
- Perte (50%) → 7 - 3 = 4 jetons → Perte de -6 jetons
- Pas de perte (50%) → 7 + 0 = 7 jetons → Perte de -3 jetons

### Décision 3 : Ambiguïté et Gains
Identique à Décision 1, mais avec des probabilités inconnues.

### Décision 4 : Ambiguïté et Pertes
Identique à Décision 2, mais avec des probabilités inconnues.

---

## Grilles optionnelles (Décisions 5-8)

### Format
Le participant choisit une urne parmi plusieurs options (A, B, C, D, parfois E).
Une boule est tirée au sort, et sa couleur détermine le gain/perte.

### Décision 5 : Risque et Gains 2 (si investissement = 10 dans Décision 1)

**Option A** : 60 boules 🟡
- Boule 🟡 → +10 jetons

**Option B** : 30 boules 🟡 / 30 boules 🟣
- Boule 🟡 (50%) → +5 jetons
- Boule 🟣 (50%) → +15 jetons

**Option C** : 20 boules 🟡 / 20 boules 🟣 / 20 boules 🔵
- Boule 🟡 (33%) → +5 jetons
- Boule 🟣 (33%) → +15 jetons
- Boule 🔵 (33%) → +10 jetons

**Option D** : 30 boules 🟡 / 30 boules 🟣
- Boule 🟡 (50%) → 0 jetons
- Boule 🟣 (50%) → +20 jetons

### Décision 6 : Risque et Pertes 2 (si investissement = 0 dans Décision 2)

**Option A** : 60 boules 🟡
- Boule 🟡 → -10 jetons

**Option B** : 30 boules 🟡 / 30 boules 🟣
- Boule 🟡 (50%) → -5 jetons
- Boule 🟣 (50%) → -15 jetons

**Option C** : 20 boules 🟡 / 20 boules 🟣 / 20 boules 🔵
- Boule 🟡 (33%) → -5 jetons
- Boule 🟣 (33%) → -15 jetons
- Boule 🔵 (33%) → -10 jetons

**Option D** : 30 boules 🟡 / 30 boules 🟣
- Boule 🟡 (50%) → 0 jetons
- Boule 🟣 (50%) → -20 jetons

### Décision 7 : Ambiguïté et Gains 2 (si investissement = 10 dans Décision 3)

**Option A** : 60 boules 🟡
- Boule 🟡 → +10 jetons

**Option B** : ? boules 🟡 / ? boules 🟣 (composition inconnue)
- Boule 🟡 (?) → +5 jetons
- Boule 🟣 (?) → +15 jetons

**Option C** : ? boules 🟡 / ? boules 🟣 / ? boules 🔵 (composition inconnue)
- Boule 🟡 (?) → +5 jetons
- Boule 🟣 (?) → +10 jetons
- Boule 🔵 (?) → +15 jetons

**Option D** : ? boules 🟡 / ? boules 🟣 (composition inconnue)
- Boule 🟡 (?) → 0 jetons
- Boule 🟣 (?) → +20 jetons

### Décision 8 : Ambiguïté et Pertes 2 (si investissement = 0 dans Décision 4)

**Option A** : 60 boules 🟡
- Boule 🟡 → -10 jetons

**Option B** : ? boules 🟡 / ? boules 🟣 (composition inconnue)
- Boule 🟡 (?) → -5 jetons
- Boule 🟣 (?) → -15 jetons

**Option C** : ? boules 🟡 / ? boules 🟣 / ? boules 🔵 (composition inconnue)
- Boule 🟡 (?) → -5 jetons
- Boule 🟣 (?) → -10 jetons
- Boule 🔵 (?) → -15 jetons

**Option D** : ? boules 🟡 / ? boules 🟣 (composition inconnue)
- Boule 🟡 (?) → 0 jetons
- Boule 🟣 (?) → -20 jetons

**Note** : Pour les urnes amb iguës, la composition exacte est générée aléatoirement au moment du tirage final.

---

## Implémentation technique

### Fonctions principales

#### `select_random_grille(rv)`
Sélectionne aléatoirement une décision parmi toutes celles complétées.

**Retour** :
```r
list(
  type = "risque_gains",           # Type de grille
  optional = FALSE,                # TRUE si grille optionnelle
  decision_number = 1,             # Numéro de la décision (1-8)
  response = 7                     # Réponse du participant
)
```

#### `perform_lottery(selected_grille)`
Effectue le tirage au sort selon la grille sélectionnée.

**Pour grilles obligatoires**, retourne :
```r
list(
  lottery_result = TRUE,           # TRUE = succès (gains) ou perte (pertes)
  kept_tokens = 3,                 # Jetons conservés
  lottery_tokens = 14,             # Jetons de la loterie
  net_change = 7                   # Changement net (-10 à +20)
)
```

**Pour grilles optionnelles**, retourne :
```r
list(
  urn_choice = "B",                # Choix de l'urne
  urn_composition = list(          # Composition de l'urne
    yellow = 30,
    purple = 30,
    blue = 0
  ),
  drawn_color = "purple",          # Couleur tirée
  net_change = 15                  # Gain/perte
)
```

#### `perform_urn_lottery(type, choice)`
Effectue un tirage d'urne pour les grilles optionnelles.
- Définit la composition de l'urne selon le type et le choix
- Pour les urnes ambiguës, génère une composition aléatoire
- Tire une boule au sort
- Retourne le gain/perte correspondant

#### `calculate_final_payoff(lottery_result)`
Calcule la rémunération finale :
```r
final_payoff = 30 + net_change
```

#### `execute_final_lottery(rv)`
Fonction principale qui :
1. Sélectionne une décision aléatoire
2. Effectue le tirage au sort
3. Calcule la rémunération finale
4. Retourne toutes les informations

**Retour** :
```r
list(
  selected_grille = ...,           # Décision sélectionnée
  lottery_result = ...,            # Résultat du tirage
  final_payoff = 37                # Rémunération finale (jetons)
)
```

---

## Moment d'exécution

### Quand le tirage est effectué
Le tirage est exécuté **automatiquement** lorsque le participant passe de la section 18 à la section 19 (fin).

```r
# Dans observeEvent(input$btn_next)
if (next_sec == 19 && !rv$lottery_executed) {
  rv$lottery_results <- execute_final_lottery(rv)
  rv$lottery_executed <- TRUE
}
```

### Affichage des résultats
Les résultats sont affichés dans la section 19 (fin) via `output$lottery_results_display`.

L'affichage inclut :
- La décision sélectionnée
- Le détail du tirage (composition de l'urne, couleur tirée, etc.)
- Le gain ou la perte
- **La rémunération finale en jetons**

---

## Données sauvegardées

### Variables relatives au tirage

#### Décision sélectionnée
- `lottery_decision_number` : Numéro de la décision (1-8)
- `lottery_decision_type` : Type ("risque_gains", "risque_pertes", "ambiguite_gains", "ambiguite_pertes")
- `lottery_decision_optional` : TRUE/FALSE (grille optionnelle ou obligatoire)
- `lottery_response` : Réponse du participant (0-10 ou A/B/C/D)

#### Résultats du tirage - Grilles obligatoires
- `lottery_result` : TRUE/FALSE (succès ou échec)
- `lottery_kept_tokens` : Jetons conservés (0-10)
- `lottery_tokens` : Jetons de la loterie

#### Résultats du tirage - Grilles optionnelles
- `lottery_urn_yellow` : Nombre de boules jaunes (0-60)
- `lottery_urn_purple` : Nombre de boules violettes (0-60)
- `lottery_urn_blue` : Nombre de boules bleues (0-60)
- `lottery_drawn_color` : Couleur tirée ("yellow", "purple", "blue")

#### Rémunération
- `lottery_net_change` : Gain/perte net (-20 à +20)
- `final_payoff` : Rémunération finale en jetons (10 à 50)

---

## Exemples complets

### Exemple 1 : Grille obligatoire (Risque Gains)

**Participant** :
- Décision 1 sélectionnée (Risque Gains)
- Investissement : 8 jetons
- Jetons conservés : 2 jetons

**Tirage** :
- Résultat : SUCCÈS (50% de chances)
- Jetons de la loterie : 8 × 2 = 16 jetons

**Calcul** :
- Jetons après décision : 2 + 16 = 18 jetons
- Changement net : 18 - 10 = +8 jetons
- **Rémunération finale : 30 + 8 = 38 jetons**

**Données sauvegardées** :
```
lottery_decision_number = 1
lottery_decision_type = "risque_gains"
lottery_decision_optional = FALSE
lottery_response = 8
lottery_result = TRUE
lottery_kept_tokens = 2
lottery_tokens = 16
lottery_net_change = 8
final_payoff = 38
```

### Exemple 2 : Grille optionnelle (Ambiguïté Gains 2, Urne B)

**Participant** :
- Décision 7 sélectionnée (Ambiguïté Gains 2)
- Choix : Urne B

**Composition de l'urne** (générée aléatoirement) :
- 18 boules 🟡
- 42 boules 🟣
- 0 boules 🔵

**Tirage** :
- Boule tirée : 🟣 VIOLETTE

**Résultat** :
- Boule 🟣 → +15 jetons

**Calcul** :
- Changement net : +15 jetons
- **Rémunération finale : 30 + 15 = 45 jetons**

**Données sauvegardées** :
```
lottery_decision_number = 7
lottery_decision_type = "ambiguite_gains"
lottery_decision_optional = TRUE
lottery_response = "B"
lottery_urn_yellow = 18
lottery_urn_purple = 42
lottery_urn_blue = 0
lottery_drawn_color = "purple"
lottery_net_change = 15
final_payoff = 45
```

---

## Notes importantes

### Stratégie optimale
Le fait que **toutes les décisions ont la même probabilité d'être sélectionnées** incite le participant à répondre sincèrement à chaque décision.

### Transparence
Les résultats du tirage sont **transparents** :
- Le participant voit quelle décision a été sélectionnée
- Il voit le détail du tirage (composition de l'urne, couleur tirée, etc.)
- Il peut vérifier le calcul de sa rémunération

### Ambiguïté réelle
Pour les urnes ambiguës (Décisions 7-8), la composition est **réellement générée aléatoirement** au moment du tirage final, ce qui garantit l'ambiguïté.

### Reproductibilité
Toutes les informations du tirage sont sauvegardées, permettant de :
- Vérifier la rémunération
- Reproduire les résultats
- Analyser les patterns de tirages

---

## Modifications des fichiers

### `modules/server_modules.R`
- Ajout de 6 nouvelles fonctions de tirage :
  * `select_random_grille()`
  * `perform_lottery()`
  * `perform_urn_lottery()`
  * `calculate_final_payoff()`
  * `execute_final_lottery()`
- Modification de `save_participant_data()` pour sauvegarder les résultats

### `app.R`
- Ajout des variables `lottery_executed` et `lottery_results` dans `rv`
- Exécution du tirage avant la section 19
- Ajout de `output$lottery_results_display` pour afficher les résultats

### `modules/ui_modules_suite.R`
- Modification de `section_fin_ui()` pour inclure l'affichage du tirage

---

## Pour les participants

### Instructions
"À la fin de l'étude, une de vos décisions sera sélectionnée au hasard et un tirage au sort sera effectué pour déterminer votre rémunération. Vous commencez avec 30 jetons, et selon le résultat, vous pouvez gagner ou perdre des jetons. Votre rémunération finale vous sera communiquée à la fin."

### Conversion jetons → argent
À définir selon le budget de l'étude (ex: 1 jeton = 0,10€).

---

**Version** : 1.0  
**Date** : 15 octobre 2025
