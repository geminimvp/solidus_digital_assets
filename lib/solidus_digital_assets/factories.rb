FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_digital_assets/factories'

  factory :asset, class: 'Spree::Variant' do
    price { 19.99 }
    cost_price { 17.00 }
    sku { generate(:sku) }
    is_master { 0 }
    track_inventory { true }
  end

  factory :folder, class: Spree::Folder do
    name { 'Documents' }
  end

  factory :digital_asset, class: 'Spree::DigitalAsset' do
    name { 'abc' }
    folder_id { 1 }
  end

end
