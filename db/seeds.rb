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

# Администратор
admin = User.find_or_create_by!(email: "admin@biochem.ru") do |u|
  u.name = "Администратор"
  u.password = "Biochem2026!"
  u.role = :admin
  u.jti = SecureRandom.uuid
end
puts "Администратор: #{admin.email}"
