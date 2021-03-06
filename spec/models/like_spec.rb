# == Schema Information
#
# Table name: likes
#
#  id             :integer          not null, primary key
#  number_to_like :integer          not null
#  like_it        :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

RSpec.describe Like, type: :model do

  subject(:like) { FactoryGirl.build :like }

  context "validations" do

    # this fails cause integer attr converts inputs to int
    # it { is_expected.to validate_numericality_of(:number_to_like).only_integer }
    # it { is_expected.to validate_numericality_of(:like_it).only_integer }

  end

  context "with valid params" do

    it "saves record" do
      expect{ like.save }.to change(Like, :count).by 1
    end

  end


  describe "::like_toggle" do

    let(:number) { 1234 }

    it "creates new record if number doesn't exists" do
      expect { Like.like_toggle(number) }.to change(Like, :count).by 1
    end

    context "record exists and is liked" do

      before do
        like.number_to_like = number
        like.like_it = 1
        like.save
        @like_toggle = Like.like_toggle(like.number_to_like)
      end

      it "returns false" do
        expect(@like_toggle).to be_falsey
      end

      it "doesn't create new record" do
        expect { Like.like_toggle(number) }.to change(Like, :count).by 0
      end

      it "set like_it to 0 if number is in DB" do
        set_like = Like.find_by_number_to_like(like.number_to_like)
        expect(set_like.like_it).to be == 0
      end
    end

    context "record exists and is unliked" do

      before do
        like.number_to_like = number
        like.like_it        = 0
        like.save
        @like_toggle = Like.like_toggle(like.number_to_like)
      end

      it "returns true" do
        expect(@like_toggle).to be_truthy
      end

      it "set like_it to 1 and return true" do
        set_like = Like.find_by_number_to_like(like.number_to_like)
        expect(set_like.like_it).to be == 1
      end

    end

  end

  describe "::get_likes" do

    before do
      numbers = (10..20).to_a
      numbers.each { |number| FactoryGirl.create :like, number_to_like: number }
    end


    it "returns numbers btween given range" do
      result = Like.get_likes(12, 17)
      expect(result.size).to be == 6
    end

  end

end
