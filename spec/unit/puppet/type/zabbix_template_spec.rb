require 'spec_helper'
require 'fakefs/spec_helpers'

describe Puppet::Type.type(:zabbix_template) do
  let(:resource) do
    Puppet::Type.type(:zabbix_template).new(
      template_name: 'MyTemplate',
      template_source: '/path/to/template.xml'
    )
  end
  let(:provider_class) { Puppet::Type.type(:zabbix_template).provider(:ruby) }
  let(:provider) { stub('provider', class: provider_class, clear: nil) }

  describe 'when validating attributes' do
    [
      :zabbix_url,
      :zabbix_user,
      :zabbix_pass,
      :apache_use_ssl,
      :template_name,
      :template_source,
      :provider
    ].each do |param|
      it "should have a #{param} parameter" do
        expect(described_class.attrtype(param)).to eq(:param)
      end
    end
  end

  describe 'namevar' do
    it 'has :template_name as its namevar' do
      expect(described_class.key_attributes).to eq([:template_name])
    end
  end

  describe 'ensure' do
    let(:property) { resource.property(:ensure) }

    [:present, :absent].each do |value|
      it "suppports #{value} as a value to :ensure" do
        expect { described_class.new(template_name: 'My template', ensure: value) }.not_to raise_error
      end
    end

    it 'rejects unknown values' do
      expect { described_class.new(template_name: 'My template', ensure: :foo) }.to raise_error(Puppet::Error)
    end

    it 'defaults to :present' do
      expect(described_class.new(name: 'My template').should(:ensure)).to eq(:present)
    end

    context 'when testing whether \'ensure\' is in sync' do
      it 'is insync if ensure is set to :present and the server template matches' do
        property.should = :present
        property.expects(:template_xmls_match?).returns true
        expect(property).to be_safe_insync(:present)
      end
      it 'is not insync if ensure is set to :present but the source and server templates don\'t match' do
        property.should = :present
        property.expects(:template_xmls_match?).returns false
        expect(property).not_to be_safe_insync(:present)
      end
    end

    describe '.template_xmls_match?' do
      mock_source_xml = <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export>
    <version>3.2</version>
    <date>2016-11-29T09:27:09Z</date>
    <groups>
        <group>
            <name>Templates</name>
        </group>
    </groups>
    <templates>
        <template>
            <template>MyTemplate</template>
            <name>MyTemplate</name>
            <description>foo</description>
            <groups>
                <group>
                    <name>Templates</name>
                </group>
            </groups>
            <applications/>
            <items/>
            <discovery_rules/>
            <httptests/>
            <macros/>
            <templates/>
            <screens/>
        </template>
    </templates>
</zabbix_export>
      EOS
      mock_provider_xml = <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export><version>3.2</version><date>2016-11-30T12:06:25Z</date><groups><group><name>Templates</name></group></groups><templates><template><template>MyTemplate</template><name>MyTemplate</name><description>foo</description><groups><group><name>Templates</name></group></groups><applications/><items/><discovery_rules/><httptests/><macros/><templates/><screens/></template></templates></zabbix_export>
      EOS
      it 'returns true when cleaned source xml matches cleaned server xml' do
        provider_class.stubs(:new).returns(provider)
        property.expects(:source_xml).returns(mock_source_xml)
        provider.expects(:xml).returns(mock_provider_xml)
        expect(property.template_xmls_match?).to eq true
      end
    end

    describe '.source_xml' do
      include FakeFS::SpecHelpers
      it 'returns content of :template_source as string' do
        mock_template_source_file = '/path/to/template.xml'
        mock_file_content = <<-EOS
mock
file
content
        EOS
        FileUtils.mkdir_p '/path/to'
        File.open(mock_template_source_file, 'w') do |f|
          f.write mock_file_content
        end
        expect(property.source_xml).to eq mock_file_content
      end
    end

    describe '.clean_xml' do
      it 'removes spaces after \'>\'s' do
        expect(property.clean_xml('> ')).to eq '>'
      end
      it 'removes tabs after \'>\'s' do
        expect(property.clean_xml(">\t")).to eq '>'
      end
      it 'removes newlines after \'>\'s' do
        expect(property.clean_xml(">\n")).to eq '>'
      end
      it 'removes spaces before \'<\'s' do
        expect(property.clean_xml(' <')).to eq '<'
      end
      it 'removes tabs before \'<\'s' do
        expect(property.clean_xml("\t<")).to eq '<'
      end
      it 'replaces dates with DATEWASHERE' do
        expect(property.clean_xml('<date>2016-11-30T12:06:25Z</date>')).to eq 'DATEWASHERE'
      end
    end

    describe '.change_to_s' do
      it 'returns \'Template updated\' when resource is being updated' do
        expect(property.change_to_s(:present, :present)).to eq 'Template updated'
      end
      it 'calls super otherwise' do
        expect(property.change_to_s(:absent, :present)).to eq 'created'
      end
    end
  end
end
