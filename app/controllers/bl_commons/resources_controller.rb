# frozen_string_literal: true

module BlCommons
  class ResourcesController < ActionController::API
    # TODO: 鉴权
    def index
      collection = model.ransack(params[:q]).result.page(page).per(per_page).includes(params[:includes])

      render json: collection.map { |o| parse_resource(o) }
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    # TODO: 鉴权
    def show
      render json: parse_resource(model.find(params[:id]))
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    # TODO: 鉴权
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

    # TODO: 鉴权
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

    # TODO: 鉴权
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

    # TODO: 鉴权
    def sync
      grfk = "#{model.model_name.singular}_id"
      object = model.find_or_initialize_by(grfk.to_s => params.dig(grfk))

      if object.update(params['resource_params'].permit!)
        render json: parse_resource(object)
      else
        render json: { error_message: object.errors.full_messages.join(',') }
      end
    rescue StandardError => e
      render json: { error_message: e.message }
    end

    private

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
