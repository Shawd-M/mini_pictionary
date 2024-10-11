# Pictionary en Flutter

## Description

Ce projet est un jeu de **Pictionary** développé en **Flutter**, permettant à plusieurs utilisateurs de se connecter, de créer et rejoindre des parties en ligne. Le jeu utilise **Firebase** pour la gestion des utilisateurs, l'authentification, le chat en temps réel et la synchronisation de la zone de dessin entre les participants.

## Fonctionnalités

### 1. Gestion des Utilisateurs
- **Création de compte utilisateur** : Les utilisateurs peuvent créer un compte avec un **mot de passe**.
- **Gestion de compte** : Les utilisateurs peuvent mettre à jour leurs informations ou supprimer leur compte.

### 2. Gestion des Parties
- **Création de partie** : Un utilisateur peut créer une nouvelle partie avec un mot de passe.
- **Rejoindre une partie** : Les autres utilisateurs peuvent rejoindre une partie en fournissant le mot de passe correct.
- **Authentification** : L'authentification est nécessaire pour accéder aux parties (via mot de passe).

### 3. Chat en Temps Réel
- Chaque partie dispose d'un **chat écrit** qui est visible en temps réel par tous les participants grâce à l'intégration de **Firebase**.
- La zone de chat se met à jour en temps réel pour tous les utilisateurs.

### 4. Zone de Dessin en Temps Réel
- Le joueur en train de dessiner peut interagir avec la **zone de dessin**, et cette zone est mise à jour en temps réel sur les terminaux de tous les autres joueurs.
- La synchronisation est assurée via Firebase pour garantir une expérience fluide.

### 5. Multijoueur
- Plusieurs participants peuvent rejoindre une même partie depuis différents terminaux.
- Chaque joueur peut interagir avec le jeu simultanément, que ce soit pour dessiner ou pour utiliser le chat.

## Technologies Utilisées

### Frontend
- **Flutter** : Utilisé pour le développement de l'interface utilisateur et l'animation du jeu.
  
### Backend et Services
- **Firebase Authentication** : Pour la gestion des comptes utilisateurs et l'authentification.
- **Firebase Firestore** : Utilisé pour stocker les données en temps réel, notamment pour le chat et les informations de la partie.
- **Firebase Realtime Database** : Synchronisation de la zone de dessin en temps réel.
  
### Autres
- **Dart** : Langage utilisé pour le développement Flutter.

## Prérequis

- **Flutter SDK** : Installé sur votre machine.
- **Firebase** : Un compte Firebase et un projet configuré (Firestore, Realtime Database, et Authentication doivent être activés).
- **Android Studio** ou **Visual Studio Code** pour le développement Flutter.

