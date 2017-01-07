class Camaspreehelperroutes
  def self.update_helper_routes
    _routes = ['cama_profile', 'cama_search', 'cama_post_of_posttype', 'cama_save_comment', 'cama_save_form', 'cama_post_type', 'cama_hierarchy_post', 'cama_post_tag', 'cama_post', 'cama_root', 'cama_admin', 'cama_admin_dashboard']
    _routes += Cama::PostType.pluck(:id).map{|id| "cama_post_type_#{id}"}

    _cama_lang_routes = ['cama_category', 'cama_post_of_category', 'cama_post_of_post_type', 'cama_post_type']
    Cama::Site.main_site.get_languages.each{|_l| _cama_lang_routes.each{|_r| _routes << "#{_r}_#{_l}" } }
    _routes.each do |x|
      Spree::BaseHelper.module_eval <<-eoruby, __FILE__, __LINE__ + 1
          def #{x}_url(args=nil)
            Rails.application.routes.url_helpers.#{x}_url(args)
          end

          def #{x}_path(args=nil)
            Rails.application.routes.url_helpers.#{x}_path(args)
          end
      eoruby
    end

    ['edit_cama_admin_post_type_post_tag_url', 'edit_cama_admin_post_type_post_url'].each do |u|
      Spree::BaseHelper.module_eval <<-eoruby, __FILE__, __LINE__ + 1
      def #{u}(pt_id, object, args)
        Rails.application.routes.url_helpers.#{u}(pt_id, object, args)
      end
      eoruby
    end

    ['edit_cama_admin_post_type_category_url', 'edit_cama_admin_settings_post_type_url'].each do |u|
      Spree::BaseHelper.module_eval <<-eoruby, __FILE__, __LINE__ + 1
      def #{u}(id, args)
        Rails.application.routes.url_helpers.#{u}(id, args)
      end
      eoruby
    end
  end
end

Rails.application.config.to_prepare do
  if PluginRoutes.db_installed? && Cama::Site.any?
    Camaspreehelperroutes.update_helper_routes
  end
  PluginRoutes.add_after_reload_routes 'Camaspreehelperroutes.update_helper_routes'
end