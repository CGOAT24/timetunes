# 🎵 TimeTunes

**TimeTunes** est une application mobile multijoueur où les joueurs doivent deviner la date de sortie de chansons en les plaçant correctement sur une ligne du temps. Inspirée du jeu de cartes HITSTER, TimeTunes va plus loin en ajoutant la personnalisation, le jeu à distance et l'intégration de Spotify.

---

## 🚀 Fonctionnalités principales

- 🎧 Devinez la date de sortie de chansons en les plaçant sur une timeline.
- 🧠 Testez votre mémoire musicale seul ou entre amis.
- 📱 Jouez en multijoueur à distance, chacun sur son appareil.
- 🔍 Choisissez des playlists personnalisées depuis n’importe quelle playlist Spotify publique.
- 🔄 Les musiques sont jouées directement dans l'app via l'intégration Spotify SDK.
- 📊 Classement en temps réel et podium en fin de partie.
- ⚙️ Paramètres personnalisables (URL serveur, port, etc.)

---

## 📦 Installation & Lancement

### 1. Prérequis

- Flutter SDK
- Compte Spotify développeur
- Android Studio (pour tests)
- Un serveur TimeTunes

### 2. Configuration

Crée un fichier `.env` :

```env
SPOTIFY_CLIENT_ID=your_spotify_client_id
AMQ_USERNAME=guest
AMQ_PASSWORD=guest
```
### 3. Démarrage
```
# Installation des packages
flutter pub get

# Lancement en mode debug
flutter run
```
