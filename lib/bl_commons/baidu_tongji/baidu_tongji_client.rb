# frozen_string_literal: true

require 'httparty'

module BlCommons
  module BaiduTongji
    class BaiduTongjiClient
      include HTTParty
      base_uri "https://api.baidu.com/json/tongji/v1/ReportService/getData"
      headers "Content-Type" => "application/json"

      class << self
        # site_id: 百度应用id
        # api_method: 要查询的统计报告路径，即接口方法
        # params: 根据实际情况调整请求参数，例如查询时间、排序、分页等
        # read more: https://tongji.baidu.com/api/manual/Chapter1/getData.html
        def get_data(site_id, api_method, params = {})
          response = self.post "", body: generate_params_for(site_id, api_method, params).to_json

          response.body
        end

        def generate_params_for(site_id, api_method, params)
          {
            header: BlCommons::BaiduTongji.request_header_params,
            body: {
              "siteId": site_id,
              "method": api_method,
              "start_date": Time.current.strftime("%Y%m%d"),
              "end_date": Time.current.strftime("%Y%m%d"),
              "metrics": "pv_count,visitor_count"
            }.merge(params)
          }
        end
      end
    end
  end
end
