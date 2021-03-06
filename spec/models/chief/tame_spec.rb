require 'spec_helper'

describe Chief::Tame do
  let(:common_tame_attributes) { attributes_for(:tame).slice(:fe_tsmp, :msrgp_code, :msr_type, :tty_code, :fe_tsmp, :amend_indicator) }

  describe 'associations' do
    describe 'tamfs' do
      let!(:tame) { create :tame, common_tame_attributes }
      let!(:tamf) { create :tamf, common_tame_attributes }

      context 'single choice' do
        it 'can be associated to one tamf record' do
          tame.tamfs.should include tamf
        end
      end

      context 'multiple choices' do
        let!(:tamf1) { create :tamf, common_tame_attributes.merge(fe_tsmp: Date.today.ago(20.years)) }

        it 'latest relevant tamf record is chosen' do
          tame.tamfs.should     include tamf
          tame.tamfs.should_not include tamf1
        end
      end
    end

    describe 'mfcms' do
      let(:common_mfcm_attributes) { attributes_for(:mfcm).slice(:fe_tsmp, :msrgp_code, :msr_type, :tty_code) }

      let!(:tame)  { create :tame, common_mfcm_attributes }
      let!(:mfcm1) { create :mfcm, common_mfcm_attributes }
      let!(:mfcm2) { create :mfcm, common_mfcm_attributes.merge(fe_tsmp: tame.fe_tsmp + 1.day) }

      it 'matches MFCMs that have fe_tsmp equal or later to own fe_tsmp' do
        tame.mfcms.should include mfcm1
        tame.mfcms.should include mfcm2
      end
    end
  end

  describe '#mark_as_processed!' do
    let!(:tame) { create :tame, common_tame_attributes }
    let!(:tamf) { create :tamf, common_tame_attributes }

    it 'marks itself as processed' do
      tame.processed.should be_false
      tame.mark_as_processed!
      tame.reload.processed.should be_true
    end

    it 'marks related tamfs as processed' do
      tamf.processed.should be_false
      tame.mark_as_processed!
      tamf.reload.processed.should be_true
    end
  end
end
