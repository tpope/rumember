require File.expand_path(File.dirname(__FILE__) + '/../../spec/spec_helper')

describe Rumember::Transaction do

  let :response do
    { 'transaction' => { 'id' => '1', 'undoable' => '1' } }
  end

  let :parent do
    double.as_null_object
  end

  subject do
    Rumember::Transaction.new(parent, response)
  end

  its(:parent) { should == parent }
  its(:response) { should == response }
  its(:id) { should == 1 }
  its(:undoable?) { should be_true }
  its(:params) { should == {'transaction_id' => 1} }

  describe '#undo' do
    context 'when the transaction is not undoable' do
      let :response do
        { 'transaction' => { 'id' => '1', 'undoable' => '0' } }
      end

      it 'should not dispatch rtm.transactions.undo' do
        subject.should_not_receive(:dispatch).with('transactions.undo')
        subject.undo
      end

      it 'should return false' do
        subject.undo.should be_false
      end
    end

    context 'when the transaction is undoable' do
      it 'should dispatch rtm.transactions.undo' do
        subject.should_receive(:dispatch).with('transactions.undo')
        subject.undo
      end

      it 'should return true' do
        subject.undo.should be_true
      end
    end
  end

end
