require File.expand_path(File.dirname(__FILE__) + '/../spec/spec_helper')

describe Rumember do
  subject do
    Rumember.new('abc123', 'BANANAS')
  end

  describe '#api_sig' do
    it 'should MD5 the concatenated sorted parameters' do
      subject.api_sig(:yxz => 'foo', :feg => 'bar', :abc => 'baz').should ==
        '82044aae4dd676094f23f1ec152159ba'
    end
  end
end
