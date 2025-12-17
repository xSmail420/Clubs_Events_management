# 🎓 UNICLUBS - Application de Gestion des Clubs (JavaFX)

## 📑 Table des Matières
- [Description](#description)
- [Fonctionnalités Principales](#fonctionnalités-principales)
  - [Gestion des Utilisateurs](#gestion-des-utilisateurs)
  - [Gestion des Clubs](#gestion-des-clubs)
  - [Sondages et Intelligence Artificielle](#sondages-et-intelligence-artificielle)
  - [Événements](#événements)
  - [Compétitions](#compétitions)
  - [Gestion des Produits](#gestion-des-produits)
- [Technologies Utilisées](#technologies-utilisées)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Utilisation](#utilisation)

## 📝 Description
UNICLUBS est une application de bureau développée en JavaFX qui permet la gestion complète des clubs, événements, sondages et compétitions au sein de l'école ITBS.

### 🎯 Objectif
Faciliter et centraliser la gestion des activités parascolaires au sein de l'école ITBS en offrant une plateforme intuitive et complète.

### 🔍 Problème Résolu
- Fragmentation des outils de gestion des clubs
- Manque de centralisation des informations
- Difficulté de communication entre les clubs
- Complexité dans l'organisation des événements

## 🚀 Fonctionnalités Principales

### 👥 Gestion des Utilisateurs
- 🔐 Système d'authentification sécurisé
- 👤 Gestion des profils utilisateurs avec interface administrateur complète
- 🎭 Différents rôles (Administrateur, Président de Club, Membre, Non-Membre)
- ✉ Système de vérification par email
- 🔍 Système de filtration avancé pour les utilisateurs (par rôle, statut, vérification)
- 📊 Statistiques en temps réel sur les utilisateurs (total, actifs, non-vérifiés)
- 🚫 Modération des utilisateurs (activation/désactivation, suppression)
- 🛡 Détection de contenu inapproprié avec système d'avertissement
- 📈 Tableau de bord analytique pour suivre les tendances d'inscription

### 🏢 Gestion des Clubs
- 📋 Création et gestion des clubs
- 👥 Gestion des membres
- 📊 Tableau de bord pour les présidents de clubs
- 📅 Planification des activités

### 📊 Sondages et Intelligence Artificielle
- 📝 Création et gestion des sondages
- 🤖 Fonctionnalités IA avancées :
  - 🛡 Détection automatique des commentaires toxiques
  - 🌐 Traduction automatique des commentaires
  - 📊 Analyse des sentiments dans les commentaires
  - 📑 Génération automatique de résumés des commentaires
  - 🚫 Système de modération intelligent (ban automatique)
- 📈 Statistiques avancées :
  - 📊 Analyse des sentiments en temps réel
  - 📉 Tableaux de bord IA pour administrateurs
  - 📈 Visualisation des tendances utilisateur
- 💬 Système de commentaires intelligent
- 📈 Statistiques en temps réel

### 🎉 Événements
- 📅 Création et gestion d'événements
- 🎫 Système de participation
- 📍 Localisation des événements
- 📸 Gestion des médias

### 🏆 Compétitions
- 🎮 Organisation de compétitions
- 🏅 Système de classement
- 🎯 Suivi des scores
- 🏆 Gestion des récompenses

### 🛍 Gestion des Produits
- 📦 Ajout et gestion des produits
- 💰 Gestion des prix et des stocks
- 🏷 Catégorisation des produits
- 🛒 Système de commande
- 📊 Suivi des ventes

## 🛠 Technologies Utilisées
- ☕ Java 17
- 🎨 JavaFX
- 🗃 MySQL
- 🔄 Hibernate
- 📧 JavaMail API
- 🎨 CSS pour le styling
- 📊 JFoenix pour les composants UI modernes
- 🤖 Intégration IA :
  - 🧠 OpenAI API pour l'analyse de texte et la génération de résumés
  - 🔍 Hugging Face pour la détection de toxicité et l'analyse des sentiments
  - 🌐 APIs de traduction avancée

## 📋 Prérequis
- ☕ Java Development Kit (JDK) 17 ou supérieur
- 🗃 MySQL Server
- 📦 Maven

## ⚙ Installation

1. *Cloner le repository*
bash
git clone ...
cd itbs-club-hub


2. *Configurer la base de données*
bash
# Créer la base de données
mysql -u root -p
CREATE DATABASE dbpi;

# Importer le script SQL
mysql -u root -p dbpi < database.sql


3. **Configurer le fichier config.properties**
properties
db.url=jdbc:mysql://localhost:3306/itbs_club_hub
db.username=votre_username
db.password=votre_password


4. *Compiler et exécuter le projet*
bash
mvn clean install
mvn javafx:run


## 📖 Utilisation

### Configuration Initiale
1. Lancer l'application
2. Se connecter avec les identifiants administrateur par défaut :
   - Email : admin@test.com
   - Mot de passe : P@ssw0rd

### Fonctionnalités Principales
- *Gestion des Clubs* : Créer, modifier et gérer les clubs
- *Événements* : Organiser et participer aux événements
- *Sondages et IA* : 
  - Créer et répondre aux sondages
  - Modération automatique des commentaires
  - Analyse des sentiments
  - Génération de résumés
  - Traduction automatique
- *Compétitions* : Gérer les compétitions et suivre les scores
- *Produits* : Gérer le catalogue des produits, les stocks et les commandes
