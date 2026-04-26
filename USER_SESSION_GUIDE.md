# Guide Gestion de Session Utilisateur

## Vue d'ensemble

La gestion de la session utilisateur a été refactorisée pour utiliser **Provider** plutôt qu'une variable statique. Cela assure une meilleure synchronisation et une gestion d'état plus prévisible.

## Architecture

### UserProvider
Le `UserProvider` est la **source unique de vérité** pour l'état utilisateur. Il gère :
- Token d'authentification
- Données utilisateur
- État de chargement
- Messages et erreurs

**Fichier:** `lib/providers/userProvider.dart`

### UserModel
Modèle de données pour représenter un utilisateur.
- Pas de variable statique `sessionUser` (supprimée)
- Stockage persistant via SharedPreferences
- Sérialisation JSON

**Fichier:** `lib/models/user_model.dart`

## Utilisation

### Récupérer l'utilisateur connecté

**Dans les widgets (build):**
```dart
final userProvider = context.watch<UserProvider>();
final user = userProvider.user;
final name = userProvider.getDisplayName();
```

**En dehors du build (comme initState):**
```dart
final userProvider = context.read<UserProvider>();
final user = userProvider.user;
```

### Vérifier si l'utilisateur est connecté

```dart
if (userProvider.isLoggedIn) {
  // Utilisateur connecté
}
```

### Connexion

```dart
try {
  await context.read<UserProvider>().login(email, password);
  // Redirection automatique via router
  context.go('/accueil');
} catch (e) {
  showError('Erreur: $e');
}
```

### Mise à jour du profil

```dart
try {
  await context.read<UserProvider>().updateProfile(
    nom: 'Dupont',
    prenom: 'Jean',
    email: 'jean@example.com',
  );
  // Le state est automatiquement synchronisé
} catch (e) {
  showError('Erreur: $e');
}
```

### Déconnexion

```dart
await context.read<UserProvider>().logout();
context.go('/login');
```

## API UserProvider

### Getters
- `isLoading` - En cours de chargement ?
- `token` - Token d'authentification
- `isLoggedIn` - Utilisateur connecté ?
- `user` - Données utilisateur (UserModel?)
- `message` - Message de succès
- `error` - Message d'erreur

### Méthodes
- `getCurrentUser()` → `UserModel?` - Récupère l'utilisateur
- `getDisplayName()` → `String` - Retourne "Prénom Nom"
- `login(email, password)` - Connexion
- `loginWithGoogle()` - Connexion Google
- `modifyPassword(email)` - Modification de mot de passe
- `updateProfile(nom, prenom, email)` - Mise à jour profil
- `loadToken()` - Charge le token au démarrage (appelé dans main())
- `logout()` - Déconnexion complète

## Flux d'authentification

```
1. App startup
   ↓
2. main() → userProvider.loadToken()
   ↓
3. RedirectPage vérifie isLoggedIn
   ↓
4. Si connecté → /accueil
   Si déconnecté → /login
   ↓
5. Login → userProvider.login()
   ↓
6. Token + User sauvegardés
   ↓
7. notifyListeners() → UI mise à jour
```

## Stockage des données

**Token:**
- SharedPreferences, clé: `auth_token`

**Utilisateur:**
- SharedPreferences, clé: `user` (JSON encodé)

## Fichiers migrés

Les fichiers suivants ont été convertis de `UserModel.sessionUser` vers `context.watch<UserProvider>()`:

1. ✅ `lib/screen/pages/wellcommePage.dart`
2. ✅ `lib/screen/pages/monComptePage.dart`
3. ✅ `lib/screen/pages/profil/detail_compte.dart`
4. ✅ `lib/widgets/naveBar.dart`
5. ✅ `lib/widgets/bottom_nav.dart`
6. ✅ `lib/widgets/dashboard.dart`

## Bonnes pratiques

### ✅ À faire
- Utiliser `context.watch<UserProvider>()` dans `build()`
- Utiliser `context.read<UserProvider>()` dans les callbacks et initState
- Afficher `userProvider.isLoading` pendant les opérations
- Afficher `userProvider.error` en cas d'erreur
- Toujours appeler `logout()` avant de rediriger vers `/login`

### ❌ À éviter
- Accéder directement à `UserModel.sessionUser` (supprimé)
- Créer plusieurs instances de UserProvider
- Modifier directement `user` (utiliser les méthodes du Provider)
- Oublier `if (context.mounted)` avant `context.go()`

## Tests

Pour tester la gestion de session :

```dart
// Simuler une connexion
final userProvider = UserProvider();
await userProvider.login('test@example.com', 'password');
expect(userProvider.isLoggedIn, true);

// Simuler une déconnexion
await userProvider.logout();
expect(userProvider.isLoggedIn, false);
expect(userProvider.user, isNull);
```

## Debugging

Pour activer les logs de session :

```dart
// Dans UserProvider
print('✓ Utilisateur chargé: ${_user?.prenom} ${_user?.nom}');
print('✓ Utilisateur déconnecté');
print('✗ Pas de token trouvé');
```

Activez le mode debug dans VS Code pour voir les print statements.
