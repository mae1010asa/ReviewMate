# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ title: 'Star Wars' }, { title: 'Lord of the Rings' }])
#   Character.create(title: 'Luke', movie: movies.first)
# データの初期化（重複防止のため既存データを削除）
puts "データをリセット中..."

# acts-as-taggable-on のテーブルをクリア
# Gemのモデルクラス名を指定して削除します
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
# 2. ユーザーデータの作成 (12名)
# ----------------------------------------------------------------
puts "ユーザーを作成中..."
users = []
user_names = [
  "佐藤 健一", "鈴木 愛", "高橋 誠", "田中 美咲", "伊藤 翔太",
  "渡辺 直美", "山本 裕樹", "中村 陽子", "小林 大輔", "加藤 里奈",
  "吉田 拓也", "山田 花子"
]

user_names.each_with_index do |name, i|
  users << User.create!(
    name: name,
    email: "user#{i + 1}@example.com",
    password: 'password'
  )
end

# ----------------------------------------------------------------
# 3. 商品データの作成 (商標を避けた具体的な名称に変更)
# ----------------------------------------------------------------
puts "商品を作成中..."
items = Item.create!([
  {
    title: "特選深蒸し茶『翠玉の雫』",
    body: "静岡県産の厳選された茶葉のみを使用した深蒸し茶です。通常の2倍の時間をかけて蒸すことで、濃厚なコクとまろやかな甘みを引き出しました。リラックスタイムに最適な一杯です。"
  },
  {
    title: "果汁100% プレミアムオレンジ『太陽の恵み』",
    body: "完熟バレンシアオレンジを丸ごと搾ったストレートジュース。保存料・砂糖不使用で、果実本来の酸味と甘みのバランスをお楽しみいただけます。朝食のお供に。"
  },
  {
    title: "北海道産濃厚チーズタルト（6個入り）",
    body: "北海道産のクリームチーズをふんだんに使用した、とろける食感のチーズタルトです。サクサクのタルト生地との相性は抜群。手土産にも喜ばれる一品です。"
  },
  {
    title: "和栗の贅沢モンブラン",
    body: "国産和栗のペーストを贅沢に絞ったモンブラン。中には渋皮煮が丸ごと一粒入っています。甘さ控えめの生クリームが栗の風味を引き立てます。"
  },
  {
    title: "スマート冷蔵庫 CoolFlow 500L (2025モデル)",
    body: "AI搭載の最新モデル。食材の使用頻度を学習し、最適な温度管理を自動で行います。500Lの大容量ながら、省エネ性能トップクラスを実現しました。"
  },
  {
    title: "多機能オーブンレンジ ProCook ABC-500",
    body: "「焼く・煮る・蒸す・揚げる」がこれ一台で完結。過熱水蒸気技術により、余分な脂を落としつつ、食材の旨みを閉じ込めます。時短料理の強い味方。"
  },
  {
    title: "ボタニカルモイスチャー ボディソープ",
    body: "天然由来成分90%配合。肌に優しい弱酸性のボディソープです。ラベンダーとゼラニウムの穏やかな香りが、バスタイムを癒しの空間に変えます。"
  },
  {
    title: "スカルプケアシャンプー Refresh Blue",
    body: "頭皮の汚れをしっかり落とし、健やかな髪を育てるノンシリコンシャンプー。メントール配合で洗い上がりはスッキリ爽快。男性にも女性にもおすすめです。"
  },
  {
    title: "エルゴノミクス オフィスチェア ZenSit",
    body: "人間工学に基づいた設計で、長時間のデスクワークでも疲れにくいチェアです。腰への負担を軽減するランバーサポート機能付き。通気性の良いメッシュ素材採用。"
  },
  {
    title: "モジュラー式カラーボックス (3段/木目調)",
    body: "どんな部屋にも馴染むナチュラルな木目調のデザイン。棚板の高さは自由に調節可能で、A4ファイルもすっきり収納できます。組み立て簡単、耐久性にも優れています。"
  }
])

# ----------------------------------------------------------------
# 4. レビューとタグ、コメントの作成
# ----------------------------------------------------------------
puts "レビュー・タグ・コメントを作成中..."

# レビュー用のサンプルテキスト
review_titles = ["最高です！", "期待通り", "うーん...", "コスパ良い", "リピート決定"]
review_bodies = [
  "とても使いやすくて気に入っています。友達にも勧めたいと思います。",
  "配送も早くて助かりました。商品は写真通りの色合いでした。",
  "値段の割に機能が充実していて驚きました。もっと早く買えばよかったです。",
  "少し思っていたのと違いましたが、許容範囲内です。",
  "毎日愛用しています。生活の質が上がりました！"
]

# タグの候補
tag_candidates = ["コスパ最強", "デザイン良し", "配送早", "ギフトに最適", "リピート", "高品質", "初心者向け"]

items.each do |item|
  # 各商品に0〜3件のレビューを作成
  rand(0..3).times do
    reviewer = users.sample # ランダムなユーザー
    
    # レビュー作成
    review = Review.create!(
      user: reviewer,
      item: item,
      title: review_titles.sample,
      body: review_bodies.sample,
      star: rand(1..5).to_s # schemaに合わせてstring型で保存
    )

    # タグ付け (0〜2個)
    # acts-as-taggable-onを使用している場合
    if defined?(ActsAsTaggableOn)
      tags = tag_candidates.sample(rand(0..2))
      review.tag_list.add(tags)
      review.save
    end

    # このレビューに対するコメント (0〜2件)
    rand(0..2).times do
      commenter = users.reject { |u| u == reviewer }.sample # レビュワー以外のユーザー
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
  # 自分以外のユーザーからランダムに2〜5人をフォロー対象として選ぶ
  targets = users.reject { |u| u == user }.sample(rand(2..5))
  
  targets.each do |target|
    # Relationshipモデルを使用して保存
    Relationship.create!(
      follower_id: user.id,
      followed_id: target.id
    )
  end
end

puts "データの作成が完了しました！"