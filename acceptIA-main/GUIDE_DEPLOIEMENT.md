# 🚀 Guide de déploiement ShinyApps.io

## 📋 Checklist avant déploiement

### ✅ Fichiers à déployer (5 fichiers obligatoires)

```
✓ app.R
✓ modules/ui_modules.R
✓ modules/ui_modules_suite.R
✓ modules/server_modules.R
✓ modules/data_functions.R
```

### ❌ Fichiers à NE PAS déployer

```
✗ test_mongodb.R
✗ telecharger_donnees.R
✗ analyse_donnees.R
✗ lancer_app.R
✗ data/ (dossier)
✗ resultats/ (dossier)
✗ *.md (documentation)
```

---

## 🔧 Étape 1 : Configurer votre compte ShinyApps.io

### A) Créer un compte (si pas déjà fait)

1. Allez sur [https://www.shinyapps.io/admin/#/signup](https://www.shinyapps.io/admin/#/signup)
2. Créez un compte gratuit ou payant selon vos besoins

### B) Obtenir votre token

1. Connectez-vous sur [https://www.shinyapps.io](https://www.shinyapps.io)
2. Cliquez sur votre **nom** (en haut à droite)
3. **Account** → **Tokens**
4. Cliquez sur **"Show"** à côté de votre token
5. Cliquez sur **"Show Secret"**
6. Copiez la commande `rsconnect::setAccountInfo(...)`

### C) Configurer dans R

```r
# Coller la commande copiée, exemple :
rsconnect::setAccountInfo(
  name = 'votre-nom-utilisateur',
  token = 'ABCD1234EFGH5678',
  secret = 'WXYZ9876abcd5432'
)
```

✅ **À faire UNE SEULE FOIS**

---

## 🚀 Étape 2 : Déployer l'application

### Méthode A : Script automatique (RECOMMANDÉ)

```r
# Lancer le script de déploiement
source("deployer_shinyapps.R")
```

Le script va :
1. ✅ Vérifier que votre compte est configuré
2. ✅ Vérifier que tous les fichiers sont présents
3. ✅ Déployer automatiquement
4. ✅ Ouvrir l'application dans votre navigateur

### Méthode B : Commande manuelle

```r
library(rsconnect)

rsconnect::deployApp(
  appFiles = c(
    "app.R",
    "modules/ui_modules.R",
    "modules/ui_modules_suite.R",
    "modules/server_modules.R",
    "modules/data_functions.R"
  ),
  appName = "acceptia-study",
  forceUpdate = TRUE
)
```

---

## ⏱️ Durée du déploiement

- **Première fois** : 5-10 minutes
  - Installation des packages (shiny, mongolite, etc.)
  - Upload des fichiers
  - Configuration

- **Mises à jour suivantes** : 2-3 minutes
  - Seulement les fichiers modifiés sont uploadés

---

## 🌐 Accéder à votre application

Une fois déployée, votre application sera disponible sur :

```
https://VOTRE-NOM.shinyapps.io/acceptia-study/
```

Exemple :
```
https://anthonydcexp.shinyapps.io/acceptia-study/
```

---

## 🔍 Vérifications post-déploiement

### 1. Tester l'application

✅ Ouvrez l'URL
✅ Remplissez un questionnaire de test jusqu'au bout
✅ Vérifiez qu'il n'y a pas d'erreur

### 2. Vérifier que MongoDB fonctionne

```r
# Sur votre PC, téléchargez les données
source("telecharger_donnees.R")
```

Vous devriez voir votre participant de test !

### 3. Consulter les logs (en cas d'erreur)

1. Allez sur [https://www.shinyapps.io](https://www.shinyapps.io)
2. Cliquez sur votre application
3. Onglet **"Logs"**
4. Regardez les messages d'erreur en rouge

---

## 🐛 Résolution de problèmes

### Erreur : "Package 'mongolite' not available"

**Solution** : ShinyApps.io installe automatiquement les packages. Patientez quelques minutes.

### Erreur : "Authentication failed" (MongoDB)

**Solution** : Vérifiez que votre connection string est correcte dans `data_functions.R`

### Erreur : "IP not authorized" (MongoDB)

**Solution** : 
1. Allez sur MongoDB Atlas
2. **Network Access** → **Add IP Address**
3. Choisissez **"Allow from Anywhere"** (0.0.0.0/0)

### L'application ne démarre pas

**Solution** :
1. Consultez les logs sur ShinyApps.io
2. Vérifiez qu'aucun fichier obligatoire n'est manquant
3. Testez l'app localement avec `source("lancer_app.R")`

### Dépassement de quota gratuit

**Plans ShinyApps.io** :
- **Free** : 5 apps, 25h/mois, 5 connexions simultanées
- **Starter** : 9$/mois, 25 apps, 500h/mois, 10 connexions
- **Basic** : 39$/mois, 100 apps, illimité, 50 connexions

---

## 🔄 Mettre à jour l'application

Après avoir modifié votre code :

```r
# Redéployer
source("deployer_shinyapps.R")
```

Ou :

```r
rsconnect::deployApp(
  appFiles = c("app.R", "modules/ui_modules.R", ...),
  appName = "acceptia-study",
  forceUpdate = TRUE  # ← Écrase la version précédente
)
```

---

## 📊 Surveiller l'utilisation

Sur ShinyApps.io, vous pouvez voir :
- **Nombre de visiteurs** en temps réel
- **Temps d'utilisation** (heures)
- **Logs d'erreurs**
- **Métriques de performance**

---

## 🔒 Sécurité et confidentialité

### MongoDB
✅ Connection string dans le code (OK pour projet perso)
✅ Données stockées en EU (Frankfurt)
✅ SSL/TLS activé automatiquement

### ShinyApps.io
⚠️ Serveurs US par défaut
✅ HTTPS automatique
✅ Logs confidentiels

---

## ✅ Checklist finale

Avant de lancer la collecte de données :

- [ ] Application déployée sur ShinyApps.io
- [ ] Test complet du questionnaire
- [ ] MongoDB reçoit bien les données
- [ ] Script `telecharger_donnees.R` fonctionne
- [ ] URL de l'app partagée avec les participants
- [ ] Plan ShinyApps.io adapté (Standard 39$/mois pour 30 connexions)

---

## 📞 Aide

En cas de problème :
- **ShinyApps.io** : [https://docs.posit.co/shinyapps.io/](https://docs.posit.co/shinyapps.io/)
- **MongoDB Atlas** : [https://docs.atlas.mongodb.com/](https://docs.atlas.mongodb.com/)
- **Package mongolite** : [https://jeroen.github.io/mongolite/](https://jeroen.github.io/mongolite/)

---

**🎉 Vous êtes prêt à déployer !**

```r
source("deployer_shinyapps.R")
```
