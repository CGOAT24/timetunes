# Empêche R8 de supprimer des classes essentielles pour Spotify SDK et Jackson

-keep class com.fasterxml.jackson.databind.** { *; }
-dontwarn com.fasterxml.jackson.databind.**

-keep class com.spotify.** { *; }
-dontwarn com.spotify.**

# Pour les annotations utilisées par Spotify
-dontwarn com.spotify.base.annotations.**
-dontwarn javax.annotation.**
-dontwarn kotlin.Unit
