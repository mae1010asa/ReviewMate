# frozen_string_literal: true
# This migration comes from acts_as_taggable_on_engine (originally 2)

class AddMissingUniqueIndices < ActiveRecord::Migration[6.0]
  def self.up
    # 1. tags テーブルの name インデックス作成
    unless index_exists?(ActsAsTaggableOn.tags_table, :name)
      add_index ActsAsTaggableOn.tags_table, :name, unique: true
    end

    # 2. 外部キー制約の削除
    if foreign_key_exists?(ActsAsTaggableOn.taggings_table, ActsAsTaggableOn.tags_table)
      remove_foreign_key ActsAsTaggableOn.taggings_table, ActsAsTaggableOn.tags_table
    end

    # 3. 古い tag_id インデックスの削除
    if index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
      remove_index ActsAsTaggableOn.taggings_table, :tag_id
    end
    
    # 4. コンテキストインデックスの削除
    # 【修正点】 index_exists? にカラムの配列（[:taggable_id, ... context]）を追加しました
    if index_exists?(ActsAsTaggableOn.taggings_table, [:taggable_id, :taggable_type, :context], name: 'taggings_taggable_context_idx')
      remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx'
    end

    # 5. 新しい複合インデックスの追加
    # 【修正点】 ここもカラムの配列を明記してチェックします
    unless index_exists?(ActsAsTaggableOn.taggings_table, [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type], name: 'taggings_idx')
      add_index ActsAsTaggableOn.taggings_table,
                %i[tag_id taggable_id taggable_type context tagger_id tagger_type],
                unique: true, name: 'taggings_idx'
    end
  end

  def self.down
    if index_exists?(ActsAsTaggableOn.tags_table, :name)
      remove_index ActsAsTaggableOn.tags_table, :name
    end

    if index_exists?(ActsAsTaggableOn.taggings_table, [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type], name: 'taggings_idx')
      remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_idx'
    end

    unless index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
      add_index ActsAsTaggableOn.taggings_table, :tag_id
    end
    
    unless index_exists?(ActsAsTaggableOn.taggings_table, [:taggable_id, :taggable_type, :context], name: 'taggings_taggable_context_idx')
      add_index ActsAsTaggableOn.taggings_table, %i[taggable_id taggable_type context],
                name: 'taggings_taggable_context_idx'
    end
  end
end