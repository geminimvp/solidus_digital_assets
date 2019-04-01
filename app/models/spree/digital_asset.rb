# frozen_string_literal: true

require 'file_validators'

module Spree
  class DigitalAsset < Spree::Asset

    SUPPORTED_IMAGE_FORMATS = ["image/jpg", "image/jpeg", "image/png", "image/gif", "image/bmp"].freeze
    SUPPORTED_IMAGES_REGEX = Regexp.new('\A(' + SUPPORTED_IMAGE_FORMATS.join('|') + ')\Z').freeze

    self.table_name = "spree_digital_assets"
    attr_accessor :position, :type, :viewable_type, :viewable_id, :attachment_width, :attachment_height, :alt, :digital_asset_id

    belongs_to :folder
    has_many :assets

    has_one_attached :attachment

    validates :name, :attachment, :folder, presence: true

    validates :attachment, file_content_type: {
                allow: SUPPORTED_IMAGE_FORMATS,
                if: -> { attachment.attached? }
              }

    before_validation :assign_default_name, on: :create
    before_validation :assign_default_position, on: :create

    def image?
      attachment.attached?
    end

    # Specific sizes of images
    def mini
      attachment.variant(resize: '48x48')
    end

    def small
      attachment.variant(resize: '100x100')
    end

    def product
      attachment.variant(resize: '240x240')
    end

    def large
      attachment.variant(resize: '600x600')
    end

    private

      def assign_default_name
        self.name ||= default_name
      end

      def default_name
        File.basename(attachment.filename.to_s, '.*').titleize.truncate(255)
      end

      def assign_default_position
        self.position ||= 1
      end
  end
end
