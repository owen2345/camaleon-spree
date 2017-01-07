class CamaleonCms::PostDecorator < CamaleonCms::ApplicationDecorator
  include CamaleonCms::CustomFieldsConcern
  delegate_all
end