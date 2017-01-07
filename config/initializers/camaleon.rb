Rails.application.config.to_prepare do
  # load basic helpers from spree into camaleon frontend
  CamaleonCms::FrontendController.class_eval do
    include Spree::Core::ControllerHelpers::Order
    include Spree::Core::ControllerHelpers::Auth
    include Spree::Core::ControllerHelpers::Store

    helper Spree::BaseHelper
    helper Spree::StoreHelper
  end

  ########## changes to camaleon to include spree ##########
  CamaleonCms::AdminController.class_eval do
    before_action :set_spree_buttons
    helper_method :current_store

    def current_store
      Spree::Store.current
    end

    private
    def set_spree_buttons
      return if cannot? :manage, :spree_role
      cama_content_prepend("
      <div id=\"tmp_spree_menu\" style=\"display: none\"> #{render_to_string partial: 'spree/admin/shared/main_menu'} </div>
      <script>
      jQuery(function(){
          // spree commerce menus
          $('#sidebar-menu .sidebar-menu').append('<li id=\"spree_commerce_menu\" class=\"treeview\" data-key=\"settings\"> <a href=\"#\"><i class=\"fa fa-shopping-cart\"></i> <span class="">#{t('plugins.spree_cama.admin.menus.ecommerce', default: 'Spree Ecommerce')}</span> <i class=\"fa fa-angle-left pull-right\"></i></a> <ul class=\"treeview-menu\"></ul> </li>');
          var items = $('#tmp_spree_menu').find('.nav-sidebar > .sidebar-menu-item').clone();
          items.find('ul').attr('class', 'treeview-menu').each(function(){ $(this).prev().removeAttr('data-toggle').removeAttr('aria-expanded').append('<i class=\"fa fa-angle-left pull-right\"></i>'); });
          items.find('a').prepend('<i class=\"fa fa-circle-o\"></i>');
          $('#spree_commerce_menu .treeview-menu').html(items);

          // menu spree as iframe
          function spree_load_iframe(url){
              $('#admin_content').html('<iframe style=\"width: 100%; height: 480px; margin-top: -66px;\" frameBorder=\"0\" src=\"'+url+'\">').find('iframe').load(function(){
                  $(this.contentWindow.document.body).css({'padding-bottom': '120px', 'min-height': '500px'});
                  this.style.height = this.contentWindow.document.body.offsetHeight + 15 + 'px';
                  if('history' in window && 'pushState' in history) window.history.pushState({}, '', '#{cama_admin_dashboard_path}?cama_spree_iframe_path='+this.contentWindow.location.href);
              });
          }

          $('#spree_commerce_menu li[data-spree-ecommerce] a, #spree_commerce_menu a').click(function(e){
              if($(this).attr('href').search('#') == 0) return e.preventDefault();
              $(this).closest('li').addClass('active').siblings().removeClass('active');
              spree_load_iframe($(this).attr('href'));
              window.scrollTo(0, 0);
              return false;
          });
          #{"spree_load_iframe('#{params[:cama_spree_iframe_path]}'); $('#spree_commerce_menu > a').click();" if params[:cama_spree_iframe_path].present?}
      }); </script>")
    end
  end

  # update camaleon session routes
  module CamaleonCms::SessionHelper
    def cama_current_user
      @cama_current_user ||= lambda{
        if spree_current_user.try(:id).present?
          spree_current_user.decorate
        end
      }.call
    end

    def cama_admin_login_path
      spree_login_path
    end
    alias_method :cama_admin_login_url, :cama_admin_login_path

    def cama_admin_register_path
      spree_signup_path
    end
    alias_method :cama_admin_register_url, :cama_admin_register_path

    def cama_admin_logout_path
      spree_logout_path
    end
    alias_method :cama_admin_logout_url, :cama_admin_logout_path
  end

  # custom models
  CamaleonCms::User.class_eval do
    alias_attribute :last_login_at, :last_sign_in_at
    alias_attribute :username, :login
    after_create :check_user_role

    has_many :spree_roles, through: :role_users, class_name: 'Spree::Role', source: :role, after_add: :cama_update_roles, after_remove: :cama_update_roles
    def has_spree_role?(role_in_question)
      spree_roles.any? { |role| role.name == role_in_question.to_s } || self.role == role_in_question.to_s
    end

    private
    def check_user_role
      if self.admin?
        Spree::User.find(self.id).spree_roles << Spree::Role.where(name: 'admin').first
      end
    end

    def cama_update_roles(role)
      self.update_column(:role, spree_roles.where(spree_roles: {name: 'admin'}).any? ? 'admin' : 'user')
    end
  end
end
