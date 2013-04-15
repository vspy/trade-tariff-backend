require 'spec_helper'

shared_examples_for 'Base Update' do
  describe '.sync' do
    before { prepare_synchronizer_folders }

    context 'when last update is for today' do
      let!(:example_chief_update) { create :chief_update, example_date: Date.today }
      let!(:example_taric_update) { create :taric_update, example_date: Date.today }

      it 'does not perform download' do
        described_class.should_receive(:download).never

        described_class.sync
      end
    end

    context 'when last update is out of date' do
      let!(:example_chief_update) { create :chief_update, example_date: Date.yesterday }
      let!(:example_taric_update) { create :taric_update, example_date: Date.yesterday }

      it 'should_receive download to be invoed' do
        described_class.should_receive(:download).at_least(1)

        described_class.sync
      end
    end

    after  { purge_synchronizer_folders }
  end

  describe '.update_type' do
    it 'raises error on base class' do
      expect { TariffSynchronizer::BaseUpdate.update_type }.to raise_error
    end

    it 'does not raise error on class that overrides it' do
      expect { described_class.update_type }.to_not raise_error
    end
  end
end
