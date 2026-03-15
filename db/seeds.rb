# Разделы
sections = [
  { name: "Биомеханика",         slug: "biomechanics",   description: "Биомеханика опорно-двигательного аппарата и физиологии движений" },
  { name: "Биохимия",            slug: "biochemistry",   description: "Биохимия метаболических процессов" },
  { name: "Метаболизм",          slug: "metabolism",     description: "Метаболизм углеводов, белков и жиров" },
  { name: "Физиология движений", slug: "physiology",     description: "Физиология мышечной деятельности" },
  { name: "Спортивная медицина", slug: "sport-medicine", description: "Спортивная медицина и реабилитация" }
]

sections.each { |s| Section.find_or_initialize_by(slug: s[:slug]).update!(s) }
puts "Создано #{Section.count} разделов"

# Пользователи
admin = User.find_or_create_by!(email: "admin@biochem.ru") do |u|
  u.name     = "Администратор"
  u.password = "Biochem2026!"
  u.role     = :admin
  u.jti      = SecureRandom.uuid
end
puts "Администратор: #{admin.email}"

editor = User.find_or_create_by!(email: "editor@biochem.ru") do |u|
  u.name     = "Иванов Сергей"
  u.password = "Biochem2026!"
  u.role     = :editor
  u.jti      = SecureRandom.uuid
end
puts "Редактор: #{editor.email}"

member = User.find_or_create_by!(email: "user@biochem.ru") do |u|
  u.name     = "Петрова Анна"
  u.password = "Biochem2026!"
  u.role     = :member
  u.jti      = SecureRandom.uuid
end
puts "Пользователь: #{member.email}"

# Теги
tag_names = ["АТФ", "мышцы", "метаболизм", "биомеханика", "суставы", "реабилитация", "аэробный", "анаэробный", "гормоны", "питание"]
tags = tag_names.map { |name| Tag.find_or_create_by!(name: name) }
puts "Создано #{Tag.count} тегов"

# Статьи
biomechanics  = Section.find_by!(slug: "biomechanics")
biochemistry  = Section.find_by!(slug: "biochemistry")
metabolism    = Section.find_by!(slug: "metabolism")
physiology    = Section.find_by!(slug: "physiology")
sport_med     = Section.find_by!(slug: "sport-medicine")

