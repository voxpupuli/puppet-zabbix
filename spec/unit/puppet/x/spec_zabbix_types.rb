require 'spec_helper'

shared_examples 'generic namevar' do |name|
  it { expect(described_class.attrtype(name)).to eq :param }

  it 'is the namevar' do
    expect(described_class.key_attributes).to eq [name]
  end
end

shared_examples 'generic ensurable' do |*allowed|
  allowed ||= [:present, :absent, 'present', 'absent']

  context 'attrtype' do
    it { expect(described_class.attrtype(:ensure)).to eq :property }
  end

  context 'class' do
    it do
      expect(described_class.propertybyname(:ensure).ancestors).
        to include(Puppet::Property::Ensure)
    end
  end

  it 'defaults to :present' do
    expect(described_class.new(name: 'test').should(:ensure)).to eq(:present)
  end

  allowed.each do |value|
    it "should support #{value.inspect} as a value to :ensure" do
      expect { described_class.new(name: 'nobody', ensure: value) }.not_to raise_error
    end
  end

  it 'rejects unknown values' do
    expect { described_class.new(name: 'nobody', ensure: :foo) }.to raise_error(Puppet::Error)
  end
end

shared_examples 'boolean parameter' do |param, _default|
  it 'does not allow non-boolean values' do
    expect do
      described_class.new(:name => 'foo', param => 'unknown')
    end.to raise_error Puppet::ResourceError, %r{Valid values are true, false}
  end
end

shared_examples 'validated property' do |param, default, allowed, disallowed|
  context 'attrtype' do
    it { expect(described_class.attrtype(param)).to eq :property }
  end

  context 'allowed' do
    allowed.each do |value|
      it "should support #{value} as a value" do
        expect { described_class.new(:name => 'nobody', param => value) }.
          not_to raise_error
      end
    end
  end

  context 'disallowed' do
    unless disallowed.nil?
      disallowed.each do |value|
        it "rejects #{value} as a value" do
          expect { described_class.new(:name => 'nobody', param => :value) }.
            to raise_error(Puppet::Error)
        end
      end
    end
  end

  context 'default' do
    if default.nil?
      it 'has no default value' do
        resource = described_class.new(name: 'nobody')
        expect(resource.should(param)).to be_nil
      end
    else
      it "should default to #{default}" do
        resource = described_class.new(name: 'nobody')
        expect(resource.should(param)).to eq default
      end
    end
  end
end

shared_examples 'array_matching property' do |param, default|
  context 'attrtype' do
    it { expect(described_class.attrtype(param)).to eq :property }
  end

  context 'array_matching' do
    it { expect(described_class.attrclass(param).array_matching).to eq :all }
  end

  it 'supports an array of mixed types' do
    value = [true, 'foo']
    resource = described_class.new(name: 'test', param => value)
    expect(resource[param]).to eq value
  end

  context 'default' do
    if default.nil?
      it 'has no default value' do
        resource = described_class.new(name: 'nobody')
        expect(resource.should(param)).to be_nil
      end
    else
      it "should default to #{default}" do
        resource = described_class.new(name: 'nobody')
        expect(resource.should(param)).to eq default
      end
    end
  end
end

shared_examples 'boolean property' do |param, default|
  it 'does not allow non-boolean values' do
    expect do
      described_class.new(:name => 'foo', param => 'unknown')
    end.to raise_error Puppet::ResourceError, %r{Invalid value "unknown". Valid values are true, false.}
  end

  it_behaves_like 'validated property', param, default, [true, false, 'true', 'false', :true, :false]
end

shared_examples 'readonly property' do |param|
  it 'is readonly' do
    expect do
      described_class.new(:name => 'foo', param => 'invalid')
    end.to raise_error(Puppet::Error, %r{#{param} is read-only})
  end
end
