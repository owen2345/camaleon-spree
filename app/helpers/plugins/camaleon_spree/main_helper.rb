module Plugins::CamaleonSpree::MainHelper
  include Plugins::CamaleonSpree::PrivateHelper
  def self.included(klass)
    # klass.helper_method [:my_helper_method] rescue "" # here your methods accessible from views
  end

  # fix to avoid missing route for https://github.com/spree-contrib/spree_tax_cloud
  def edit_admin_tax_cloud_settings_path
    spree.edit_admin_tax_cloud_settings_path
  end

  # here all actions on going to active
  # you can run sql commands like this:
  # results = ActiveRecord::Base.connection.execute(query);
  # plugin: plugin model
  def camaleon_spree_on_active(plugin)
    current_plugin.set_option('camaleon_cms_layout', 'spree/layouts/spree_application')
  end

  # here all actions on going to inactive
  # plugin: plugin model
  def camaleon_spree_on_inactive(plugin)
  end

  def camaleon_spree_front_default_layout(args)
    args[:layout] = current_plugin.get_option('camaleon_cms_layout') if current_plugin.get_option('camaleon_cms_layout').present?
  end

  # permit to show spree products and taxonomies in admin->menus (camaleon cms)
  def camaleon_spree_cama_nav_menus(args)
    # Groups
    Spree::Taxonomy.all.each do |taxonomy|
      args[:custom_menus]["spree_menus"] = {link: "", title: "Spree #{taxonomy.name.pluralize}"}
      taxonomy.taxons.each do |taxon|
        args[:custom_menus]["spree_tax_#{taxon.id}"] = {link: spree.nested_taxons_path(taxon.permalink), title: taxon.name, kind: 'Spree::Taxon', id: taxon.id}
      end
    end

    # Products
    args[:custom_menus]["spree_menus_products"] = {link: "", title: "Spree Products"}
    Spree::Product.reorder(name: :ASC).all.each do |product|
      args[:custom_menus]["spree_product_#{product.id}"] = {link: spree.product_path(product), title: product.name, kind: 'Spree::Product', id: product.id}
    end
  end

  # permit to show spree products and taxonomies in admin->menus (camaleon cms)
  def camaleon_spree_on_parse_custom_menu_item(args)
    if args[:menu_item].kind == 'Spree::Taxon'
      taxon = Spree::Taxon.find(args[:menu_item].url)
      res = {name: taxon.name, link: spree.nested_taxons_path(taxon.permalink)}
      res[:current] = site_current_path == res[:link] unless args[:is_from_backend]
      args[:parsed_menu] = res
    end

    if args[:menu_item].kind == 'Spree::Product'
      product = Spree::Product.find(args[:menu_item].url)
      res = {name: product.name, link: spree.product_path(product)}
      res[:current] = site_current_path == res[:link] unless args[:is_from_backend]
      args[:parsed_menu] = res
    end
  end

  # here all actions to upgrade for a new version
  # plugin: plugin model
  def camaleon_spree_on_upgrade(plugin)
  end

  def camaleon_spree_on_plugin_options(args)
    args[:links] << link_to('Settings', admin_plugins_camaleon_spree_settings_path)
  end

  # add spree role action for camaleon user group permissions
  def camaleon_spree_user_roles_hook(args)
    args[:roles_list][:manager] << { key: 'spree_role', label: t('plugins.spree_cama.admin.roles.label', default: 'Spree Ecommerce'), description: t('plugins.spree_cama.admin.roles.descr', default: 'Manage all sections of Spree Ecommerce')}
  end

  # render spree menu item added on admin->menus (camaleon cms)
  def camaleon_spree_on_render_front_menu_item(args)
    if args[:parsed_menu] !=  false && args[:menu_item].kind == 'external' && args[:parsed_menu][:current] == false
      args[:parsed_menu][:current] = URI::parse(site_current_url).path == args[:parsed_menu][:link]
    end
  end
end
