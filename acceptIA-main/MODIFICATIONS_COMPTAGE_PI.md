# 🔢 Modifications - Tâche de Comptage des Décimales de π

**Date** : 14 octobre 2025  
**Version** : 4.1

---

## 📋 Résumé des Modifications

La tâche de comptage des décimales de π a été améliorée avec les fonctionnalités suivantes :

1. **Ajout de nouvelles décimales** : Extension de 200 à 200 décimales complètes
2. **Randomisation du chiffre à compter** : Chaque participant compte un chiffre différent (0-9)
3. **Validation stricte** : Obligation de trouver la bonne réponse pour continuer
4. **Feedback visuel** : Message d'erreur si la réponse est incorrecte

---

## 🔢 Nouvelles Décimales de π

### Décimales complètes (200 premières)

```
π = 3,141592653589793238462643383279502884197169399375105820974944592307816406286208998628034825342117067982148086513282306647093844609550582231725359408128481117450284102701938521105559644622948954930381969
```

### Nouvelles décimales ajoutées

Les 26 nouvelles décimales ajoutées à la fin :
```
10555964462294895493038196
```

---

## 📊 Distribution des Chiffres (0-9)

| Chiffre | Occurrences |
|---------|-------------|
| **0**   | 19 fois     |
| **1**   | 20 fois     |
| **2**   | 24 fois     |
| **3**   | 19 fois     |
| **4**   | 22 fois     |
| **5**   | 20 fois     |
| **6**   | 16 fois     |
| **7**   | 12 fois     |
| **8**   | 25 fois     |
| **9**   | 23 fois     |

**Total** : 200 décimales

---

## ⚙️ Fonctionnalités Implémentées

### 1️⃣ Randomisation du Chiffre

**Fichier** : `modules/server_modules.R`

```r
# Fonction pour initialiser la tâche de comptage avec un chiffre aléatoire
initialize_counting_task <- function() {
  # Choisir un chiffre aléatoire entre 0 et 9
  digit <- sample(0:9, 1)
  
  # Compter les occurrences de ce chiffre
  correct_count <- count_digit_in_pi(digit)
  
  return(list(
    digit = digit,
    correct_count = correct_count
  ))
}
```

**Initialisation dans app.R** :
- Le chiffre est randomisé au démarrage de chaque session
- Chaque participant reçoit un chiffre différent à compter (0-9)

### 2️⃣ Validation Stricte

**Fichier** : `modules/server_modules.R`

```r
# Section 2 : Tâche de comptage - Validation stricte
if (section == 2) {
  if (is.null(input$comptage_pi) || is.na(input$comptage_pi)) {
    return(FALSE)
  }
  
  # Vérifier la bonne réponse selon le chiffre randomisé
  if (!is.null(rv) && !is.null(rv$digit_to_count)) {
    correct_answer <- rv$correct_count
    is_correct <- (input$comptage_pi == correct_answer)
    
    # Mettre à jour le flag d'erreur
    rv$counting_error <- !is_correct
    
    return(is_correct)
  }
  
  return(FALSE)
}
```

**Comportement** :
- ✅ Si la réponse est correcte → Passage à la section suivante
- ❌ Si la réponse est incorrecte → Affichage d'un message d'erreur + obligation de réessayer

### 3️⃣ Feedback Visuel

**Fichier** : `modules/ui_modules.R`

Message d'erreur affiché si la réponse est incorrecte :

```r
conditionalPanel(
  condition = "output.show_counting_error == true",
  div(
    style = "background-color: #f8d7da; color: #721c24; padding: 15px; ...",
    p(icon("times-circle"), " ", strong("Réponse incorrecte."), 
      " Veuillez recompter attentivement...")
  )
)
```

