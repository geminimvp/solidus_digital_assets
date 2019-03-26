module Spree
  module Admin

    class DigitalAssetsController < ResourceController

      before_action :filter_digital_assets_by_folder, :current_folder_children, :build_digital_asset, only: :index

      def index
        @digital_assets = @digital_assets.includes(assets: { viewable: :product }).order(created_at: :desc).page(params[:page])
        render 'view_more' if params[:view_more].present?
      end

      def create
        @object.assign_attributes(permitted_resource_params)
        if @object.folder.nil?
          @object.folder = spree_folder
        end
        if @object.save
          if params[:image] && image_params.present?
            Spree::Image.create(image_params).tap do |img|
              img.digital_asset_id = @object.id
              img.save!
            end
          end
          render layout: false
        else
          render json: { errors: @object.errors.full_messages.to_sentence }, status: 422
        end
      end

      def destroy
        @object.destroy
        redirect_to action: :index, folder_id: @object.folder_id
      end

      private

        def image_params
          params.require(:image).permit(permitted_resource_params)
        end

        def filter_digital_assets_by_folder
          @digital_assets = @digital_assets.where(folder: current_folder)
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

        def current_folder_children
          @current_folder_children = current_folder.try(:children) || Spree::Folder.where(parent_id: nil)
        end

        def build_digital_asset
          @digital_asset = Spree::DigitalAsset.new(folder_id: @current_folder.try(:id))
        end

        def location_after_save
          collection_url(folder_id: @digital_asset.folder_id)
        end

        def location_after_destroy
          collection_url(folder_id: @digital_asset.folder_id)
        end

    end

  end
end
