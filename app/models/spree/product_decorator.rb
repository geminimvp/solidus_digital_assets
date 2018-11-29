Spree::Product.class_eval do
  def digital_assets
    sql = digital_assets_table
      .project(digital_assets_table[Arel.star])
      .join(spree_assets_table).on(spree_assets_table[:digital_asset_id].eq(digital_assets_table[:id]))
      .join(spree_assets_variants_table).on(spree_assets_variants_table[:image_id].eq(spree_assets_table[:id]))
      .join(variants_table).on(variants_table[:id].eq(spree_assets_variants_table[:variant_id]))
      .join(products_table).on(products_table[:id].eq(variants_table[:product_id]))
      .where(where_self_clause)
      .to_sql

    results = ActiveRecord::Base.connection.exec_query(sql)
    results.map { |result| Spree::DigitalAsset.new(result); }
  end

  def digital_assets_table
    @digital_assets_table ||= Spree::DigitalAsset.arel_table
  end

  def spree_assets_variants_table
    @spree_assets_variants_table ||= Spree::AssetVariant.arel_table
  end

  def spree_assets_table
    @spree_assets_table ||= Spree::Asset.arel_table
  end

  def variants_table
    @variants_table ||= Spree::Variant.arel_table
  end

  def products_table
    @products_table ||= Spree::Product.arel_table
  end

  def where_self_clause
    products_table[:id].eq(self.id)
  end
end
