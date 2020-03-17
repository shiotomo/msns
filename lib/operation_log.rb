require_relative './common/mysql_client'
require_relative './common/time_converter'

class OperationLog
  ERROR_MESSAGE = {status: "Invalid date format."}

  class << self
    # 全operation_logを取得する
    def get_operation_log(date)
      return date == nil ? get_operation_log_all() : get_operation_log_where_date(date)
    end

    def get_operation_log_all
      client = MysqlClient.new
      query = "SELECT id, caused_at, level, log, created_at FROM operation_log"
      result = client.run_query(query)
      result_list = []
      result.each do |entry|
        result_list.push(entry)
      end
      return result_list
    end

    def get_operation_log_where_date(date)
      return ERROR_MESSAGE unless TimeConverter.is_mysql_time_stamp(date) 
      client = MysqlClient.new
      query = "SELECT id, caused_at, level, log, created_at FROM operation_log where created_at >= '#{date}'"
      result = client.run_query(query)
      result_list = []
      result.each do |entry|
        result_list.push(entry)
      end
      return result_list
    end
  end
end