Rails.application.config.to_prepare do
  ActsAsTaggableOn::Tag.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      ["name", "taggings_count", "created_at"]
    end
  end
end