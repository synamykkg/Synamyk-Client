# synamyk

Приложение для подготовки сдачи экзамена ОРТ.

## 📋 Требования

- Flutter SDK (версия управляется через FVM, см. ниже)
- Dart SDK (входит в состав Flutter)
- Git
- Android Studio / Xcode (для сборки под соответствующие платформы)
- VS Code или Android Studio с плагином Flutter (рекомендуется)

## 🚀 Установка FVM

[FVM (Flutter Version Management)](https://fvm.app/) используется для управления версиями Flutter в проекте.

### Проверка установки

```bash
fvm --version
```

## 🐦 Установка Flutter через FVM

1. Установите нужную версию Flutter:

```bash
fvm install
```

Если версия ещё не зафиксирована в проекте, установите конкретную версию и закрепите её:

```bash
fvm install <версия_flutter>
fvm use <версия_flutter>
```

2. Проверьте, что всё работает:

```bash
fvm flutter --version
fvm flutter doctor
```

> 💡 Рекомендуется использовать `fvm flutter` и `fvm dart` вместо глобальных команд `flutter`/`dart`, чтобы гарантировать использование правильной версии SDK для проекта.

## 🔑 Настройка `.env`

Проект использует файл `.env` для хранения переменных окружения (API-ключи, базовые URL и т.д.).

1. Скопируйте пример файла:

```bash
cp .env.example .env
```

2. Заполните значения переменных в `.env`:

```env
BASE_URL=https://api.example.com
```

> ⚠️ Файл `.env` не должен попадать в систему контроля версий — убедитесь, что он указан в `.gitignore`.

## 📦 Установка зависимостей

```bash
fvm flutter pub get
```

## ⚙️ Генерация кода (Build Runner)

Если в проекте используются генераторы кода (freezed, json_serializable, injectable и т.д.), необходимо запустить `build_runner`.

### Разовая генерация

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Генерация в режиме наблюдения (автогенерация при изменении файлов)

```bash
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

## ▶️ Запуск приложения

### Проверка доступных устройств

```bash
fvm flutter devices
```

### Запуск в режиме отладки

```bash
fvm flutter run
```

### Запуск на конкретном устройстве

```bash
fvm flutter run -d <device_id>
```

## 🏗️ Сборка релизной версии

### Android (APK)

```bash
fvm flutter build apk --release
```

