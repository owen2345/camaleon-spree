Rails.application.config.to_prepare do
  ########## changes for spree to works with camaleon  ##########
  Spree::UserSessionsController.class_eval do
    private
    def redirect_back_or_default(default)
      redirect_to(cookies[:return_to] || session["spree_user_return_to"] || default)
      session["spree_user_return_to"] = nil
      cookies[:return_to] = nil
    end
  end

  Deface::Override.new(
      virtual_path: 'spree/layouts/admin',
      name: 'cama_admin_iframe_hide_sidebar',
      insert_bottom: '[data-hook="admin_footer_scripts"]',
      text: '<script>
               jQuery(function(){
                  if(window.location != window.parent.location){ $("#wrapper").addClass("sidebar-minimized"); $("#main-part").css({"margin-left": 0, "padding-left": "35px"}); $("#main-sidebar").hide(); }
               })
            </script>'
  )

  Deface::Override.new(
      virtual_path: 'spree/admin/products/_form',
      name: 'cama_custom_fields',
      insert_bottom: '[data-hook="admin_product_form_additional_fields"]',
      partial: '/plugins/camaleon_spree/admin/render_custom_fields_product'
  )
  Deface::Override.new(
      virtual_path: 'spree/admin/products/new',
      name: 'cama_custom_fields_on_create',
      insert_bottom: '[data-hook="new_product_attrs"]',
      partial: '/plugins/camaleon_spree/admin/render_custom_fields_product'
  )

  # spree product add custom fields support
  Spree::Product.class_eval do
    include CamaleonCms::Metas
    include CamaleonCms::CustomFieldsRead
    include CamaleonCms::CustomFieldsConcern
    def get_field_groups(args = {}) # needs to fix for multisite&multistore support
      CamaleonCms::CustomFieldGroup.where(object_class: self.class.name)
    end

  end


  Spree::Admin::ProductsController.class_eval do
    create.after :save_custom_fields
    update.after :save_custom_fields

    private
    def save_custom_fields
      @object.set_field_values(params[:field_options])
    end
  end

  # redirect to cama dashboard
  # Spree::Admin::RootController.class_eval do
  #   def index
  #     redirect_to Rails.application.routes.url_helpers.cama_admin_dashboard_path
  #   end
  # end
end