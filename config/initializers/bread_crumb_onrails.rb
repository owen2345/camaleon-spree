Rails.application.config.to_prepare do
  module BreadcrumbsOnRails
    module ActionController
      module HelperMethods
        def render_breadcrumbs(options = {}, &block)
          builder = (options.delete(:builder) || Breadcrumbs::SimpleBuilder).new(self, @breadcrumbs, options)
          content = builder.render.html_safe
          if block_given?
            capture(content, &block)
          else
            content
          end
        end

      end
    end
  end
end