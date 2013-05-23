class OperationsController < ApplicationController
  def index
    @operations = Operation.order('id desc').page params[:page]
  end
end
