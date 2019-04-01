Spree::Image.class_eval do

  belongs_to :digital_asset

  def viewable
    variants.first || Spree::Variant.new
  end

  private

  def attachment_accepted?
    no_attachment_errors
  end
end
