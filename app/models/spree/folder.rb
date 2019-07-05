module Spree
  class Folder < Spree::Base

    acts_as_nested_set dependent: :restrict_with_error

    has_many :digital_assets, dependent: :restrict_with_error

    validates :name, presence: true

    def self.product_images_folder
      find_or_create_by(name: 'Product Images')
    end

  end
end
