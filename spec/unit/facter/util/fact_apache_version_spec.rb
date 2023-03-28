# frozen_string_literal: true

require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end

  describe 'apache_version' do
    context 'with value' do
      before do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter::Core::Execution.stubs(:which).with('httpd').returns(true)
        Facter::Core::Execution.stubs(:execute).with('httpd -V 2>&1').returns('Server version: Apache/2.4.16 (Unix)\nServer built: Jul 31 2015 15:53:26')
      end

      it 'returns the correct version' do
        expect(Facter.fact(:apache_version).value).to eq('2.4.16')
      end
    end
  end

  describe 'apache_version with empty OS' do
    context 'with value' do
      before do
        Facter.fact(:kernel).stubs(:value).returns('Linux')
        Facter::Core::Execution.stubs(:which).with('httpd').returns(true)
        Facter::Core::Execution.stubs(:execute).with('httpd -V 2>&1').returns('Server version: Apache/2.4.6 ()\nServer built: Nov 21 2015 05:34:59')
      end

      it 'returns the correct version' do
        expect(Facter.fact(:apache_version).value).to eq('2.4.6')
      end
    end
  end
end
