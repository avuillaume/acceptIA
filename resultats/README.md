# Dossier des résultats d'analyse

Ce dossier est créé automatiquement par le script `analyse_donnees.R`.

## Contenu généré

Après l'exécution de `source("lancer_analyse.R")`, vous trouverez ici :

### Graphiques (PNG)

1. **correlation_matrix.png**
   - Matrice de corrélations entre tous les scores
   - Visualisation avec coefficients de corrélation

2. **distribution_aversions.png**
   - Histogrammes des 4 scores d'aversion
   - Risk_Gains, Risk_Losses, Ambig_Gains, Ambig_Losses

3. **distribution_perceptions.png**
   - Histogrammes des bénéfices perçus et craintes
   - Superposés pour comparaison

4. **benefices_vs_craintes.png**
   - Nuage de points avec ligne de régression
   - Relation entre bénéfices perçus et craintes

5. **boxplots_scores.png**
   - Boxplots comparatifs de tous les scores
   - Permet de voir les distributions et outliers

### Résultats statistiques (TXT)

**sem_results.txt**
- Résultats complets du modèle SEM
- Indices d'ajustement (CFI, TLI, RMSEA, SRMR)
- Paramètres estimés
- Erreurs standard et p-values
- R² des variables endogènes

### Modèle sauvegardé (RDS)

**sem_model_fit.rds**
- Objet R contenant le modèle SEM complet
- Peut être rechargé pour analyses supplémentaires

```r
# Pour réutiliser le modèle
fit <- readRDS("resultats/sem_model_fit.rds")
summary(fit, standardized = TRUE)
```

## Note

Les fichiers sont écrasés à chaque exécution de l'analyse. Si vous voulez conserver plusieurs versions :

```r
# Option 1 : Renommer le dossier
file.rename("resultats", paste0("resultats_", Sys.Date()))

# Option 2 : Copier les fichiers
file.copy("resultats", "resultats_backup", recursive = TRUE)
```

---

**Généré par** : analyse_donnees.R  
**Version** : 2.0
