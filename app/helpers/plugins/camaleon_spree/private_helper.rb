module Plugins::CamaleonSpree::PrivateHelper
  # custom field of products and categories
  def camaleon_spree_custom_fields(args)
    args[:fields][:spree_products] = {
        key: 'spree_products',
        label: 'Spree Products',
        render: plugin_view('admin/custom_field/spree_products.html.erb'),
        options: {
            required: true,
            multiple: true,
        }
    }

    args[:fields][:spree_categories] = {
        key: 'spree_categories',
        label: 'Spree Categories',
        render: plugin_view('admin/custom_field/spree_categories.html.erb'),
        options: {
            required: true,
            multiple: true,
        }
    }
  end

  # custom fields support for Spree Products
  def camaleon_spree_custom_field_models(args)
    args[:models] << Spree::Product
  end
end
