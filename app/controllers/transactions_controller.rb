class TransactionsController < ApplicationController

    before_action :set_account

    def index
        @transactions = @account.transactions
        render json: @transactions
    end

    def create
        @transaction = @account.transactions.new(transaction_params)
        if @account.update_balance(@transaction) != "Balance too low!"
            @transaction.save
            render json: @account
        else
            render json: {error: "Balance too low!"}
        end
    end

    def show
        @transaction = Transaction.find(params[:id])
        render json: @transaction
    end
    
    def destroy
        @transaction = Transaction.find(params["id"])
        @account = Account.find(@transaction.account_id)
        if @account.update_balance_on_delete(@transaction)
            @transaction.destroy
            render json: @account
        else
            render json: {error: "Transaction not deleted!"}
        end
    end

    private

    def set_account
        @account = Account.find(params[:account_id])
    end

    def transaction_params
        params.require(:transaction).permit(:account_id, :amount, :kind, :date, :description)
    end

end
