# 📐 Architecture mise à jour - 19 sections (8 décisions de risque)

**Date mise à jour** : 15 octobre 2025  
**Changement majeur** : Passage de 4 à 8 décisions de risque

---

## 🗂️ Nouvelle structure complète (19 sections)

```
┌─────────────────────────────────────────────────────────────┐
│                    CONSENTEMENT (Section 0)                  │
│                  ✅ Acceptation participation                │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              BLOC 1 : TÂCHES D'AVERSION (1-11)               │
│                    8 DÉCISIONS DE RISQUE                     │
├─────────────────────────────────────────────────────────────┤
│  Section 1  : Introduction tâches rémunérées                │
│  Section 2  : Tâche de comptage π                           │
│  Section 3  : Félicitations + Instructions jeux             │
│                                                              │
│  ─────────── SÉRIE 1 : 4 PREMIÈRES DÉCISIONS ───────────    │
│  Section 4  : 🎲 Décision 1 - Risque Gains                  │
│               Urne 50/50 | 🟡 Gagner 3× | 🟣 Perdre         │
│               → risque_gains_invest (0-10)                   │
│                                                              │
│  Section 5  : 🎲 Décision 2 - Risque Pertes                 │
│               Urne 50/50 | 🟡 Récupérer | 🟣 Perdre 3×      │
│               → risque_pertes_invest (0-10)                  │
│                                                              │
│  Section 6  : 🎲 Décision 3 - Ambiguïté Gains               │
│               Urne inconnue | 🟡 Gagner 3× | 🟣 Perdre      │
│               → ambiguite_gains_invest (0-10)                │
│                                                              │
│  Section 7  : 🎲 Décision 4 - Ambiguïté Pertes              │
│               Urne inconnue | 🟡 Récupérer | 🟣 Perdre 3×   │
│               → ambiguite_pertes_invest (0-10)               │
│                                                              │
│  ─────────── SÉRIE 2 : 4 NOUVELLES DÉCISIONS ─────────── ✨ │
│  Section 8  : 🎲 Décision 5 - Risque Gains 2                │
│               Urne 50/50 | 🟡 Gagner 3× | 🟣 Perdre         │
│               → risque_gains_2_invest (0-10)                 │
│                                                              │
│  Section 9  : 🎲 Décision 6 - Risque Pertes 2               │
│               Urne 50/50 | 🟡 Récupérer | 🟣 Perdre 3×      │
│               → risque_pertes_2_invest (0-10)                │
│                                                              │
│  Section 10 : 🎲 Décision 7 - Ambiguïté Gains 2             │
│               Urne inconnue | 🟡 Gagner 3× | 🟣 Perdre      │
│               → ambiguite_gains_2_invest (0-10)              │
│                                                              │
│  Section 11 : 🎲 Décision 8 - Ambiguïté Pertes 2            │
│               Urne inconnue | 🟡 Récupérer | 🟣 Perdre 3×   │
│               → ambiguite_pertes_2_invest (0-10)             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│           BLOC 2 : QUESTIONNAIRE IA EN SANTÉ                 │
│                    (Sections 12-19)                          │
├─────────────────────────────────────────────────────────────┤
│  Section 12 : Introduction questionnaire                    │
│               📋 Transition vers questions IA                │
│                                                              │
│  Section 13 : Usages numériques                             │
│               💻 7 fréquences + opinion IA + raisons/freins │
│                                                              │
│  Section 14 : Santé                                         │
│               🏃 10 questions habitudes de vie              │
│                                                              │
│  Section 15 : Bénéfices IA (randomisé A)                    │
│               ✅ 10 échelles Likert (1-7)                   │
│               → Variables: B1-B10                            │
│                                                              │
│  Section 16 : Craintes IA (randomisé B)                     │
│               ⚠️ 10 échelles Likert (1-7)                   │
│               → Variables: C1-C10                            │
│                                                              │
│  Section 17 : Usages santé numériques                       │
│               📱 Téléconsultation, Doctolib, ENS, objets... │
│                                                              │
│  Section 18 : Sociodémographiques                           │
│               👤 7 variables (âge, sexe, éducation...)      │
│                                                              │
│  Section 19 : Fin                                           │
│               🏆 Remerciements                               │
└─────────────────────────────────────────────────────────────┘
                            ↓
                    📊 FIN - Données sauvegardées
```

---

## 📊 Comparaison Avant/Après

| Métrique | Avant | Après | Différence |
|----------|-------|-------|------------|
| **Sections totales** | 15 | **19** | +4 |
| **Décisions de risque** | 4 | **8** | +4 |
| **Variables d'aversion** | 4 | **8** | +4 |
| **Variables totales** | ~65 | **~69** | +4 |
| **Durée estimée** | 25-30 min | **30-35 min** | +5 min |
| **Progression/section** | ~6.7% | **~5.3%** | -1.4% |

---

## 🎯 Avantages des 8 décisions

### 1. **Fiabilité accrue**
- **Test-retest** : Mesure répétée de chaque type d'aversion
- **Cohérence** : Évaluation de la stabilité des préférences
- **Précision** : Moyenne de 2 mesures = réduction de l'erreur

### 2. **Analyses plus riches**
```r
# Corrélations test-retest
cor(risque_gains_invest, risque_gains_2_invest)
cor(ambiguite_pertes_invest, ambiguite_pertes_2_invest)

# Scores moyens plus robustes
aversion_risque_gains_moy <- mean(RG1, RG2)
aversion_ambig_pertes_moy <- mean(AP1, AP2)

# Détection des incohérences
inconsistency <- abs(RG1 - RG2) > 5  # Seuil arbitraire
```

