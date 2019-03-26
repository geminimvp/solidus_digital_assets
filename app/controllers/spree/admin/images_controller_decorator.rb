Spree::Admin::ImagesController.class_eval do
  before_action :load_folder_and_digital_assets, only: [:new, :edit, :create, :update, :index]

  def create
    if digital_asset_params[:digital_asset_id].present?
      # user is adding an image using an existing DigitalAsset
      asset_variant = Spree::AssetVariant.find_or_initialize_by(image_id: asset.id, variant_id: variant.id)
      if asset_variant.save!
        redirect_back(fallback_location: root_path)
      else
        redirect_back(fallback_location: root_path, status: 422)
      end
    else
      # user is uploading a new image
      save_and_create_digital_asset
    end
  end

  private

    def save_and_create_digital_asset
      @digital_asset = Spree::DigitalAsset.new(image_params).tap do |digital_asset|
        digital_asset.folder ||= Spree::Folder.product_images_folder
        if digital_asset.save!
          @image = scope.images.create(image_params).tap do |img|
            # img.type = "Spree::DigitalAsset"
            img.digital_asset_id = digital_asset.id
            img.save!
          end
          render status: 201
        else
          render json: { errors: 'Failed to save Image' }, status: 422
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

    def asset
      @asset ||= Spree::Asset.find_by(digital_asset_id: digital_asset_params[:digital_asset_id])
    end

    def variant
      @variant ||= Spree::Variant.find_by(product: product)
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
        Spree::Folder.product_images_folder
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
