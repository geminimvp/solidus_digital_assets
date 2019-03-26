# frozen_string_literal: true

module Spree
  class DigitalAsset < Spree::Asset

    SUPPORTED_IMAGE_FORMATS = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/bmp"].freeze
    SUPPORTED_IMAGES_REGEX = Regexp.new('\A(' + SUPPORTED_IMAGE_FORMATS.join('|') + ')\Z').freeze

    self.table_name = "spree_digital_assets"
    attr_accessor :position, :type, :viewable_type, :viewable_id, :attachment_width, :attachment_height, :alt, :digital_asset_id

    belongs_to :folder
    has_many :assets

    has_attached_file :attachment,
                      styles: { mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>' },
                      default_style: :product,
                      default_url: 'noimage/:style.png',
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }

    do_not_validate_attachment_file_type :attachment

    validates :name, :attachment, :folder, presence: true

    before_post_process :image?
    before_validation :assign_default_name, on: :create
    before_validation :assign_default_position, on: :create

    private
      def image?
        (attachment_content_type =~ SUPPORTED_IMAGES_REGEX).present?
      end

      def assign_default_name
        self.name ||= default_name
      end

      def default_name
        File.basename(attachment_file_name.to_s, '.*').titleize.truncate(255)
      end

      def assign_default_position
        self.position ||= 1
      end
  end
end
