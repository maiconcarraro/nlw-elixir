defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{User, Account}

  describe "deposit/2" do
    setup %{conn: conn} do
      {:ok, %User{account: %Account{id: account_id}}} =
        valid_user_params()
        |> Rocketpay.create_user()

      conn = put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, returns a deposit", %{conn: conn, account_id: account_id} do
      params = %{"value" => "50.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "50.00", "id" => _id},
               "message" => "Balance changed successfully"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :deposit, account_id, params))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid withdraw value!"} = response
    end
  end
end
