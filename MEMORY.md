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
