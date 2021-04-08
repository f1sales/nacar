# frozen_string_literal: true

require_relative "nacar/version"

require "f1sales_custom/source"
require "f1sales_custom/hooks"
require "f1sales_helpers"

module Nacar
  class Error < StandardError; end
  class F1SalesCustom::Hooks::Lead

    def self.switch_source(lead)
      source_name = lead.source.name
      if source_name.downcase.include?('facebook')
        message = lead.message.split(':').map(&:strip)
        store_question = message.index('por_qual_das_nossas_lojas_você_prefere_ser_atendido?')
        return source_name unless store_question

        store_name = message[store_question + 1]
        store_name = store_name.split('loja_').last
        "#{source_name} - #{store_name}"
      else
        source_name
      end
    end
  end
end
