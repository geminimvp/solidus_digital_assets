Spree::Image.class_eval do

  belongs_to :digital_asset

  private

  def attachment_accepted?
    no_attachment_errors
  end
end
