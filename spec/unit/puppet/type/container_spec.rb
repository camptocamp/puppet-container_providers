require 'spec_helper'

describe Puppet::Type.type(:container) do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before :each do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'when validating attributes' do
        [ :provider, :name ].each do |param|
          it "should have a #{param} parameter" do
            expect(described_class.attrtype(param)).to eq(:param)
          end
        end
        [ :ensure, :image, :restart, :command ].each do |prop|
          it "should have a #{prop} property" do
            expect(described_class.attrtype(prop)).to eq(:property)
          end
        end
      end

      describe 'when validating values' do
        describe 'for ensure' do
          it 'should support :created as a value to :ensure' do
            expect { described_class.new(:name => 'foo', :ensure => :created) }.to_not raise_error
          end

          it 'should support :restarting as a value to :ensure' do
            expect { described_class.new(:name => 'foo', :ensure => :restarting) }.to_not raise_error
          end

          it 'should support :running as a value to :ensure' do
            expect { described_class.new(:name => 'foo', :ensure => :running) }.to_not raise_error
          end

          it 'should support :paused as a value to :ensure' do
            expect { described_class.new(:name => 'foo', :ensure => :paused) }.to_not raise_error
          end

          it 'should support :exited as a value to :ensure' do
            expect { described_class.new(:name => 'foo', :ensure => :exited) }.to_not raise_error
          end

          it 'should not support other values for :ensure' do
            expect { described_class.new(:name => 'foo', :ensure => :blahblah) }.to raise_error Puppet::Error, /Invalid value/
          end
        end
      end
    end
  end
end
