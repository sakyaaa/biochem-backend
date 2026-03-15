# CLAUDE.md — biochem-backend

## Контекст
Rails 8.0.2 API-only приложение для ООО «Биохим» — научно-информационный портал по биомеханике и биохимии.

## Важные паттерны

- Все контроллеры в `app/controllers/api/` наследуются от `Api::BaseController`
- Аутентификация: `before_action :authenticate_user!` (Devise JWT), можно пропустить через `skip_before_action`
- Авторизация: `authorize @resource` в мутирующих actions (Pundit); политики в `app/policies/`
- Пагинация: `.page(params[:page]).per(N)` через Kaminari
- Поиск: `Article.search_fulltext(params[:q])` через pg_search (PostgreSQL, словарь `russian`)
- Сериализация: JSON-хэши вручную (без jsonapi-serializer на данный момент для простоты)

## ENV переменные (обязательные)
- `DATABASE_URL` — строка подключения к PostgreSQL
- `DEVISE_JWT_SECRET_KEY` — секретный ключ JWT (генерировать через `rails secret`)
- `FRONTEND_URL` — URL фронтенда для CORS (default: `http://localhost:4321`)

## Команды (всегда через docker-compose)
```bash
docker-compose -f docker-compose.yml -f docker-compose.override.development.yml exec backend КОМАНДА
# Примеры:
# bundle exec rails db:migrate
# bundle exec rails db:seed
# bundle exec rspec
# bundle exec rails console
```

## Запуск проекта
```bash
cp .env.example .env
# Заполнить .env
docker-compose -f docker-compose.yml -f docker-compose.override.development.yml up
docker-compose exec backend bundle exec rails db:create db:migrate db:seed
```
