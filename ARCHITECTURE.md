# ARCHITECTURE.md — biochem-backend

## Стек
| Компонент | Версия | Назначение |
|---|---|---|
| Ruby | 3.4.7 | Язык программирования |
| Rails | 8.0.2 | API-фреймворк |
| PostgreSQL | 15 | СУБД |
| Devise | 4.9 | Аутентификация |
| devise-jwt | 0.11 | JWT-токены |
| Pundit | 2.4 | Авторизация (RBAC) |
| pg_search | 2.3 | Полнотекстовый поиск |
| Kaminari | 1.2 | Пагинация |
| RSpec | 7.1 | Тестирование |

## Структура директорий
```
app/
  controllers/api/           # API-контроллеры
    auth/                    # sessions, registrations (Devise)
    reports/                 # popular_controller.rb
    base_controller.rb       # общий BaseController (Pundit + rescue_from)
    articles_controller.rb   # GET/POST/PATCH/DELETE /api/articles
    sections_controller.rb   # GET /api/sections
    comments_controller.rb   # POST /api/articles/:id/comments
    bookmarks_controller.rb  # CRUD /api/bookmarks
    profiles_controller.rb   # GET/PUT /api/profile
  models/                    # AR-модели
  policies/                  # Pundit-политики (article, comment)
config/
  routes.rb                  # все маршруты в namespace :api
  database.yml               # PostgreSQL через DATABASE_URL
  initializers/
    devise.rb                # JWT dispatch/revocation config
    cors.rb                  # CORS для Astro frontend
db/
  migrate/                   # 10 миграций (порядок важен для FK)
  seeds.rb                   # разделы + admin-пользователь
spec/
  factories/                 # FactoryBot
  models/                    # model specs (user, article, section, comment, tag, bookmark, view_log)
nginx/
  nginx.conf                 # /api/* → backend:3000, /* → frontend:4321
```

## Схема БД (основные таблицы)
```
users: id, name, email, encrypted_password, role(enum), jti, timestamps
sections: id, name, description, slug, timestamps
articles: id, title, content, status(enum), author_id→users, section_id→sections, views_count, timestamps
tags: id, name
articles_tags: article_id, tag_id (join, no PK)
comments: id, user_id, article_id, body, approved, timestamps
bookmarks: id, user_id, article_id, timestamps
attachments: id, article_id, filename, content_type, byte_size, timestamps
view_logs: id, user_id(nullable), article_id, created_at
jwt_denylist: id, jti, exp
```

## API Endpoints
```
POST   /api/auth/sign_up    — регистрация
POST   /api/auth/sign_in    — вход (JWT устанавливается через Set-Cookie httpOnly)
DELETE /api/auth/sign_out   — выход (отзыв JWT)

GET    /api/articles        — список (params: q, section_id, page, per_page)
GET    /api/articles/:id    — статья
POST   /api/articles        — создать (editor/admin)
PATCH  /api/articles/:id    — редактировать (editor/admin или автор)
DELETE /api/articles/:id    — удалить (admin или автор)

GET    /api/articles/:id/comments  — комментарии
POST   /api/articles/:id/comments  — добавить комментарий

GET    /api/sections        — все разделы
GET    /api/sections/:id    — раздел по slug

GET    /api/bookmarks       — закладки текущего пользователя
POST   /api/bookmarks       — добавить закладку
DELETE /api/bookmarks/:id   — удалить закладку

GET    /api/profile         — профиль текущего пользователя
PATCH  /api/profile         — обновить профиль

GET    /api/reports/popular — топ статей по просмотрам
```

## Роли пользователей
- `guest` (0) — только чтение публичного контента (без аккаунта)
- `member` (1) — чтение + комментарии + закладки
- `editor` (2) — + создание/редактирование своих статей
- `admin` (3) — полный доступ

## Локализация
- `config/application.rb` — `default_locale = :ru`
- `config/locales/ru.yml` — Devise + ActiveRecord валидации + `errors.format: "%{message}"` (без префикса атрибута в full_messages)
- `config/locales/en.yml` — ActiveRecord валидации на английском
- `Api::BaseController#set_locale` — читает cookie `lang`, устанавливает `I18n.locale` per-request
- `SessionsController` наследует `Devise::SessionsController`, переопределяет `create`/`destroy` для JSON-ответов

## Команды запуска
```bash
# Разработка
docker compose -f docker-compose.yml -f docker-compose.override.development.yml up

# Production
docker compose -f docker-compose.yml -f docker-compose.override.production.yml up -d

# Миграции + seed
docker compose -f docker-compose.yml -f docker-compose.override.development.yml exec web bundle exec rails db:migrate
docker compose -f docker-compose.yml -f docker-compose.override.development.yml exec web bundle exec rails db:seed

# Тесты
docker compose -f docker-compose.yml -f docker-compose.override.development.yml exec web bundle exec rspec

# Rubocop
docker compose -f docker-compose.yml -f docker-compose.override.development.yml exec web bundle exec rubocop
```
