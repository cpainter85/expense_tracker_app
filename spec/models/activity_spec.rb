require "rails_helper"

describe Activity do
  describe "relationships" do
    it { should belong_to(:account) }
    it { should belong_to(:category) }
  end

  describe "elasticsearch_activity" do
    describe "settings" do
      subject(:settings) { Activity.__elasticsearch__.settings.to_hash }

      it "includes the 'keyword_normalizer" do
        expect(settings.dig(:index, :analysis, :normalizer)).to include(
          keyword_normalizer: hash_including(
            type: "custom",
            char_filter: [],
            filter: ["lowercase"]
          )
        )
      end

      it "includes the 'autocomplete analyzer'" do
        expect(settings.dig(:index, :analysis, :analyzer)).to include(
          autocomplete: hash_including(
            tokenizer: "autocomplete",
            filter: ["lowercase"]
          )
        )
      end

      it "includes the 'autocomplete tokenizer'" do
        expect(settings.dig(:index, :analysis, :tokenizer)).to include(
          autocomplete: hash_including(
            type: "edge_ngram",
            min_gram: 2,
            max_gram: 15,
            token_chars: ["letter", "digit"]
          )
        )
      end
    end

    describe "mapping" do
      subject(:mapping_properties) { Activity.__elasticsearch__.mapping.to_hash.dig(:activity, :properties) }

      it "indexes id" do
        expect(mapping_properties).to include(id: hash_including(type: "integer"))
      end

      it "indexes transaction_date" do
        expect(mapping_properties).to include(transaction_date: hash_including(type: "date"))
      end

      it "indexes merchant" do
        expect(mapping_properties).to include(merchant: hash_including(type: "text", analyzer: "autocomplete", search_analyzer: "standard"))
        expect(mapping_properties.dig(:merchant, :fields)).to include(sortable: hash_including(type: "keyword", normalizer: "keyword_normalizer"))
      end

      it "indexes description" do
        expect(mapping_properties).to include(description: hash_including(type: "text", analyzer: "english"))
        expect(mapping_properties.dig(:description, :fields)).to include(sortable: hash_including(type: "keyword", normalizer: "keyword_normalizer"))
      end

      it "indexes cleared" do
        expect(mapping_properties).to include(cleared: hash_including(type: "boolean"))
      end

       it "indexes amount" do
        expect(mapping_properties).to include(amount: hash_including(type: "scaled_float", scaling_factor: 100))
      end

      it "indexes account" do
        expect(mapping_properties).to include(account: hash_including(type: "object"))
      end

      describe "account object" do
        subject(:account_properties) { mapping_properties.dig(:account, :properties) }

        it "indexes id" do
          expect(account_properties).to include(id: hash_including(type: "integer"))
        end

        it "indexes name" do
          expect(account_properties).to include(name: hash_including(type: "keyword", normalizer: "keyword_normalizer"))
        end

        it "indexes enabled" do
          expect(account_properties).to include(enabled: hash_including(type: "boolean"))
        end

        it "indexes account_type" do
          expect(account_properties).to include(account_type: hash_including(type: "keyword", normalizer: "keyword_normalizer"))
        end

        it "indexes credit_limit" do
          expect(account_properties).to include(credit_limit: hash_including(type: "scaled_float", scaling_factor: 100))
        end
      end

      it "indexes category" do
        expect(mapping_properties).to include(category: hash_including(type: "object"))
      end

      describe "category object" do
        subject(:category_properties) { mapping_properties.dig(:category, :properties) }

        it "indexes id" do
          expect(category_properties).to include(id: hash_including(type: "integer"))
        end

        it "indexes name" do
          expect(category_properties).to include(name: hash_including(type: "keyword", normalizer: "keyword_normalizer"))
        end
      end
    end

    describe "#as_indexed_json" do
      let(:activity) { create(:activity) }

      it "returns json using the ActivitySerializer" do
        expect(activity.as_indexed_json).to eq ActivitySerializer.new(activity).as_json
      end
    end

    describe "ClassMethods" do
      describe "::versioned_index" do
        before :each do
          stub_const("ElasticsearchActivity::VERSION", 5)
          allow(Activity).to receive_message_chain(:__elasticsearch__, :index_name).and_return("activities")
        end

        it "returns the index name with the version" do
          expect(Activity.versioned_index).to eq "activities_v5"
        end

        context "given an argument of 'preceding: true'" do
          it "returns the index_name with a version 1 less than the current version" do
            expect(Activity.versioned_index(preceding: true)).to eq "activities_v4"
          end
        end
      end

      describe "::bulk_update_activity_documents" do
        let(:activity_ids) { [1,2,3,4] }
        let(:data) { { foo: "bar"} }

        before :each do
          allow(Activity).to receive(:versioned_index).and_return("activities_v1")
          allow(Activity).to receive(:document_type).and_return("activity")
        end

        it "makes an Elasticsearch bulk update request for all documents with the given ids" do
          expected_request_body = activity_ids.map do |id|
            {
              update: {
                _index: "activities_v1",
                _type: "activity",
                _id: id,
                data: { doc: data }
              }
            }
          end

          expect(Activity).to receive_message_chain(:__elasticsearch__, :client, :bulk)
            .with(body: expected_request_body)

          Activity.bulk_update_activity_documents(activity_ids: activity_ids, data: data)
        end
      end
    end

  end
end