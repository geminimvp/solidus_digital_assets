Spree::Admin::ImagesController.class_eval do
  before_action :load_folder_and_digital_assets, only: [:new, :edit, :create, :update, :index]

  private
    def load_folder_and_digital_assets
      @folders = Spree::Folder.all
      @digital_assets = Spree::DigitalAsset.page(params[:page])
      @product_assets = product&.digital_assets
    end

    def product
      product_id = params[:product_id]
      return nil if product_id.nil?
      @product ||= Spree::Product.find_by(slug: product_id)
    end
end
