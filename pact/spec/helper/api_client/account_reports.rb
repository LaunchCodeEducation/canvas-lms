#
# Copyright (C) 2018 - present Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.

require 'httparty'
require 'json'
require_relative '../../../pact_config'

module Helper
  module ApiClient
    class AccountReports
      include HTTParty
      base_uri PactConfig.mock_provider_service_base_uri
      headers "Authorization" => "Bearer some_token"

      def list_reports(account_id)
        JSON.parse(self.class.get("/api/v1/accounts/#{account_id}/reports").body)
      rescue
        nil
      end

      def show_report(account_id, report_type, report_id)
        JSON.parse(self.class.get("/api/v1/accounts/#{account_id}/reports/#{report_type}/#{report_id}"))
      rescue
        nil
      end
    end
  end
end