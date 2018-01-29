class ReportsController < ApplicationController
  def show
    @report = Report.find(params[:id])
    @result = @report.exec_query
  end

  def new
    @report = Report.new
  end

  def edit
    @report = Report.find(params[:id])
  end
end
