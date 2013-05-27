require 'spec_helper'

describe Spree::OrdersController do
  context "going from delivery to payment state" do
    let(:order) { create :order }
    before do
      order.should_receive(:apply_payment_method_fees!)
      order.state = 'payment'
      order.stub :confirmation_required? => true
    end

    it 'works' do
      order.next!
      order.state.should == 'confirm'
    end
  end
end
