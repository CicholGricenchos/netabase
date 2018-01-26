class ReportsController < ApplicationController
  def show
    @report = Report.find(params[:id])
    @result = @report.exec_query
  end
end
