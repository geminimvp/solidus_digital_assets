[1mdiff --git a/app/controllers/spree/admin/digital_assets_controller.rb b/app/controllers/spree/admin/digital_assets_controller.rb[m
[1mindex bc1a915..f7ae3af 100755[m
[1m--- a/app/controllers/spree/admin/digital_assets_controller.rb[m
[1m+++ b/app/controllers/spree/admin/digital_assets_controller.rb[m
[36m@@ -18,7 +18,7 @@[m [mmodule Spree[m
         if @object.save[m
           if params[:image] && image_params.present?[m
             Spree::Image.create(image_params).tap do |img|[m
[31m-              img.type = "Spree::DigitalAsset"[m
[32m+[m[32m              # img.type = "Spree::DigitalAsset"[m
               img.digital_asset_id = @object.id[m
               img.save![m
             end[m
[1mdiff --git a/app/controllers/spree/admin/images_controller_decorator.rb b/app/controllers/spree/admin/images_controller_decorator.rb[m
[1mindex 728491b..87b5457 100644[m
[1m--- a/app/controllers/spree/admin/images_controller_decorator.rb[m
[1m+++ b/app/controllers/spree/admin/images_controller_decorator.rb[m
[36m@@ -19,12 +19,12 @@[m [mSpree::Admin::ImagesController.class_eval do[m
   private[m
 [m
     def save_and_create_digital_asset[m
[31m-      @digital_asset = Spree::DigitalAsset.new(image_params).tap do |asset|[m
[31m-        asset.folder ||= Spree::Folder.product_images_folder[m
[31m-        if asset.save![m
[32m+[m[32m      @digital_asset = Spree::DigitalAsset.new(image_params).tap do |digital_asset|[m
[32m+[m[32m        digital_asset.folder ||= Spree::Folder.product_images_folder[m
[32m+[m[32m        if digital_asset.save![m
           @image = scope.images.create(image_params).tap do |img|[m
[31m-            img.type = "Spree::DigitalAsset"[m
[31m-            img.digital_asset_id = asset.id[m
[32m+[m[32m            # img.type = "Spree::DigitalAsset"[m
[32m+[m[32m            img.digital_asset_id = digital_asset.id[m
             img.save![m
           end[m
           render status: 201[m
[1mdiff --git a/app/models/spree/digital_asset.rb b/app/models/spree/digital_asset.rb[m
[1mindex 96401a1..2b384bd 100755[m
[1m--- a/app/models/spree/digital_asset.rb[m
[1m+++ b/app/models/spree/digital_asset.rb[m
[36m@@ -24,7 +24,7 @@[m [mmodule Spree[m
 [m
     before_post_process :image?[m
     before_validation :assign_default_name, on: :create[m
[31m-    before_validation :assign_default_type, on: :create[m
[32m+[m[32m    # before_validation :assign_default_type, on: :create[m
     before_validation :assign_default_position, on: :create[m
 [m
     private[m
[36m@@ -33,15 +33,19 @@[m [mmodule Spree[m
       end[m
 [m
       def assign_default_name[m
[31m-        self.name = File.basename(attachment_file_name.to_s, '.*').titleize.truncate(255) if name.blank?[m
[32m+[m[32m        self.name ||= default_name[m
       end[m
 [m
[31m-      def assign_default_type[m
[31m-        self.type = 'Spree::DigitalAsset'[m
[32m+[m[32m      def default_name[m
[32m+[m[32m        File.basename(attachment_file_name.to_s, '.*').titleize.truncate(255)[m
       end[m
 [m
[32m+[m[32m      # def assign_default_type[m
[32m+[m[32m      #   self.type ||= 'Spree::DigitalAsset'[m
[32m+[m[32m      # end[m
[32m+[m
       def assign_default_position[m
[31m-        self.position = 1[m
[32m+[m[32m        self.position ||= 1[m
       end[m
   end[m
 end[m
[1mdiff --git a/config/locales/en.yml b/config/locales/en.yml[m
[1mindex e14e4a5..13e451f 100644[m
[1m--- a/config/locales/en.yml[m
[1m+++ b/config/locales/en.yml[m
[36m@@ -10,6 +10,10 @@[m [men:[m
       new_sub_folder: "New Sub Folder"[m
       new_folder: "New Folder"[m
     admin:[m
[32m+[m[32m      digital_assets:[m
[32m+[m[32m        content:[m
[32m+[m[32m          choose_files: "Choose Files"[m
[32m+[m[32m          drag_and_drop: "Drag and Drop"[m
       tab:[m
         digital_assets: "Digital Assets"[m
     no_digital_assets_found: No digital assets found[m
[1mdiff --git a/solidus_digital_assets.gemspec b/solidus_digital_assets.gemspec[m
[1mindex 8dabbe9..86cb14f 100644[m
[1m--- a/solidus_digital_assets.gemspec[m
[1m+++ b/solidus_digital_assets.gemspec[m
[36m@@ -24,12 +24,12 @@[m [mGem::Specification.new do |s|[m
   s.add_development_dependency 'rspec-activemodel-mocks'[m
 [m
   s.add_development_dependency 'capybara', '~> 2.5'[m
[31m-  s.add_development_dependency 'coffee-rails'[m
   s.add_development_dependency 'database_cleaner'[m
   s.add_development_dependency 'factory_bot'[m
   s.add_development_dependency 'ffaker',  '~> 2.2.0'[m
   s.add_development_dependency 'rspec_junit_formatter'[m
   s.add_development_dependency 'rspec-rails',  '~> 3.4'[m
[32m+[m[32m  s.add_development_dependency 'rubocop'[m
   s.add_development_dependency 'selenium-webdriver'[m
   s.add_development_dependency 'simplecov'[m
   s.add_development_dependency 'sqlite3', '~> 1.3.6'[m
