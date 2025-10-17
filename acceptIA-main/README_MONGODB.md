# 🗄️ Configuration MongoDB pour acceptIA

## ✅ MongoDB est maintenant configuré !

Vos données de participants seront automatiquement sauvegardées dans **MongoDB Atlas** (cloud gratuit, serveur Frankfurt).

---

## 📊 Comment récupérer vos données

### Option 1 : Script R automatique (RECOMMANDÉ)

```r
# Lancer ce script depuis R ou RStudio
source("telecharger_donnees.R")
```

Cela créera 3 fichiers :
- `donnees_acceptia_YYYYMMDD_HHMMSS.csv` (pour Excel, SPSS, etc.)
- `donnees_acceptia_YYYYMMDD_HHMMSS.xlsx` (Excel)
- `donnees_acceptia_YYYYMMDD_HHMMSS.RData` (pour R)

### Option 2 : Depuis l'interface MongoDB Atlas

1. Allez sur [https://cloud.mongodb.com](https://cloud.mongodb.com)
2. Connectez-vous avec votre compte
3. Cliquez sur **"Browse Collections"**
4. Naviguez vers : `acceptia_study` → `participants`
5. Cliquez sur **"Export Collection"** → Choisir CSV ou JSON

### Option 3 : Manuellement dans R

```r
library(mongolite)

# Se connecter
participants <- mongo(
  collection = "participants",
  db = "acceptia_study",
  url = "mongodb+srv://vuillaumeanthony_db_user:y4IRDyem6180yh7I@cluster0.zaf44u9.mongodb.net/"
)

# Télécharger toutes les données
mes_donnees <- participants$find('{}')

# Sauvegarder
write.csv(mes_donnees, "mes_donnees.csv", row.names = FALSE)
```

---

## 🧪 Tester la connexion MongoDB

Avant de lancer l'application, testez que MongoDB fonctionne :

```r
# Lancer le script de test
source("test_mongodb.R")
```

Vous devriez voir :
```
✓ Connexion réussie !
✓ Participant de test inséré !
✓ MongoDB est prêt à être utilisé !
```

---

## 🚀 Déploiement sur ShinyApps.io

### Fichiers à uploader :

Quand vous déployez sur ShinyApps.io, uploadez ces fichiers :

```
app.R
modules/
  ├── ui_modules.R
  ├── ui_modules_suite.R
  ├── server_modules.R
  └── data_functions.R
```

**⚠️ NE PAS uploader** :
- `test_mongodb.R`
- `telecharger_donnees.R`
- `data/` (sera créé automatiquement)

### Pas de configuration supplémentaire nécessaire !

La connection string est déjà dans le code, MongoDB fonctionnera automatiquement sur ShinyApps.io.

---

## 📈 Avantages de MongoDB

✅ **Gratuit** jusqu'à 512 MB (≈ 50 000 participants)  
✅ **Connexions simultanées** : 100+ utilisateurs en même temps  
✅ **Données permanentes** : Ne disparaissent jamais  
✅ **Serveur EU** : Frankfurt (conforme RGPD)  
✅ **Accessible partout** : Depuis R, web, Python, etc.  
✅ **Sauvegardes automatiques** : MongoDB fait des backups  

---

## 🔍 Statistiques en temps réel

Pour voir combien de participants ont répondu :

```r
library(mongolite)

participants <- mongo(
  collection = "participants",
  db = "acceptia_study",
  url = "mongodb+srv://vuillaumeanthony_db_user:y4IRDyem6180yh7I@cluster0.zaf44u9.mongodb.net/"
)

# Nombre total
participants$count('{}')

# Participants aujourd'hui
today <- format(Sys.Date(), "%Y-%m-%d")
participants$count(sprintf('{"timestamp": {"$regex": "^%s"}}', today))
```

---

## ⚠️ Important

### Sécurité
- La connection string contient votre mot de passe
- Ne la partagez pas publiquement
- Pour un projet professionnel, utilisez des variables d'environnement

### Limitation du plan gratuit
- 512 MB de stockage
- ~100 connexions simultanées
- Largement suffisant pour votre étude !

---

## 🆘 En cas de problème

### Erreur "Authentication failed"
→ Vérifiez que le mot de passe dans la connection string est correct

### Erreur "IP not authorized"
→ Sur MongoDB Atlas : **Network Access** → **Add IP Address** → **Allow from Anywhere** (0.0.0.0/0)

### Erreur "Database not found"
→ Normal au début ! La base sera créée automatiquement au premier participant

### Package mongolite ne s'installe pas
```r
# Sur Windows, installer Rtools puis :
install.packages("mongolite", type = "binary")
```

---

## 📞 Support

Pour toute question MongoDB :
- Documentation : [https://jeroen.github.io/mongolite/](https://jeroen.github.io/mongolite/)
- MongoDB Atlas : [https://docs.atlas.mongodb.com/](https://docs.atlas.mongodb.com/)

---

**✓ Tout est prêt ! Vous pouvez maintenant lancer votre application avec `source("lancer_app.R")` ou la déployer sur ShinyApps.io.**
