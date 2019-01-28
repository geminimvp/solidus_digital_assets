Deface::Override.new(virtual_path: 'spree/admin/images/index',
  name: 'add_assets_to_product_images',
  insert_bottom: "#images-table",
  partial: 'spree/admin/digital_assets/show_assets',
  original: '8b0c556c850177cc2ff79ea5a18210014076d8b1')
