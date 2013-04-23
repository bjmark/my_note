class OperationsController < ApplicationController
  def index
    @operations = Operation.order('id desc').limit(100)
  end
end
