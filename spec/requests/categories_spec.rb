require "rails_helper"

describe "Categories" do
  describe "POST /categories" do
    let(:category_attributes) { FactoryBot.attributes_for(:category).with_indifferent_access }
    
    it "creates a new Category" do
      post "/categories", params: { category: category_attributes }
      expect(response).to redirect_to(categories_path)
      expect(Category.last.attributes).to include(category_attributes)
    end
  end

  describe "PUT /categories/:id/" do
    let(:category) { create(:category, name: "Foo") }
    let(:updated_attributes) { { name: "Bar" } }
    
    it "updates a Category" do
      put "/categories/#{category.id}", params: { category: updated_attributes }
      expect(response).to redirect_to(categories_path)
      category.reload
      expect(category.name).to eq "Bar"
    end
  end

  describe "DELETE /categories/:id" do
    let(:category) { create(:category) }

    it "deletes a Category" do
      delete "/categories/#{category.id}"
      expect(response).to redirect_to(categories_path)
      expect { Category.find(category.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end