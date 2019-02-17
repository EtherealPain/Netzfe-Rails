# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#User.create!(email: 'm14gang@ucla.com', password: "wargoddess", password_confirmation:"wargoddess")
#Category.create!(description: 'Marcadores', status: 1)
#Activity.create!(user: User.find(1), title: "Adiós", description: "Actividad de ejemplo numero uno", deadline:DateTime.parse("2019-12-29"), category: Category.find(1))

4.times do 
	Category.create(description: Faker::Lorem.unique.word, status: 1)
end

10.times do 
	User.create(
		email: Faker::Internet.unique.safe_email,
		password: "samepassword",
		password_confirmation: "samepassword",
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		date_of_birth: Faker::Date.birthday(18, 30),
		phone: Faker::PhoneNumber.cell_phone,
		degree: Faker::Educator.degree
		)
end


10.times do 
	Activity.create(
		user: User.find(Faker::Number.between(1, 10)),
		title: Faker::Lorem.sentence,
		description: Faker::Lorem.paragraph,
		deadline:Faker::Time.forward(100, :morning),
		category: Category.find(Faker::Number.between(1, 4))
		)
end