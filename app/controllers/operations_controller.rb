class OperationsController < ApplicationController
  def index
    op = params[:operation]
    op_kind = ['all','create','update','destroy']
    op = 'all' if !op_kind.include?(op)
    
    @op_filter = {}
    op_kind.each {|e| @op_filter[e] = (e == op) }

    @operations = Operation.operation(op).bdate(params[:bdate]).edate(params[:edate]).order('id desc').page(params[:page])
  end
end
