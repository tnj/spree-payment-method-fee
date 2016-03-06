require 'spec_helper'

describe Spree::PaymentMethodFee do
  let(:payment_method) { create :check_payment_method }
  before(:each) { allow_any_instance_of(Spree::PaymentMethod).to receive(:payment_profiles_supported?).and_return(payment_profiles_supported) }

  describe 'creating a payment method fee' do
    subject do
      Spree::PaymentMethodFee.new( payment_method: payment_method, amount: 1, currency: 'USD' )
    end

    context 'with an payment method that supports payment profiles' do
      let(:payment_profiles_supported) { true }
      it { is_expected.to be_valid }

      context 'when a fee already exists on the payment method with the same currency' do
        before do
          Spree::PaymentMethodFee.create(
            payment_method: payment_method,
            amount: 1,
            currency: 'USD'
          )
        end
        it { is_expected.not_to be_valid }
      end
    end

    context 'with an payment method that doesnt support payment profiles' do
      let(:payment_profiles_supported) { false }
      it { is_expected.not_to be_valid }
    end
  end

  context '.apply_adjustment_to_order' do
    let(:order) { create :order }
    let(:payment_profiles_supported) { true }
    let(:fee) { Spree::PaymentMethodFee.create( payment_method: payment_method, currency: 'USD', amount: 200 ) }

    before do
      # create a 'fee' to verify it gets blown away when we call adjust
      order.adjustments.create amount: 10, label: 'fee'
      allow(order).to receive(:payment_method).and_return(payment_method)

      fee.add_adjustment_to_order(order)
    end

    context "with existing fees" do
      subject { order.adjustments.where(label: 'fee') }

      specify { expect(subject.size).to eq(1) }
      specify { expect(subject.first.amount).to eq(200) }
      specify { expect(subject.first.label).to eq('fee') }
    end
  end

  context '.add_adjustment_to_order' do
    let(:order) { create :order_with_line_items }
    let(:payment_profiles_supported) { false }
    let(:fee) { Spree::PaymentMethodFee.create( payment_method: payment_method, currency: 'USD', amount: 200 ) }
    before do
      fee.add_adjustment_to_order(order)
    end

    subject { order }
    specify { expect(subject.adjustments.size).to eq(1) }
    specify { expect(subject.adjustments.first.label).to eq("fee") }
  end
end
