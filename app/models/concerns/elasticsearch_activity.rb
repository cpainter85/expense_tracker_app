module ElasticsearchActivity
  extend ActiveSupport::Concern

  VERSION = 1

  included do
    include Elasticsearch::Model

    settings index: {
      analysis: {
        normalizer: {
          keyword_normalizer: {
            type: "custom",
            char_filter: [],
            filter: ["lowercase"]
          }
        }
      }
    } do

      mapping do
        indexes :id, type: "integer"
        indexes :transaction_date, type: "date"
        indexes :merchant, type: "text", analyzer: "english", fields: { sortable: { type: "keyword", normalizer: "keyword_normalizer" } }
        indexes :description, type: "text", analyzer: "english", fields: { sortable: { type: "keyword", normalizer: "keyword_normalizer" } }
        indexes :cleared, type: "boolean"
        indexes :amount, type: "scaled_float", scaling_factor: 100

        indexes :account, type: "object" do
          indexes :id, type: "integer"
          indexes :name, type: "keyword", normalizer: "keyword_normalizer" 
          indexes :enabled, type: "boolean"
          indexes :account_type, type: "keyword", normalizer: "keyword_normalizer"
          indexes :credit_limit, type: "scaled_float", scaling_factor: 100
        end

        indexes :category, type: "object" do
          indexes :id, type: "integer"
          indexes :name, type: "keyword", normalizer: "keyword_normalizer" 
        end
      end
    end
  end

  def as_indexed_json
    ActivitySerializer.new(self).as_json
  end
end