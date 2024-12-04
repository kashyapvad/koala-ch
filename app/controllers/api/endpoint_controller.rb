class Api::EndpointController < ApplicationController
  #include Api::V1::Concerns::ErrorHandling

  # This is a wrapper around the controllers to share common functionality.

  before_action :require_member_access_token!, if: :member_access_token_required? # defaulted to false in this case
  before_action :set_resource_name
  before_action :set_resource_klass
  before_action :set_item, only: [:show, :update]


  def collection_scope()     nil end
  def item_scope()           collection_scope end

  def resource_name
    klass.name.underscore
  end

  def show
    render_item
  end

  def update_item
    @item.update update_attributes
  end

  def update
    render_item if update_item
  end

  def render_item
    decorate_item
    render :item
  end

  def render_trigger
    type = params[:type]
    render type
  end

  def decorate_item
  end

  def set_resource_name
    @resource_name = resource_name
  end

  def set_resource_klass
    @klass = klass
  end

  def set_item()
    @item = item_scope.find params[:id]
  end

  def item
    @item ||= set_item
  end

  def set_item_id
    @item_id ||= item.id.to_s if item.present? and item.id.present?
  end

  def collection
    @collection ||= set_collection
  end

  def trigger_on_member
    type = params[:type]
    data = trigger_params[:data]
    handler = "on_#{type}"
    send handler, data
    mark_member_action! type
    render_trigger
  end
  
  def trigger_on_collection
    type = params[:type]
    data = trigger_params[:data]
    handler = "on_#{type}"
    send handler, data
    render_trigger
  end

  def trigger_params
    params.require(:event).permit data: {}
  end 

  def update_attributes() attributes_to_assign end

  def attributes_to_assign() strong_params end

  protected

  def resource_name
    klass.name.underscore
  end

  def set_resource_name
    @resource_name = resource_name
  end
end 