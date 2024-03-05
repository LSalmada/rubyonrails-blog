# frozen_string_literal: true

namespace :dev do
  desc "Add articles to the database."
  task add_articles: :environment do
    show_spinner("Adding articles") { add_articles }
  end

  def add_articles
    50.times do
      title = Faker::Lorem.sentence.delete(".")
      body = Faker::Lorem.paragraph(sentence_count: rand(100..200))
      Article.create!(title: title, body: body)
    end
  end

  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
