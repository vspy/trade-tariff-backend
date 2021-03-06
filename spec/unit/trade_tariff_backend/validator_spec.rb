require 'spec_helper'

describe TradeTariffBackend::Validator do
  let(:model) { double(operation: :create, conformance_errors: double(add: true)) }
  let(:generic_validator) {
    Class.new(TradeTariffBackend::Validator) {
      validation :verify1, 'some validation' do |record|
        true
      end
    }
  }

  describe '.validations' do
    context 'no validations defined' do
      let(:validator) { Class.new(TradeTariffBackend::Validator) }

      it 'defaults to empty array' do
        validator.validations.should eq []
      end
    end

    context 'some validations defined' do
      it 'returns list of defined Validations' do
        generic_validator.validations.should_not be_blank
        generic_validator.validations.first.should be_kind_of TradeTariffBackend::Validations::GenericValidation
      end
    end
  end

  describe '#validations' do
    it 'is an alias to class .validations method' do
      generic_validator.validations.should eq generic_validator.new.validations
    end
  end

  describe '.validate' do
    before {
      generic_validator.validation :vld1, 'failing validation' do |record|
        false
      end

      generic_validator.new.validate(model)
    }

    it 'runs validations on record' do
      model.conformance_errors.should have_received(:add)
    end
  end

  describe '#validate' do
    context 'all validations pass' do
      before { generic_validator.new.validate(model) }

      it 'adds no error to object errors hash' do
        model.conformance_errors.should_not have_received(:add)
      end
    end

    context 'one of the validations wont pass' do
      before {
        generic_validator.validation :vld1, 'failing validation' do |record|
          false
        end

        generic_validator.new.validate(model)
      }

      it 'adds error to object errors hash' do
        model.conformance_errors.should have_received(:add)
      end
    end
  end

  describe '#validate_for_operations' do
    let(:model) {
      double(operation: :create,
             conformance_errors: double(add: true))
    }

    let(:contextual_validator) {
      Class.new(TradeTariffBackend::Validator) {
        validation :verify1, 'some validation', on: [:create, :update] do |record|
          true
        end

        validation :verify2, 'some validation', on: [:update] do |record|
          false
        end
      }
    }

    context 'operations match some defined validations' do
      context 'all validations pass' do
        before { contextual_validator.new.validate_for_operations(model, :create) }

        it 'adds no error to object errors hash' do
          model.conformance_errors.should_not have_received(:add)
        end
      end

      context 'one of the validations wont pass' do
        before {
          contextual_validator.new.validate_for_operations(model, :create, :update)
        }

        it 'adds an error to object errors hash' do
          model.conformance_errors.should have_received(:add)
        end
      end
    end

    context 'operatios do not match any validations' do
      let(:contextual_validator) {
        Class.new(TradeTariffBackend::Validator) {
          validation :verify1, 'some validation', on: [:create, :update] do |record|
            true
          end
        }
      }

      before {  contextual_validator.new.validate_for_operations(model, :destroy) }

      it 'adds no errors to objects hash' do
        model.conformance_errors.should_not have_received(:add)
      end
    end
  end
end
