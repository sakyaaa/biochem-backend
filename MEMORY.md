# MEMORY.md — biochem-backend

## 2026-03-15 — Инициализация проекта

Создана начальная структура Rails 8 API-проекта.

### Созданные файлы
- `Gemfile` (Rails 8, Devise+JWT, Pundit, pg_search, Kaminari)
- `Dockerfile`, `docker-compose.yml`, `docker-compose.override.development.yml`, `docker-compose.override.production.yml`
- `nginx/nginx.conf`
- `config/application.rb`, `config/boot.rb`, `config/environment.rb`, `config/routes.rb`, `config/database.yml`, `config/puma.rb`
- `config/initializers/cors.rb`, `config/initializers/devise.rb`
- `db/migrate/` — 10 миграций: sections → users → articles → tags → articles_tags → comments → bookmarks → attachments → view_logs → jwt_denylist
- `db/seeds.rb`
- `app/models/` — User, Article, Section, Tag, Comment, Bookmark, Attachment, ViewLog, JwtDenylist, ApplicationRecord
- `app/controllers/application_controller.rb`
- `app/controllers/api/` — base_controller, articles, sections, comments, bookmarks, profiles
- `app/controllers/api/auth/` — sessions, registrations
- `app/controllers/api/reports/` — popular
- `app/policies/` — application_policy, article_policy, comment_policy
- `spec/rails_helper.rb`, `spec/spec_helper.rb`
- `spec/factories/` — users, articles, sections
- `spec/models/article_spec.rb`
- `CLAUDE.md`, `MEMORY.md`, `ARCHITECTURE.md`
- `.env.example`, `.gitignore`

## 2026-03-15-16 — Деплой и фиксы

### Переименование backend → web
- `docker-compose.yml`, `docker-compose.override.development.yml`, `docker-compose.override.production.yml` — сервис `backend` переименован в `web`
- `nginx/nginx.conf` — upstream переименован с `backend` в `web`

### Фиксы безопасности
- JWT токен перемещён из localStorage в httpOnly cookie
- `config/environments/production.rb` — `force_ssl = true`
- `config/initializers/cors.rb` — добавлен `credentials: true`
- `app/controllers/api/base_controller.rb` — `inject_jwt_from_cookie` перед `authenticate_user!`
- `app/controllers/api/auth/sessions_controller.rb` — логика установки cookie при логине

### Инфраструктура
- `app/middleware/jwt_cookie_middleware.rb` — Rack middleware: JWT из Authorization заголовка → httpOnly cookie
- `lib/jwt_cookie_railtie.rb` — Railtie для вставки middleware перед `Warden::JWTAuth::Middleware`
- `config/application.rb` — подключение Railtie; `ActionDispatch::Cookies` middleware добавлен
- `docker-compose.override.development.yml` — добавлен `RAILS_LOG_TO_STDOUT: "true"`

### API fixes
- `app/controllers/api/base_controller.rb` — добавлены `current_user` и `authenticate_user!` через Warden (API mode)
- `app/controllers/api/tags_controller.rb` — создан (недоставал, роут был зарегистрирован)
- `config/routes.rb` — роут `namespace :reports` исправлен на `get "reports/popular", to: "reports/popular#popular"`
- `app/controllers/api/articles_controller.rb` — `ViewLog.create` через `current_user` (nullable)

### Данные
- `db/seeds.rb` — расширен: 3 пользователя (admin/editor/member), 10 тегов, 9 статей (8 published + 1 draft), 6 комментариев, 2 закладки

## 2026-03-16 — Тестовое покрытие + баг-фиксы

### Новые файлы тестов
- `spec/factories/comments.rb`, `tags.rb`, `bookmarks.rb`, `view_logs.rb`
- `spec/support/auth_helpers.rb`, `spec/support/request_helpers.rb`, `spec/support/database_extensions.rb`
- `spec/models/user_spec.rb`, `section_spec.rb`, `comment_spec.rb`, `tag_spec.rb`, `bookmark_spec.rb`
- `spec/models/article_spec.rb` — дополнен scopes, search_fulltext, habtm tags
- `spec/policies/article_policy_spec.rb`, `comment_policy_spec.rb`
- `spec/requests/api/articles_spec.rb`, `comments_spec.rb`, `sections_spec.rb`, `tags_spec.rb`, `bookmarks_spec.rb`, `profiles_spec.rb`
- `spec/requests/api/reports/popular_spec.rb`
- `spec/requests/api/auth/sessions_spec.rb`, `registrations_spec.rb`

### Исправленные баги в приложении
- `app/controllers/api/base_controller.rb` — scope `:user` → `:api_user` (Devise mapping в namespace создаёт `api_user`, не `user`)
- `app/controllers/api/auth/sessions_controller.rb` — `warden.user(:user)` → `:api_user`; добавлен `include ActionController::Cookies`
- `app/controllers/api/auth/registrations_controller.rb` — добавлен `configure_permitted_parameters` для поля `:name`
- `app/controllers/api/reports/popular_controller.rb` — добавлен `return if performed?` после `parse_date` (fix double render)
- `config/initializers/devise.rb` — `config.navigational_formats = []` (API-only без flash); `config.warden { store: false }` (без session storage)

### Важно для тестов
- Параметр входа: `api_user: { email:, password: }` (не `user:`) — из-за namespace scope
- Request specs используют `sign_in user` (`Devise::Test::IntegrationHelpers`) вместо HTTP sign_in
- Итог: 105 RSpec примеров, 0 failures
