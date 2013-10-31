require 'spec_helper'

describe Spree::Order do
  let(:order) { create :order }
  let(:payment_method_with_fee) { create :payment_method }
  let(:payment_method_no_fee) { create :payment_method }

  before(:each) { Spree::PaymentMethod.any_instance.stub(:payment_profiles_supported?).and_return(true) }

  describe "after_update removes fee if payment method has no fee" do
    before do
      fee
      order.stub(payment_method: payment_method)
      order.save!
    end

    context "payment method with a fee" do
      let(:fee) { Spree::PaymentMethodFee.create( payment_method_id: payment_method_with_fee.id, amount: 1, currency: 'USD' ) }

      let(:payment_method) { payment_method_with_fee }

      it "has a fee", focus: true do
        order.adjustments.should_not be_empty
      end
    end

    context "payment method with no fee" do
      let(:fee) { nil }
      let(:payment_method) { payment_method_no_fee }

      it "removes fee when payment method is changed" do
        order.adjustments.should be_empty
      end
    end
  end

  describe "completing an order", focus: true do
    let(:order) { create :order_with_totals }
    let!(:fee) { Spree::PaymentMethodFee.create( payment_method_id: payment_method_with_fee.id, amount: 1, currency: 'USD' ) }

    let(:order) { create :order_with_totals }
    context "when order at one time had a fee" do
      it 'works' do
        order.stub(payment_method: payment_method_with_fee)
        order.line_items << create(:line_item)
        order.save!

        order.update_totals
        order.total.to_s.should == '11.0' # 10 + 1

        order.stub(payment_method: payment_method_no_fee)
        order.save!
        order.update_totals

        order.total.to_s.should == '10.0'
      end
    end
  end
end
