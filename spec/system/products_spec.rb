require "rails_helper"

RSpec.describe "products", type: :system do
  describe "GET /products" do
    it "プロダクト一覧が確認できること" do
      products = create_list(:product, 3)
      visit "/products"
      products.each do |product|
        expect(page).to have_content(product.name)
      end
    end
  end

  describe "GET /products/:id" do
    let(:product) { create(:product) }

    before do
      visit "/products/#{product.id}"
    end

    it "プロダクト詳細が確認できること" do
      expect(page).to have_content(product.name)
    end

    it "プロダクト削除ができること" do
      expect do
        click_on "商品の削除"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content("商品一覧")
      end.to change(Product, :count).by(-1)
    end
  end

  describe "GET /products/new" do
    context "有効なプロダクト名で作成する場合" do
      it "プロダクトが作成されること" do
        visit "/products/new"

        expect do
          fill_in "名前", with: "新規登録した商品"
          click_on "登録する"

          expect(page).to have_content("新規登録した商品")
        end.to change(Product, :count).by(1)
      end
    end

    context "プロダクト名を空欄で作成する場合" do
      it "プロダクトが作成されないこと" do
        visit "/products/new"

        expect do
          fill_in "名前", with: ""
          click_on "登録する"

          expect(page).to have_content("名前を入力してください")
        end.not_to change(Product, :count)
      end
    end
  end

  describe "GET /products/:id/edit" do
    let(:product) { create(:product) }

    context "有効なプロダクト名で更新する場合" do
      it "プロダクトが更新されること" do
        visit "/products/#{product.id}/edit"

        expect do
          fill_in "名前", with: "更新した商品"
          click_on "更新する"

          expect(page).to have_content("更新した商品")
        end.to change { Product.find(product.id).name }.from(product.name).to("更新した商品")
      end
    end

    context "プロダクト名を空欄で更新する場合" do
      it "プロダクトが更新されないこと" do
        visit "/products/#{product.id}/edit"

        expect do
          fill_in "名前", with: ""
          click_on "更新する"

          expect(page).to have_content("名前を入力してください")
        end.not_to(change { Product.find(product.id).name })
      end
    end
  end
end
