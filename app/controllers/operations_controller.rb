class OperationsController < ApplicationController
  def index
    @operations = Operation.order('id desc').page params[:page]
    @op_filter = {'all'=>}
  end
end
