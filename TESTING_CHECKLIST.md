# Testing Checklist - Session Management Refactoring

## Pre-testing Setup

```bash
# 1. Clean and rebuild
flutter clean
flutter pub get
flutter pub upgrade

# 2. Run in debug mode
flutter run -v
```

## Unit Tests

### UserProvider Tests
```dart
// lib/providers/userProvider_test.dart

test('getCurrentUser returns null when not logged in', () {
  final provider = UserProvider();
  expect(provider.getCurrentUser(), isNull);
});

test('getDisplayName returns formatted name', () {
  final provider = UserProvider();
  provider._user = UserModel(
    nom: 'Dupont',
    prenom: 'Jean',
    email: 'jean@example.com',
    password: 'test',
  );
  expect(provider.getDisplayName(), equals('Jean Dupont'));
});

test('loadToken restores user from SharedPreferences', () async {
  // Setup: save user to prefs
  // Load via provider
  // Assert: user restored correctly
});

test('logout clears all data', () async {
  // Setup: provider with user
  // Call logout()
  // Assert: token null, user null, prefs cleared
});
```

## Integration Tests

### 1. Login Flow
- [ ] Launch app
- [ ] See login page
- [ ] Enter email and password
- [ ] Tap login button
- [ ] See loading spinner
- [ ] Success: redirected to `/accueil`
- [ ] Failure: show error snackbar
- [ ] Check: user data displayed in header
- [ ] Check: SharedPreferences contains token

**Commands:**
```bash
# Test login page loads
flutter run

# Test login with valid credentials
# Manually: type test@example.com / password123
```

### 2. Session Persistence
- [ ] Login successfully
- [ ] Kill app (Hot Reload ≠ Cold Start)
- [ ] Relaunch app
- [ ] Verify: redirects to `/accueil` (not login)
- [ ] Verify: user data displays immediately
- [ ] Verify: token still valid

**Commands:**
```bash
# Cold restart (not hot reload)
r  # Hot reload (should fail to show state is restored)
R  # Cold restart (app relaunches from main())
```

### 3. Profile Update
- [ ] Login
- [ ] Navigate to `/moncompte` (account page)
- [ ] Tap modify profile
- [ ] Change name/email
- [ ] Tap save
- [ ] Success: redirect to `/moncompte`
- [ ] Verify: profile updated in UI
- [ ] Kill and relaunch app
- [ ] Verify: changes persisted

**Test data:**
```
Name: Jean Dupont
Email: jean.dupont@example.com
```

### 4. Logout Flow
- [ ] Login successfully
- [ ] Navigate to `/moncompte`
- [ ] Tap logout button
- [ ] Verify: redirected to `/login`
- [ ] Verify: no user data in memory
- [ ] Verify: SharedPreferences cleared
- [ ] Try to access protected page (should redirect to login)

**Commands:**
```bash
# Watch logs for:
# ✓ Utilisateur déconnecté
# Check: no token in SharedPreferences
```

### 5. Auto-logout on 401
- [ ] Login successfully
- [ ] Manually invalidate token (uncomment code in api.dart)
- [ ] Make any API call
- [ ] Verify: 401 intercepted
- [ ] Verify: auto logout triggered
- [ ] Verify: redirect to `/login`
- [ ] Verify: snackbar shows "Token expiré"

### 6. Navigation Redirect Page
- [ ] Fresh install (clear app data)
- [ ] Launch app
- [ ] See loading spinner
- [ ] No token: redirect to `/onboarding` (first time) or `/login`
- [ ] With token: redirect to `/accueil`
- [ ] Kill app while on splash
- [ ] Relaunch: should resume correctly

## Edge Cases

### 7. Simultaneous Operations
- [ ] Start login
- [ ] Before completion, kill app
- [ ] Relaunch
- [ ] Verify: no partial state (either logged in or out)

### 8. Network Errors
- [ ] Enable airplane mode
- [ ] Try login
- [ ] Verify: error message displayed
- [ ] Fix network
- [ ] Retry login
- [ ] Should succeed

### 9. Invalid Token
- [ ] Manually delete token from SharedPreferences
- [ ] Launch app
- [ ] Verify: redirects to login

### 10. Corrupted Data
- [ ] Manually save invalid JSON to 'user' key in SharedPreferences
- [ ] Launch app
- [ ] Verify: graceful fallback (show login, no crash)

## Performance Tests

### 11. Memory Leaks
```bash
# Run with memory profiler
flutter run --profile
# Monitor memory in DevTools
# Do: login, navigate, logout, repeat 5x
# Verify: memory doesn't grow unbounded
```

### 12. Build Performance
```bash
flutter build apk --release
flutter build ios --release
# Both should succeed without errors
```

## Manual Testing Checklist

- [ ] Login page loads
- [ ] Can enter email/password
- [ ] Login button shows loading state
- [ ] Successful login shows user name in header
- [ ] Failed login shows error
- [ ] Can modify profile
- [ ] Profile changes persist after restart
- [ ] Logout works
- [ ] Cannot access protected pages without login
- [ ] 401 triggers auto-logout
- [ ] All user info displayed correctly (name, email)
- [ ] Navigation between pages works
- [ ] Bottom navbar shows correctly

## Debugging Commands

```bash
# View all SharedPreferences
# In app: add debugging page or use shared_preferences inspector

# Watch logs for session messages
flutter logs | grep -E "✓|✗|Utilisateur"

# Check provider state
# In DevTools: Provider inspector

# Monitor token
# In SharedPreferences inspector: watch 'auth_token' key
```

## Success Criteria

✅ All tests pass
✅ No crashes when:
  - Logging in/out
  - Network errors
  - App killed during operations
  - Invalid data in storage
✅ User data persists correctly
✅ 401 auto-logout works
✅ No memory leaks
✅ Performance acceptable

## Regression Testing

Compare with previous version:
- [ ] Same login/logout functionality
- [ ] Same navigation behavior
- [ ] Same error messages
- [ ] Same performance
- [ ] No new crashes

## Sign-Off

Tested by: _____________
Date: _____________
Result: ✅ PASS / ❌ FAIL
