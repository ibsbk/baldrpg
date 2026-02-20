## CI/CD: GitHub Pages (Flutter Web через FVM)

В репозитории настроен деплой на GitHub Pages через GitHub Actions с использованием **FVM**.

- **Flutter version**: `3.38.3` (см. `.fvm/fvm_config.json`)
- **Workflow**: `.github/workflows/deploy-gh-pages.yml`

### Как включить Pages

1. В GitHub откройте **Settings → Pages**.
2. В **Build and deployment** выберите **Source: GitHub Actions**.
3. Запушьте в `main` (или `master`) — workflow соберёт `flutter build web` и задеплоит Pages.

### Локальная сборка web (через FVM)

```bash
fvm install
fvm flutter pub get
fvm flutter build web --release --base-href "/<repo>/"
```