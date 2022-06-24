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

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when does not have store info' do
      let(:store_name) { 'av_marcio_123' }
      let(:lead) do
        lead = OpenStruct.new
        lead.message = "por_qual_das_nossas_lojas_prefere_ser_atendido?: loja_#{store_name}:_av._joão_dias,_1837"
        lead.source = source
        lead
      end

      it 'returns source name with moto' do
        expect(switch_source).to eq(source_name)
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
        expect(switch_source).to eq("#{source_name} - #{store_name}")
      end
    end
  end

  context 'when is from landing page' do
    let(:lead) do
      lead = OpenStruct.new
      lead.source = source
      lead.description = 'Loja: SAÚDE | Telefone do cliente: (11) 98501-3987 | Cpf do cliente: 387.341.732-01 | O Cliente aceita receber ofertas no E-mail? Sim'

      lead
    end

    let(:source) do
      source = OpenStruct.new
      source.name = source_name

      source
    end

    let(:source_name) { 'Landing Page Nacar' }

    let(:switch_source) { described_class.switch_source(lead) }

    context 'when lead is to Saúde Store' do
      it 'return SAÚDE' do
        expect(switch_source).to eq("#{source_name} - SAÚDE")
      end
    end

    context 'when lead is to Santo Amaro Store' do
      before { lead.description = 'Loja: SANTO AMARO | Telefone do cliente: (11) 96212-2785 | Cpf do cliente: 367.222.348-21 | O Cliente aceita receber ofertas no E-mail? Sim'}

      it 'return SANTO AMARO' do
        expect(switch_source).to eq("#{source_name} - SANTO AMARO")
      end
    end

    context 'when lead is to Vila das Merces Store' do
      before { lead.description = 'Loja: VILA DAS MERCES | Telefone do cliente: (11) 91234-0036 | Cpf do cliente: 000.904.498-01 | O Cliente aceita receber ofertas no E-mail? Sim'}

      it 'return SANTO AMARO' do
        expect(switch_source).to eq("#{source_name} - VILA DAS MERCES")
      end
    end
  end
end
