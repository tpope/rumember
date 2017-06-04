require File.expand_path(File.dirname(__FILE__) + '/../../spec/spec_helper')

describe Rumember::Timeline do

  let :interface do
    double.as_null_object
  end

  let :account do
    Rumember::Account.new(interface, 'key')
  end

  subject do
    Rumember::Timeline.new(account, 3)
  end

  its(:parent) { should == account }
  its(:params) { should == { 'timeline' => 3 } }

  describe '#smart_add' do
    it 'should dispatch rtm.tasks.add' do
      interface.should_receive(:dispatch).with(
        'tasks.add',
        'auth_token' => 'key',
        'name' => 'buy milk',
        'parse' => 1,
        'timeline' => 3
      )
      subject.smart_add('buy milk')
    end
  end

end
