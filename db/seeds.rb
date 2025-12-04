# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# ============================ User Seeds ============================
user1 = User.new(
  name: 'user1',
  email: 'user1@gmail.com',
  birth_date: '2025-01-01',
  password: '000000'
)
user1.icon_image.attach(io: Rails.root.join('db/seeds/icon1.png').open,
                        filename: 'icon1.png')
user1.skip_confirmation!
user1.save!

user2 = User.new(
  name: 'user2',
  email: 'user2@gmail.com',
  birth_date: '2025-01-01',
  password: '000000'
)
user2.icon_image.attach(io: Rails.root.join('db/seeds/icon2.png').open,
                        filename: 'icon2.png')
user2.skip_confirmation!
user2.save!

user3 = User.new(
  name: 'user3',
  email: 'user3@gmail.com',
  birth_date: '2025-01-01',
  password: '000000'
)
user3.icon_image.attach(io: Rails.root.join('db/seeds/icon2.png').open,
                        filename: 'icon2.png')
user3.skip_confirmation!
user3.save!

# ============================ Tweet Seeds ============================
user3.tweets.create!(
  content: 'ユーザー3の初めての投稿です。'
)

user2.tweets.create!(
  content: 'ユーザー2の初めての投稿です。'
)

user2.tweets.create!(
  content: '今日はサッカーをします。'
)

user1.tweets.create!(
  content: 'ユーザー1の初めての投稿です。'
)

user3.tweets.create!(
  content: '今日はプロテイン日和だ。'
)

user3.tweets.create!(
  content: 'プロテインが美味しい。'
)

tweet7 = user1.tweets.create!(
  content: 'おいしいりんごです。'
)
tweet7.images.attach(io: Rails.root.join('db/seeds/apple.png').open,
                     filename: 'apple.png')

user2.tweets.create!(
  content: 'サッカーシューズを買いました。'
)

user1.tweets.create!(
  content: 'りんごが食べたい。'
)

# ============================ Follow Seeds ============================
follow1 = user1.relationships.build(follower_id: user2.id)
follow1.save

follow2 = user1.relationships.build(follower_id: user3.id)
follow2.save

follow3 = user2.relationships.build(follower_id: user1.id)
follow3.save

follow4 = user2.relationships.build(follower_id: user3.id)
follow4.save

follow5 = user3.relationships.build(follower_id: user2.id)
follow5.save
