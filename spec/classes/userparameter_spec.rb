require 'spec_helper'

describe 'zabbix::userparameter' do
  let(:node) { 'agent.example.com' }
  it 'should compmile with default parameter' do
      should compile
  end
end
