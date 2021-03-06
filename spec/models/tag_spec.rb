require 'rails_helper'

RSpec.describe Tag, type: :model do

  let(:tag) { Tag.new(name: "tagname") }

  describe "タグ名の必須チェック" do
    context "タグ名があるとき" do
      it "有効な状態であること" do
        expect(tag).to be_valid
      end
    end

    context "タグ名が無いとき" do
      it "無効な状態であること" do
        invalid_tag = Tag.new(name: "")
        expect(invalid_tag).to be_invalid
      end

      it "バリデーションエラーメッセージが表示されること" do
        invalid_tag = Tag.new(name: "")
        invalid_tag.valid?

        expect(invalid_tag.errors[:name]).to include("を入力してください")
      end
    end
  end

  describe "タグ名の一意制約チェック" do
    context "一致するタグ名が存在しないとき" do
      it "有効な状態であること" do
        expect(tag).to be_valid
      end

      it "タグが作成されること" do
        expect{ tag.save }.to change{ Tag.count }.by(1)
      end
    end

    context "既にタグ名が存在するとき" do
      it "無効な状態であること" do
        Tag.create(name: "tagname")

        expect(tag).to be_invalid
      end

      it "バリデーションエラーメッセージが表示されること" do
        Tag.create(name: "tagname")
        tag.valid?

        expect(tag.errors[:name]).to include("はすでに存在します")
      end

      context "同じ文字列で大文字が既に作成されているとき" do
        it "無効な状態であること" do
          Tag.create(name: "TAGNAME")

          expect(tag).to be_invalid
        end

        it "バリデーションエラーメッセージが表示されること" do
          Tag.create(name: "TAGNAME")
          tag.valid?

          expect(tag.errors[:name]).to include("はすでに存在します")
        end
      end

      context "同じ文字列で小文字で既に作成されているとき" do
        it "無効な状態であること" do
          Tag.create(name: "tagname")

          expect(Tag.new(name: "TAGNAME")).to be_invalid
        end

        it "バリデーションエラーメッセージが表示されること" do
          Tag.create(name: "tagname")
          upcase_tag = Tag.new(name: "TAGNAME")
          upcase_tag.valid?

          expect(upcase_tag.errors[:name]).to include("はすでに存在します")
        end
      end
    end
  end

  describe "文字数制限" do

    context "タグ名が50文字のとき" do
      it "有効な状態であること" do
        expect(Tag.new(name: "a" * 50)).to be_valid
      end
    end

    context "タグ名が51文字のとき" do
      it "無効な状態であること" do
        expect(Tag.new(name: "a" * 51)).to be_invalid
      end

      it "バリデーションエラーメッセージが表示されること" do
        invalid_tag = Tag.new(name: "a" * 51)
        invalid_tag.valid?

        expect(invalid_tag.errors[:name]).to include("は50文字以内で入力してください")
      end
    end
  end
end
