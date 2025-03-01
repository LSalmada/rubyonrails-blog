# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admins = {
  "admin@admin.com" => "Administrator",
  "test@test.com" => "Test User",
}

admins.each do |email, name|
  next if Admin.find_by(email: email)

  Admin.create!(
    email:, # o equivalente a email: email
    name:,
    password: ENV["DEFAULT_PASSWORD"],
    password_confirmation: ENV["DEFAULT_PASSWORD"],
  )
end

User.find_or_create_by(email: "user@user.com") do |user|
  user.password = ENV["DEFAULT_PASSWORD"]
  user.password_confirmation = ENV["DEFAULT_PASSWORD"]
end
