# frozen_string_literal: true

module BlCommons
  class ResourcesController < ActionController::API
    include ActionController::HttpAuthentication::Digest::ControllerMethods

    before_action :set_header_locale

    before_action :authenticate

    def index
      collection = model.ransack(params[:q]).result.page(page).per(per_page).includes(params[:includes])

      render json: collection.map { |o| parse_resource(o) }
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    def show
      render json: parse_resource(model.find(params[:id]))
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    def create
      object = model.new(params['resource_params'].permit!)

      if object.save
        render json: parse_resource(object)
      else
        render json: { error_message: object.errors.full_messages.join(',') }
      end
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    def update
      object = model.find(params[:id])

      if object.update(params['resource_params'].permit!)
        render json: parse_resource(object)
      else
        render json: { error_message: object.errors.full_messages.join(',') }
      end
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    def destroy
      object = model.find(params[:id])

      if object.destroy
        render json: parse_resource(object)
      else
        render json: { error_message: object.errors.full_messages.join(',') }
      end
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    def sync
      grfk = "#{model.model_name.singular}_id"
      object = model.find_by(grfk.to_s => params.dig(grfk))

      # 如果没找到资源则触发 job
      unless object
        BlCommons::PublishMissingResourceJob.perform_later(params[:resource_name], params.to_unsafe_h)
        render(json: {}) && return
      end

      BlCommons::BlResources.set_attributes(object, params['resource_params'])

      if object.save
        render json: parse_resource(object)
      else
        render json: { error_message: object.errors.full_messages.join(',') }
      end
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    def batch_sync
      grfk = "#{model.model_name.singular}_id"

      params[:collection].each do |item|
        object = model.find_by(grfk.to_s => item.dig(grfk))

        # 如果没找到资源则触发 job
        unless object
          BlCommons::PublishMissingResourceJob.perform_later(params[:resource_name], item.to_unsafe_h)

          next
        end

        BlCommons::BlResources.set_attributes(object, item['resource_params'])

        object.save
      end

      render json: {}
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    def require_sync
      collection = model.ransack(params[:q]).result
      collection.bl_sync_resources

      render json: {}
    end

    private

    def authenticate
      authenticate_or_request_with_http_digest(BlCommons::BlResources.auth_realm) do |username|
        BlCommons::BlResources.auth_username == username &&
          BlCommons::BlResources.auth_password
      end
    end

    def set_header_locale
      I18n.locale = request.headers['Locale'] if request.headers['Locale']
    end

    def page
      params[:page] || 1
    end

    def per_page
      params[:per_page] || 10
    end

    def model
      @model ||= params[:resource_name].singularize.camelize.constantize
    end

    def parse_resource(object)
      result = filter(object)
      (params[:includes] || []).each do |key|
        result[key] = filter(object.send(key))
      end
      result
    end

    def attributes(object)
      case params[:attributes]
      when String
        [params[:attributes]]
      when Array
        params[:attributes]
      when ActionController::Parameters
        params[:attributes][object.model_name.singular] || ['id']
      else
        ['id']
      end
    end

    def filter(object)
      return nil unless object

      attributes(object).reduce({}) do |memo, attribute|
        memo[attribute] = object.send(attribute).to_yaml

        memo
      end
    end
  end
end