articles_data = [
  {
    title:   "Биомеханика коленного сустава при беге",
    content: "Коленный сустав — один из наиболее нагруженных суставов при беге. В процессе бега на колено приходятся нагрузки, превышающие вес тела в 3–5 раз.\n\nОсновные фазы нагрузки:\n- Фаза опоры: максимальная компрессия (2–4 кг/кг массы тела)\n- Фаза переноса: растяжение связок\n- Фаза отталкивания: нагрузка на сухожилие надколенника\n\nПравильная техника бега позволяет равномерно распределять нагрузку и снижать риск травм.",
    section: biomechanics, author: editor, status: :published, views_count: 142,
    tags: [tags.find { |t| t.name == "биомеханика" }, tags.find { |t| t.name == "суставы" }]
  },
  {
    title:   "АТФ — универсальная энергетическая валюта клетки",
    content: "Аденозинтрифосфат (АТФ) является основным переносчиком энергии в клетках всех живых организмов. Молекула АТФ содержит три фосфатные группы, связанные высокоэнергетическими связями.\n\nПути синтеза АТФ:\n1. Гликолиз — анаэробный процесс (2 молекулы АТФ из глюкозы)\n2. Цикл Кребса и окислительное фосфорилирование (32–34 молекулы АТФ)\n3. β-окисление жирных кислот\n\nВо время интенсивной физической нагрузки потребность в АТФ возрастает в 100–1000 раз.",
    section: biochemistry, author: editor, status: :published, views_count: 217,
    tags: [tags.find { |t| t.name == "АТФ" }, tags.find { |t| t.name == "метаболизм" }]
  },
  {
    title:   "Метаболизм углеводов при физических нагрузках",
    content: "Углеводы являются основным источником энергии при физических нагрузках средней и высокой интенсивности. Гликоген мышц и печени — главные депо углеводов в организме.\n\nПри нагрузке умеренной интенсивности (60–70% МПК) вклад углеводов составляет около 50%. При высокоинтенсивной работе (>85% МПК) — до 90%.\n\nИстощение запасов гликогена сопровождается резким падением работоспособности — феномен «гликогенового удара».",
    section: metabolism, author: editor, status: :published, views_count: 98,
    tags: [tags.find { |t| t.name == "метаболизм" }, tags.find { |t| t.name == "аэробный" }]
  },
  {
    title:   "Физиология быстрых и медленных мышечных волокон",
    content: "Скелетные мышцы состоят из двух основных типов волокон: медленно сокращающихся (тип I) и быстро сокращающихся (тип II).\n\nМедленные волокна (тип I):\n- Высокое содержание митохондрий\n- Устойчивы к утомлению\n- Основной субстрат — жирные кислоты\n\nБыстрые волокна (тип II):\n- Высокая скорость и сила сокращения\n- Быстро утомляются\n- Основной субстрат — гликоген\n\nСоотношение типов волокон генетически детерминировано и влияет на спортивный профиль.",
    section: physiology, author: editor, status: :published, views_count: 175,
    tags: [tags.find { |t| t.name == "мышцы" }, tags.find { |t| t.name == "аэробный" }, tags.find { |t| t.name == "анаэробный" }]
  },
  {
    title:   "Реабилитация после травм коленного сустава",
    content: "Реабилитация после повреждения передней крестообразной связки (ПКС) — длительный процесс, требующий комплексного подхода.\n\nЭтапы реабилитации:\n1. Острый период (0–2 нед.): снижение отёка, восстановление ROM\n2. Ранняя реабилитация (2–6 нед.): укрепление мышц, проприоцепция\n3. Функциональная реабилитация (6–12 нед.): спортивно-специфические движения\n4. Возврат к спорту (3–6 мес.): тестирование силы и функции\n\nКритерии допуска к соревнованиям: симметрия силы >90%, функциональные тесты прыжков.",
    section: sport_med, author: editor, status: :published, views_count: 231,
    tags: [tags.find { |t| t.name == "реабилитация" }, tags.find { |t| t.name == "суставы" }]
  },
  {
    title:   "Биомеханика позвоночника при силовых упражнениях",
    content: "Позвоночник — ключевая структура при выполнении силовых упражнений. Неправильная техника значительно увеличивает нагрузку на межпозвонковые диски.\n\nПри приседании со штангой:\n- Нейтральный лордоз снижает нагрузку на диск L4–L5 на 40%\n- Наклон туловища >45° существенно увеличивает момент силы\n\nПри становой тяге нагрузка на поясничный отдел может достигать 3000–6000 Н при правильной технике.",
    section: biomechanics, author: admin, status: :published, views_count: 89,
    tags: [tags.find { |t| t.name == "биомеханика" }, tags.find { |t| t.name == "мышцы" }]
  },
  {
    title:   "Гормональные адаптации к силовым тренировкам",
    content: "Силовые тренировки вызывают острые и хронические изменения гормонального фона.\n\nОстрая реакция (во время и после тренировки):\n- Тестостерон: +15–25%\n- Кортизол: +20–40%\n- Гормон роста: +200–700%\n\nХронические адаптации:\n- Повышение чувствительности андрогенных рецепторов\n- Оптимизация анаболическо-катаболического баланса\n\nСоотношение тестостерон/кортизол используется как маркер восстановления.",
    section: biochemistry, author: editor, status: :published, views_count: 134,
    tags: [tags.find { |t| t.name == "гормоны" }, tags.find { |t| t.name == "метаболизм" }]
  },
  {
    title:   "Питание для оптимизации спортивной производительности",
    content: "Рациональное питание — фундамент спортивной работоспособности. Основные принципы:\n\nУглеводная загрузка:\n- За 3–4 дня до соревнований: 8–12 г/кг/сут\n- Повышает запасы гликогена на 20–40%\n\nБелковое обеспечение:\n- 1.6–2.2 г/кг массы тела для силовых видов\n- 1.2–1.6 г/кг для видов на выносливость\n- Оптимальный приём после тренировки: 20–40 г\n\nГидратация: потеря 2% массы тела снижает производительность на 10–20%.",
    section: sport_med, author: editor, status: :published, views_count: 188,
    tags: [tags.find { |t| t.name == "питание" }, tags.find { |t| t.name == "метаболизм" }, tags.find { |t| t.name == "аэробный" }]
  },
  {
    title:   "Черновик: аэробный порог и ПАНО",
    content: "Порог анаэробного обмена (ПАНО) — интенсивность нагрузки, при которой производство лактата превышает его утилизацию...",
    section: physiology, author: editor, status: :draft, views_count: 0,
    tags: []
  }
]

articles_data.each do |data|
  next if Article.exists?(title: data[:title])

  article_tags = data.delete(:tags) || []
  article = Article.create!(data)
  article.tags = article_tags.compact
end
puts "Создано #{Article.count} статей"

# Комментарии
Article.published.first(3).each do |article|
  next if article.comments.exists?

  Comment.create!(article: article, user: member, body: "Отличная статья, очень информативно!")
  Comment.create!(article: article, user: admin, body: "Спасибо! Материал подготовлен на основе актуальных исследований.")
end
puts "Создано #{Comment.count} комментариев"

# Закладки
Article.published.first(2).each do |article|
  Bookmark.find_or_create_by!(user: member, article: article)
end
puts "Создано #{Bookmark.count} закладок"
