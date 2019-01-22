Spree::Asset.class_eval do

  belongs_to :digital_asset

  before_validation :build_from_digital_asset, if: :digital_asset_id_changed?

  private
    def build_from_digital_asset
      digital_asset = Spree::DigitalAsset.find_by(id: digital_asset_id)
      if digital_asset.present?
        tmpfile = Tempfile.new(digital_asset.attachment.filename.to_s)
        tmpfile.binmode
        tmpfile.write(digital_asset.attachment.download)
        self.attachment = tmpfile
        self.attachment_file_name = digital_asset.attachment.filename.to_s
      else
        errors.add(:base, 'invalid digital asset id passed')
      end
    end

end
