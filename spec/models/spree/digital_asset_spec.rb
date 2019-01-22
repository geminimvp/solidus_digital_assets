require 'spec_helper'

describe Spree::DigitalAsset, :type => :model do
  subject { digital_asset }

  let(:digital_asset) {
    build(:digital_asset, :with_attachment, digital_asset_attrs)
  }
  let(:folder) { digital_asset.folder }

  let(:digital_asset_attrs) {
    {
      name: nil,
    }
  }
  let(:pdf_digital_asset) {
    build(:digital_asset, pdf_digital_asset_attrs)
  }
  let(:pdf_digital_asset_attrs) {
    {
      folder: folder,
    }
  }
  let(:pdf_digital_asset_attachment_file) {
    File.open(Spree::Core::Engine.root.join('solidus_core.gemspec'))
  }

  before do
    pdf_digital_asset.attachment.attach(io: pdf_digital_asset_attachment_file, filename: 'solidus_core.gemspec')
  end

  it { is_expected.to have_attached_file(:attachment) }

  describe 'Associations' do
    it { is_expected.to belong_to(:folder) }
    it { is_expected.to have_many(:assets) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:folder) }
  end

  describe 'callbacks' do
    describe 'before_validation' do
      context 'create' do
        it 'sets a default name' do
          expect { digital_asset.valid? }.to change { digital_asset.name }.from(nil).to('Thinking Cat')
        end
      end

      context 'update' do
        before do
          digital_asset.save
          digital_asset.name = ''
        end

        it { expect { digital_asset.valid? }.not_to change { digital_asset.name } }
      end
    end
  end

  describe '#assign_default_name' do
    context 'name blank' do
      it { expect { digital_asset.send(:assign_default_name) }.to change { digital_asset.name }.from(nil).to('Thinking Cat') }
    end

    context 'name present' do
      before { digital_asset.name = 'test' }

      it { expect { digital_asset.send(:assign_default_name) }.not_to change { digital_asset.name } }
    end
  end

  describe '#image?' do
    context 'image present' do
      it { expect(digital_asset.send(:image?)).to be true }
    end

    context 'image not present' do
      xit { expect(pdf_digital_asset.send(:image?)).to be false }
    end
  end

end
