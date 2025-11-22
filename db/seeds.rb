# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ title: 'Star Wars' }, { title: 'Lord of the Rings' }])
#   Character.create(title: 'Luke', movie: movies.first)
Admin.create!(email: 'admin@example.com', password: '123456')

Item.create!(
  [
   {title: "緑茶", body: "" },
   {title: "オレンジジュース", body: "" },
   {title: "チーズタルト", body: "" },
   {title: "モンブラン", body: "" },
  {title: "冷蔵庫(2025モデル)1234-56789", body: "" },
  {title: "電子レンジABC-DEFG", body: "" },
  {title: "ボディソープ", body: "" },
  {title: "シャンプー", body: "" },
  {title: "オフィスチェア", body: "" },
  {title: "カラーボックス", body: "" },
  ]
)