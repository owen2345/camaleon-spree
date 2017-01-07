Rails.application.routes.draw do

    scope PluginRoutes.system_info["relative_url_root"] do
      #Admin Panel
      scope :admin, as: 'admin', path: PluginRoutes.system_info['admin_path_name'] do
        namespace 'plugins' do
          namespace 'camaleon_spree' do
            controller :admin do
              get :settings
              post :save_settings
            end
          end
        end
      end

      # main routes
      #scope 'nico_chale', module: 'plugins/nico_chale/', as: 'nico_chale' do
      #  Here my routes for main routes
      #end
    end
  end