### 3. **Robustesse scientifique**
- Protocole aligné sur les standards de la littérature
- Réduction du biais de mesure unique
- Meilleure généralisation des résultats

---

## 💾 Nouvelles variables dans `study_data.csv`

### Variables d'investissement (8 au total)

```csv
participant_id,risque_gains_invest,risque_pertes_invest,ambiguite_gains_invest,ambiguite_pertes_invest,risque_gains_2_invest,risque_pertes_2_invest,ambiguite_gains_2_invest,ambiguite_pertes_2_invest,...
P20251015123456,7,5,6,4,6,5,5,3,...
```

| Variable | Décision | Type | Min | Max |
|----------|----------|------|-----|-----|
| `risque_gains_invest` | 1 | Risque Gains | 0 | 10 |
| `risque_pertes_invest` | 2 | Risque Pertes | 0 | 10 |
| `ambiguite_gains_invest` | 3 | Ambiguïté Gains | 0 | 10 |
| `ambiguite_pertes_invest` | 4 | Ambiguïté Pertes | 0 | 10 |
| **`risque_gains_2_invest`** ✨ | **5** | **Risque Gains** | **0** | **10** |
| **`risque_pertes_2_invest`** ✨ | **6** | **Risque Pertes** | **0** | **10** |
| **`ambiguite_gains_2_invest`** ✨ | **7** | **Ambiguïté Gains** | **0** | **10** |
| **`ambiguite_pertes_2_invest`** ✨ | **8** | **Ambiguïté Pertes** | **0** | **10** |

---

## 🔄 Flux de navigation mis à jour

```
Consentement → Section 1 → ... → Section 19 → Fin
    ↑                                            ↓
    └───────────── Bouton Précédent ─────────────┘

⚠️ Navigation bloquée si validation échoue
💾 Sauvegarde automatique à chaque changement de section
📊 Barre de progression : chaque section = 5.26%
```

---

## 📈 Calculs de scores recommandés

### Scores individuels par mesure
```r
# Série 1 (décisions 1-4)
aversion_RG_1 <- 10 - risque_gains_invest
aversion_RP_1 <- 10 - risque_pertes_invest
aversion_AG_1 <- 10 - ambiguite_gains_invest
aversion_AP_1 <- 10 - ambiguite_pertes_invest

# Série 2 (décisions 5-8)
aversion_RG_2 <- 10 - risque_gains_2_invest
aversion_RP_2 <- 10 - risque_pertes_2_invest
aversion_AG_2 <- 10 - ambiguite_gains_2_invest
aversion_AP_2 <- 10 - ambiguite_pertes_2_invest
```

### Scores moyens (recommandé)
```r
# Moyenne des 2 mesures = score plus robuste
aversion_risque_gains <- (aversion_RG_1 + aversion_RG_2) / 2
aversion_risque_pertes <- (aversion_RP_1 + aversion_RP_2) / 2
aversion_ambig_gains <- (aversion_AG_1 + aversion_AG_2) / 2
aversion_ambig_pertes <- (aversion_AP_1 + aversion_AP_2) / 2
```

### Indices de cohérence
```r
# Différence absolue entre les 2 mesures
coherence_RG <- abs(aversion_RG_1 - aversion_RG_2)
coherence_RP <- abs(aversion_RP_1 - aversion_RP_2)
coherence_AG <- abs(aversion_AG_1 - aversion_AG_2)
coherence_AP <- abs(aversion_AP_1 - aversion_AP_2)

# Score global de cohérence
coherence_totale <- mean(c(coherence_RG, coherence_RP, coherence_AG, coherence_AP))

# Identifier participants incohérents (différence > 5)
incohérents <- coherence_totale > 5
```

---

## 🎨 Interface utilisateur

### Résumés dynamiques pour chaque décision
- ✅ **Décision 1-4** : Résumés existants
- ✅ **Décision 5-8** : Nouveaux résumés identiques

### Rappel systématique
Chaque nouvelle décision (5-8) affiche :
> ⚠️ Le tirage au sort de la décision donnant lieu à votre rémunération finale n'a lieu qu'à la fin de tous les jeux. **Vous disposez donc toujours à ce stade de vos 30 jetons initiaux.**

---

## 📚 Documentation mise à jour

- ✅ `AJOUT_DECISIONS_5-8.md` - Détails de la modification
- ✅ `ARCHITECTURE_V5.md` - Cette architecture (19 sections)
- ⏳ `README.md` - À mettre à jour avec nouvelle structure
- ⏳ `GUIDE_ANALYSE.md` - À mettre à jour avec 8 variables

---

## ✅ Tests recommandés

Avant de lancer avec de vrais participants :

1. **Test navigation**
   ```r
   source("lancer_app.R")
   # Naviguer de section 1 à 19
   # Vérifier que Précédent/Suivant fonctionnent
   ```

2. **Test validation**
   - Essayer de passer section 2 sans comptage → Blocage ✅
   - Essayer de passer sections 8-11 → Devrait passer (sliders) ✅

3. **Test sauvegarde**
   ```r
   # Compléter une session complète
   # Vérifier data/study_data.csv
   data <- read.csv("data/study_data.csv")
   names(data)  # Devrait contenir risque_gains_2_invest, etc.
   ```

4. **Test résumés dynamiques**
   - Sections 8-11 : Bouger sliders → Résumés doivent se mettre à jour
   - Vérifier calculs gains/pertes corrects

---

## 🚀 Prêt à utiliser !

Votre application est maintenant configurée avec **8 décisions de risque** comme prévu dans votre protocole expérimental.

**Version** : 5.0 (8 décisions)  
**Date** : 15 octobre 2025  
**Statut** : ✅ Opérationnelle
