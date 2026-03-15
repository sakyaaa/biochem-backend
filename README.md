# Биохим — Backend API

REST API для научно-информационного портала по биомеханике и биохимии человеческого организма, разработанного для ООО «Биохим».

## Стек

- **Ruby 3.4.7 / Rails 8.0.2** (API mode)
- **PostgreSQL 15** — основная СУБД с полнотекстовым поиском (tsvector + GIN-индексы)
- **Devise + devise-jwt** — аутентификация через JWT
- **Pundit** — авторизация на основе ролей (RBAC)
- **pg_search** — полнотекстовый поиск по русскому словарю
- **Kaminari** — пагинация
- **RSpec + FactoryBot** — тестирование

## Быстрый старт

```bash
# 1. Клонировать оба репозитория рядом
git clone https://github.com/sakyaaa/biochem-backend
git clone https://github.com/sakyaaa/biochem-frontend

# 2. Настроить переменные окружения
cd biochem-backend
cp .env.example .env
# Обязательно заполнить DEVISE_JWT_SECRET_KEY (rails secret)

# 3. Запустить контейнеры
docker-compose -f docker-compose.yml -f docker-compose.override.development.yml up

# 4. Инициализировать БД (в отдельном терминале)
docker-compose exec backend bundle exec rails db:create db:migrate db:seed
```

Сервер будет доступен на `http://localhost:3000`.

## API

Все эндпоинты находятся под префиксом `/api`.

### Аутентификация

| Метод | Путь | Описание |
|-------|------|----------|
| `POST` | `/api/auth/sign_up` | Регистрация |
| `POST` | `/api/auth/sign_in` | Вход (возвращает JWT в заголовке `Authorization`) |
| `DELETE` | `/api/auth/sign_out` | Выход (отзыв токена) |

### Материалы

| Метод | Путь | Описание | Роль |
|-------|------|----------|------|
| `GET` | `/api/articles` | Список публикаций (`?q=запрос`, `?section_id=`, `?page=`) | Публичный |
| `GET` | `/api/articles/:id` | Полный текст статьи | Публичный |
| `POST` | `/api/articles` | Создать материал | editor / admin |
| `PATCH` | `/api/articles/:id` | Редактировать | editor / admin |
| `DELETE` | `/api/articles/:id` | Удалить | admin |

### Разделы и комментарии

| Метод | Путь | Описание |
|-------|------|----------|
| `GET` | `/api/sections` | Список разделов |
| `GET` | `/api/articles/:id/comments` | Комментарии к статье |
| `POST` | `/api/articles/:id/comments` | Добавить комментарий (требует авторизации) |

### Прочее

| Метод | Путь | Описание |
|-------|------|----------|
| `GET` | `/api/bookmarks` | Закладки текущего пользователя |
| `GET` | `/api/profile` | Профиль текущего пользователя |
| `GET` | `/api/reports/popular` | Топ статей по просмотрам (`?from=&to=`) |

### Пример запроса

```bash
# Получить список статей с поиском
curl http://localhost:3000/api/articles?q=синтез+АТФ

# Войти и получить токен
curl -X POST http://localhost:3000/api/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "admin@biochem.ru", "password": "Biochem2026!"}}'
```

## Роли пользователей

| Роль | Чтение | Комментарии | Публикация | Управление |
|------|--------|-------------|------------|------------|
| `guest` | ✅ | — | — | — |
| `member` | ✅ | ✅ | — | — |
| `editor` | ✅ | ✅ | ✅ | своих статей |
| `admin` | ✅ | ✅ | ✅ | полное |

## База данных

Схема включает 10 таблиц: `users`, `articles`, `sections`, `tags`, `articles_tags`, `comments`, `bookmarks`, `attachments`, `view_logs`, `jwt_denylist`.

```bash
# Применить миграции
docker-compose exec backend bundle exec rails db:migrate

# Заполнить начальными данными (разделы + admin)
docker-compose exec backend bundle exec rails db:seed
```

## Тесты

```bash
docker-compose exec backend bundle exec rspec
```

## Переменные окружения

| Переменная | Обязательно | Описание |
|------------|-------------|----------|
| `DATABASE_URL` | ✅ | Строка подключения PostgreSQL |
| `DEVISE_JWT_SECRET_KEY` | ✅ | Секрет для подписи JWT (`rails secret`) |
| `FRONTEND_URL` | — | URL фронтенда для CORS (default: `http://localhost:4321`) |
| `RAILS_ENV` | — | Среда Rails (default: `development`) |

## Связанные репозитории

- [biochem-frontend](https://github.com/sakyaaa/biochem-frontend) — Astro SSR frontend
