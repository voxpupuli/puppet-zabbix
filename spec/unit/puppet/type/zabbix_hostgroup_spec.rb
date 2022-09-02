# frozen_string_literal: true

require 'spec_helper'

describe Puppet::Type.type(:zabbix_hostgroup) do
  describe 'when validating attributes' do
    %i[name provider].each do |param|
      it "has a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end
end
