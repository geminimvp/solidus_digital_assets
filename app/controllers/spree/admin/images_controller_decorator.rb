Spree::Admin::ImagesController.class_eval do
  before_action :load_folder_and_digital_assets, only: [:new, :edit, :create, :update, :index]

  def create
    if digital_asset_params[:digital_asset_id].present?
      # retreive Digital asset by ID
      # retrieve associated Image
      # create a spree_asset_variant based on the Image
    else
      save_and_create_digital_asset
    end
  end

  private

    def save_and_create_digital_asset
      @digital_asset = Spree::DigitalAsset.new(image_params).tap do |asset|
        asset.folder = Spree::Folder.find_or_create_by(name: "Product Images") if asset.folder.nil?
        if asset.save!
          @image = scope.images.create(image_params).tap do |img|
            img.type = "Spree::DigitalAsset"
            img.digital_asset_id = asset.id
            img.save!
          end
          render status: 201
          # render layout: false, status: 201
          # respond_with(@image, status: 201, default_template: :index)
        else
          render json: { errors: 'Failed to save Image' }, status: 422
          # respond_with(@image, status: 422, default_template: :index)
        end
      end
    end

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

    def image_params
      params.require(:image).permit(permitted_image_attributes)
    end

    def digital_asset_params
      params.require(:image).permit(
        :digital_asset_id
      )
    end

    def spree_folder
      if current_folder.present?
        current_folder
      else
        Spree::Folder.find_or_create_by(name: "Product Images")
      end
    end

    def current_folder
      id = params.dig(:image, :folder_id) || params.dig(:folder_id)
      @current_folder ||= Spree::Folder.find_by(id: id)
    end

    def scope
      if params[:product_id]
        Spree::Product.friendly.find(params[:product_id])
      elsif params[:variant_id]
        Spree::Variant.find(params[:variant_id])
      end
    end
end
