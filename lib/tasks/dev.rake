# frozen_string_literal: true

namespace :dev do
  desc "Reset the database"
  task reset: :environment do
    system("rails db:drop")
    system("rails db:create")
    system("rails db:migrate")
    system("rails db:seed")
    system("rails dev:add_categories")
    system("rails dev:add_authors")
    system("rails dev:add_articles")
  end

  desc "Add categories to the database."
  task add_categories: :environment do
    show_spinner("Adding categories") { add_categories }
  end

  desc "Add authors to the database."
  task add_authors: :environment do
    show_spinner("Adding authors") { add_authors }
  end

  desc "Add articles to the database."
  task add_articles: :environment do
    show_spinner("Adding articles") { add_articles }
  end

  def add_categories
    ["Ruby on Rails", "Linux", "WSL", "SQL", "DevOps", "Cloud", "Marketing", "React"].each do |name|
      category = Category.create!(
        name: name,
        description: Faker::Lorem.paragraph(sentence_count: rand(2..5)),
      )

      image_id = rand(1..8)

      category.cover_image.attach(
        io: File.open(
          Rails.root.join("lib/tasks/images/category#{image_id}.jpg"),
        ),
        filename: "category_avatar_#{image_id}.jpg",
      )
    end
  end

  def add_authors
    5.times do
      author = Author.create!(
        name: Faker::Name.name,
        description: Faker::Lorem.paragraph(sentence_count: rand(15..30)),
        facebook_profile_url: Faker::Internet.url(host: "facebook.com"),
        instagram_profile_url: Faker::Internet.url(host: "instagran.com"),
        twitter_profile_url: Faker::Internet.url(host: "twitter.com"),
        linkedin_profile_url: Faker::Internet.url(host: "linkedin.com"),
        youtube_profile_url: Faker::Internet.url(host: "youtube.com"),
      )

      image_id = rand(1..5)

      author.avatar_image.attach(
        io: File.open(
          Rails.root.join("lib/tasks/images/avatar-#{image_id}.png"),
        ),
        filename: "author_avatar_#{image_id}.png",
      )
    end
  end

  def add_articles
    50.times do
      article = Article.create!(
        title: Faker::Lorem.sentence.delete("."),
        body:  Faker::Lorem.paragraph(sentence_count: rand(100..200)),
        category: Category.all.sample,
        author: Author.all.sample,
        created_at: Faker::Date.between(from: 1.year.ago, to: Date.current),
      )

      image_id = rand(1..5)

      article.cover_image.attach(
        io: File.open(
          Rails.root.join("lib/tasks/images/full-hd/0#{image_id}.jpg"),
        ),
        filename: "article_#{image_id}.jpg",
      )
    end
  end

  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
