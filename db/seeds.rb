# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: 'standard@rifle.ammo', password: "5.56x45NATO", password_confirmation:"5.56x45NATO")
Category.create!(description: 'Recolecta', status: 1)
Activity.create!(user: User.find(1), description: "Actividad de ejemplo numero uno", deadline:DateTime.parse("2019-12-29"), category: Category.find(1))