require 'spec_helper'

describe TaricImporter::RecordProcessor::CreateOperation do
  let(:record_hash) {
    {"transaction.id"=>"31946",
     "record.code"=>"130",
     "subrecord.code"=>"05",
     "record.sequence.number"=>"1",
     "update.type"=>"3",
     "language.description"=>
      {"language.code.id"=>"FR",
       "language.id"=>"EN",
       "description"=>"French"}}
  }

  describe '#call' do
    let(:operation_date) { Date.new(2013,8,1) }
    let(:record) {
      TaricImporter::RecordProcessor::Record.new(record_hash)
    }

    let(:operation) {
      TaricImporter::RecordProcessor::CreateOperation.new(record, operation_date)
    }

    before {
      LanguageDescription.unrestrict_primary_key
    }

    it 'identifies as create operation' do
      LanguageDescription.count.should eq 0
      operation.call
      LanguageDescription.count.should eq 1
    end

    it 'returns model instance' do
      expect(operation.call).to be_kind_of LanguageDescription
    end

    it 'sets create operation date to operation_date' do
      operation.call

      expect(
        LanguageDescription::Operation.where(operation: 'C').first.operation_date
      ).to eq operation_date
    end
  end
end