**Style** :
- 🔴 Fond rouge clair (#f8d7da)
- ⚠️ Icône croix rouge
- 📝 Message clair demandant de réessayer

### 4️⃣ Affichage Dynamique du Chiffre

**Fichier** : `app.R`

```r
# Outputs pour afficher le chiffre à compter
output$digit_to_count_display <- renderUI({
  if (!is.null(rv$digit_to_count)) {
    tags$span(style = "color: #e74c3c; font-size: 24px; font-weight: bold;", 
              rv$digit_to_count)
  }
})
```

**Affichage** :
- Police grande (24px)
- Couleur rouge (#e74c3c)
- Gras pour attirer l'attention

---

## 🎯 Parcours Utilisateur

### Scénario 1 : Réponse Correcte

1. Participant voit "Comptez le chiffre **7**"
2. Participant compte et trouve **12 occurrences**
3. Participant entre `12` dans le champ
4. Participant clique sur "Suivant"
5. ✅ **Validation réussie** → Passage à la section 3 (Félicitations)

### Scénario 2 : Réponse Incorrecte

1. Participant voit "Comptez le chiffre **7**"
2. Participant compte rapidement et trouve **10 occurrences** (erreur)
3. Participant entre `10` dans le champ
4. Participant clique sur "Suivant"
5. ❌ **Validation échouée** → Message d'erreur affiché :
   ```
   ⚠️ Réponse incorrecte. 
   Veuillez recompter attentivement le nombre d'occurrences du chiffre 7.
   ```
6. Participant recompte plus attentivement
7. Participant entre `12` (bonne réponse)
8. Participant clique sur "Suivant"
9. ✅ **Validation réussie** → Passage à la section suivante

---

## 💾 Données Collectées

Les variables suivantes sont sauvegardées pour chaque participant :

| Variable | Description | Exemple |
|----------|-------------|---------|
| `comptage_pi` | Réponse du participant | `12` |
| `digit_to_count` | Chiffre randomisé à compter | `7` |
| `correct_count` | Bonne réponse | `12` |

**Fichier** : `data/study_data.csv`

Cela permet d'analyser :
- La difficulté selon le chiffre à compter
- Le taux de réussite au premier essai
- Le temps passé sur la tâche (via timestamp)

---

## 📊 Analyses Possibles

### 1. Difficulté par Chiffre

```r
# Charger les données
load("data/study_data.RData")

# Analyser la difficulté par chiffre
data %>%
  group_by(digit_to_count) %>%
  summarise(
    n = n(),
    occurrences = mean(correct_count),
    reussite_1er_essai = mean(comptage_pi == correct_count)
  )
```

### 2. Corrélation avec Aversion au Risque

```r
# Les participants qui réussissent du premier coup sont-ils plus précis ?
# Lien avec l'aversion au risque ?

cor.test(data$reussite_comptage, data$risque_gains_invest)
```

### 3. Impact du Chiffre sur la Performance

```r
# Les chiffres rares (6, 7) sont-ils plus faciles à compter ?

ggplot(data, aes(x = factor(digit_to_count), y = comptage_pi - correct_count)) +
  geom_boxplot() +
  labs(title = "Erreur de comptage selon le chiffre",
       x = "Chiffre à compter",
       y = "Erreur (réponse - vérité)")
```

---

## 🔧 Fichiers Modifiés

### 1. `modules/ui_modules.R`
- ✏️ Modification de `section_tache_comptage_ui()`
- ➕ Ajout des nouvelles décimales de π
- ➕ Affichage dynamique du chiffre à compter
- ➕ Message d'erreur conditionnel

### 2. `modules/server_modules.R`
- ➕ Ajout de `count_digit_in_pi(digit)`
- ➕ Ajout de `initialize_counting_task()`
- ✏️ Modification de `validate_current_section()` avec validation stricte
- ✏️ Modification de `save_section_data()` pour sauvegarder les nouvelles variables

### 3. `app.R`
- ➕ Ajout de variables réactives : `digit_to_count`, `correct_count`, `counting_error`
- ➕ Initialisation de la tâche au démarrage
- ➕ Outputs pour afficher le chiffre dynamiquement
- ✏️ Modification de la validation dans `observeEvent(input$btn_next)`

---

## ✅ Tests Recommandés

### Test 1 : Randomisation
- [ ] Relancer l'application plusieurs fois
- [ ] Vérifier que le chiffre change à chaque session
- [ ] Vérifier que tous les chiffres (0-9) peuvent apparaître

### Test 2 : Validation Correcte
- [ ] Entrer la bonne réponse
- [ ] Vérifier que l'on passe bien à la section suivante
- [ ] Vérifier qu'aucun message d'erreur ne s'affiche

### Test 3 : Validation Incorrecte
- [ ] Entrer une mauvaise réponse
- [ ] Vérifier que le message d'erreur s'affiche
- [ ] Vérifier qu'on ne peut pas passer à la section suivante
- [ ] Corriger la réponse et vérifier qu'on peut continuer

### Test 4 : Sauvegarde des Données
- [ ] Compléter la tâche
- [ ] Vérifier que `digit_to_count`, `correct_count` et `comptage_pi` sont sauvegardés dans `data/study_data.csv`

### Test 5 : Chiffres Rares
- [ ] Tester avec le chiffre 7 (12 occurrences - le plus rare)
- [ ] Tester avec le chiffre 8 (25 occurrences - le plus fréquent)

---

## 🎓 Justification Scientifique

Cette modification améliore la qualité des données collectées :

1. **Attention soutenue** : Obligation de compter correctement force l'attention
2. **Contrôle qualité** : Élimine les participants qui répondent au hasard
3. **Randomisation** : Évite les biais de mémorisation entre participants
4. **Mesure de précision** : Permet d'évaluer la capacité d'attention et de comptage

---

## 📝 Notes Importantes

### ⚠️ Points d'Attention

1. **Temps de comptage** : La tâche peut prendre 3-5 minutes
2. **Frustration possible** : Certains participants peuvent être frustrés s'ils se trompent
3. **Accessibilité** : S'assurer que la police est lisible (monospace utilisée)

### 💡 Améliorations Futures Possibles

- [ ] Ajouter un compteur de tentatives
- [ ] Limiter le nombre de tentatives (ex: max 3)
- [ ] Afficher un indice après 2 échecs
- [ ] Ajouter un timer pour mesurer le temps de comptage

---

**Version** : 4.1  
**Dernière mise à jour** : 14 octobre 2025  
**Projet** : Acceptabilité de l'IA en Santé

---

## 🔗 Liens Utiles

- [README.md](README.md) - Documentation générale
- [DEMARRAGE_RAPIDE.md](DEMARRAGE_RAPIDE.md) - Guide de démarrage
- [ARCHITECTURE_V4.md](ARCHITECTURE_V4.md) - Architecture complète
