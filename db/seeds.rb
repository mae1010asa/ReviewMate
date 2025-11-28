# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ title: 'Star Wars' }, { title: 'Lord of the Rings' }])
#   Character.create(title: 'Luke', movie: movies.first)
# データの初期化
puts "データをリセット中..."
ActsAsTaggableOn::Tagging.destroy_all if defined?(ActsAsTaggableOn)
ActsAsTaggableOn::Tag.destroy_all if defined?(ActsAsTaggableOn)
Comment.destroy_all
Relationship.destroy_all
Review.destroy_all
Item.destroy_all
User.destroy_all
Admin.destroy_all

# ----------------------------------------------------------------
# 1. 管理者データの作成
# ----------------------------------------------------------------
puts "管理者を作成中..."
Admin.create!(
  email: 'admin@example.com',
  password: 'password'
)

# ----------------------------------------------------------------
# 2. ユーザーデータの作成 (12名・画像付き)
# ----------------------------------------------------------------
puts "ユーザーを作成中..."

# ユーザー定義（名前、性別画像）
user_list = [
  { name: "佐藤 健一", image: "男性１.png" },
  { name: "鈴木 愛",   image: "女性１.png" },
  { name: "高橋 誠",   image: "男性２.png" },
  { name: "田中 美咲", image: "女性２.png" },
  { name: "伊藤 翔太", image: "男性３.png" },
  { name: "渡辺 直美", image: "女性３.png" },
  { name: "山本 裕樹", image: "男性４.png" },
  { name: "中村 陽子", image: "女性４.png" },
  { name: "小林 大輔", image: "男性５.png" },
  { name: "加藤 里奈", image: "女性５.png" },
  { name: "吉田 拓也", image: "男性６.png" },
  { name: "山田 花子", image: "女性６.png" }
]

users = []

user_list.each_with_index do |data, i|
  user = User.create!(
    name: data[:name],
    email: "user#{i + 1}@example.com",
    password: 'password'
  )

  # 画像の添付処理
  image_path = Rails.root.join('app/assets/images', data[:image])
  if File.exist?(image_path)
    user.user_image.attach(io: File.open(image_path), filename: data[:image])
  else
    puts "警告: 画像ファイルが見つかりません (#{data[:image]})"
  end

  users << user
end

# ----------------------------------------------------------------
# 3. 商品データの作成 (画像付き)
# ----------------------------------------------------------------
puts "商品を作成中..."

item_list = [
  {
    title: "特選深蒸し茶『翠玉の雫』",
    body: "静岡県産の厳選された茶葉のみを使用した深蒸し茶です。通常の2倍の時間をかけて蒸すことで、濃厚なコクとまろやかな甘みを引き出しました。",
    image: "緑茶.png"
  },
  {
    title: "果汁100% プレミアムオレンジ『太陽の恵み』",
    body: "完熟バレンシアオレンジを丸ごと搾ったストレートジュース。保存料・砂糖不使用で、果実本来の酸味と甘みのバランスをお楽しみいただけます。",
    image: "オレンジジュース.png"
  },
  {
    title: "北海道産濃厚チーズタルト（6個入り）",
    body: "北海道産のクリームチーズをふんだんに使用した、とろける食感のチーズタルトです。手土産にも喜ばれる一品です。",
    image: "チーズタルト.png"
  },
  {
    title: "和栗の贅沢モンブラン",
    body: "国産和栗のペーストを贅沢に絞ったモンブラン。中には渋皮煮が丸ごと一粒入っています。",
    image: "モンブラン.png"
  },
  {
    title: "スマート冷蔵庫 CoolFlow 500L (2025モデル)",
    body: "AI搭載の最新モデル。食材の使用頻度を学習し、最適な温度管理を自動で行います。500Lの大容量ながら、省エネ性能トップクラスを実現しました。",
    image: "冷蔵庫.png"
  },
  {
    title: "多機能オーブンレンジ ProCook ABC-500",
    body: "「焼く・煮る・蒸す・揚げる」がこれ一台で完結。過熱水蒸気技術により、余分な脂を落としつつ、食材の旨みを閉じ込めます。",
    image: "オーブンレンジ.png"
  },
  {
    title: "ボタニカルモイスチャー ボディソープ",
    body: "天然由来成分90%配合。肌に優しい弱酸性のボディソープです。ラベンダーとゼラニウムの穏やかな香りが、バスタイムを癒しの空間に変えます。",
    image: "ボディソープ.png"
  },
  {
    title: "スカルプケアシャンプー Refresh Blue",
    body: "頭皮の汚れをしっかり落とし、健やかな髪を育てるノンシリコンシャンプー。メントール配合で洗い上がりはスッキリ爽快。",
    image: "シャンプー.png"
  },
  {
    title: "エルゴノミクス オフィスチェア ZenSit",
    body: "人間工学に基づいた設計で、長時間のデスクワークでも疲れにくいチェアです。腰への負担を軽減するランバーサポート機能付き。",
    image: "オフィスチェア.png"
  },
  {
    title: "モジュラー式カラーボックス (3段/木目調)",
    body: "どんな部屋にも馴染むナチュラルな木目調のデザイン。棚板の高さは自由に調節可能で、A4ファイルもすっきり収納できます。",
    image: "カラーボックス.png"
  }
]

created_items = []

item_list.each do |data|
  item = Item.create!(
    title: data[:title],
    body: data[:body]
  )

  # 画像の添付処理
  image_path = Rails.root.join('app/assets/images', data[:image])
  if File.exist?(image_path)
    item.item_image.attach(io: File.open(image_path), filename: data[:image])
  else
    puts "警告: 画像ファイルが見つかりません (#{data[:image]})"
  end

  created_items << item
end

# ----------------------------------------------------------------
# 4. レビューとタグ、コメントの作成
# ----------------------------------------------------------------
puts "レビュー・タグ・コメントを作成中..."

review_titles = ["最高です！", "期待通り", "うーん...", "コスパ良い", "リピート決定"]
review_bodies = [
  "とても使いやすくて気に入っています。友達にも勧めたいと思います。",
  "配送も早くて助かりました。商品は写真通りの色合いでした。",
  "値段の割に機能が充実していて驚きました。もっと早く買えばよかったです。",
  "少し思っていたのと違いましたが、許容範囲内です。",
  "毎日愛用しています。生活の質が上がりました！"
]
tag_candidates = ["コスパ最強", "デザイン良し", "配送早", "ギフトに最適", "リピート", "高品質", "初心者向け"]

created_items.each do |item|
  rand(0..3).times do
    reviewer = users.sample
    
    review = Review.create!(
      user: reviewer,
      item: item,
      title: review_titles.sample,
      body: review_bodies.sample,
      star: rand(1..5).to_s
    )

    if defined?(ActsAsTaggableOn)
      tags = tag_candidates.sample(rand(0..2))
      review.tag_list.add(tags)
      review.save
    end

    rand(0..2).times do
      commenter = users.reject { |u| u == reviewer }.sample
      Comment.create!(
        user: commenter,
        review: review,
        body: ["参考になりました！", "私もこれ気になってます。", "詳細なレビューありがとうございます！", "買ってみようかな。"].sample
      )
    end
  end
end

# ----------------------------------------------------------------
# 5. フォロー/フォロワー関係の作成
# ----------------------------------------------------------------
puts "フォロー関係を構築中..."

users.each do |user|
  targets = users.reject { |u| u == user }.sample(rand(2..5))
  targets.each do |target|
    Relationship.create!(
      follower_id: user.id,
      followed_id: target.id
    )
  end
end

puts "データの作成が完了しました！"