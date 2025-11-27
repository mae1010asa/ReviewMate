# frozen_string_literal: true
# This migration comes from acts_as_taggable_on_engine (originally 2)

def self.up
    # 【対策1】 Duplicate key name エラー対策
    # unless: index_exists? を追加し、既にインデックスがある場合は作成をスキップします
    add_index ActsAsTaggableOn.tags_table, :name, unique: true, unless: index_exists?(ActsAsTaggableOn.tags_table, :name)

    # 【対策2】 Foreign key constraint エラー対策
    # インデックスを削除する前に、邪魔な外部キー制約を削除します
    if foreign_key_exists?(ActsAsTaggableOn.taggings_table, ActsAsTaggableOn.tags_table)
      remove_foreign_key ActsAsTaggableOn.taggings_table, ActsAsTaggableOn.tags_table
    end

    # インデックス削除（既に存在しない場合はスキップ）
    remove_index ActsAsTaggableOn.taggings_table, :tag_id if index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
    
    # 以下の古いインデックス削除も、存在チェックをしてから実行
    if index_exists?(ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx')
      remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx'
    end

    # 新しい複合インデックスの追加（存在しない場合のみ）
    unless index_exists?(ActsAsTaggableOn.taggings_table, name: 'taggings_idx')
      add_index ActsAsTaggableOn.taggings_table,
                %i[tag_id taggable_id taggable_type context tagger_id tagger_type],
                unique: true, name: 'taggings_idx'
    end
  end

  def self.down
    remove_index ActsAsTaggableOn.tags_table, :name if index_exists?(ActsAsTaggableOn.tags_table, :name)

    remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_idx' if index_exists?(ActsAsTaggableOn.taggings_table, name: 'taggings_idx')

    add_index ActsAsTaggableOn.taggings_table, :tag_id unless index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
    
    unless index_exists?(ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx')
      add_index ActsAsTaggableOn.taggings_table, %i[taggable_id taggable_type context],
                name: 'taggings_taggable_context_idx'
    end
  end
end
