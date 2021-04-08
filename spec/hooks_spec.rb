require File.expand_path '../spec_helper.rb', __FILE__
require 'ostruct'
require "f1sales_custom/hooks"

RSpec.describe F1SalesCustom::Hooks::Lead do

  context 'when is from Faceboook' do
    let(:source_name) { 'Facebook - Nacar Motorcycle Yamaha' }

    let(:source) do
      source = OpenStruct.new
      source.name = source_name
      source
    end

    context 'when does not have store info' do
      let(:store_name) { 'av_marcio_123' }
      let(:lead) do
        lead = OpenStruct.new
        lead.message = "por_qual_das_nossas_lojas_prefere_ser_atendido?: loja_#{store_name}:_av._joão_dias,_1837"
        lead.source = source
        lead
      end

      it 'returns source name with moto' do
        expect(described_class.switch_source(lead)).to eq(source_name)
      end
    end

    context 'when has store info' do
      let(:store_name) { 'av_marcio_123' }
      let(:lead) do
        lead = OpenStruct.new
        lead.message = "por_qual_das_nossas_lojas_você_prefere_ser_atendido?: loja_#{store_name}:_av._joão_dias,_1837"
        lead.source = source
        lead
      end

      it 'returns source name with moto' do
        expect(described_class.switch_source(lead)).to eq("#{source_name} - #{store_name}")
      end
    end
  end
end
