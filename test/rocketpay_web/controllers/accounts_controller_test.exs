defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{User, Account}

  describe "deposit/2" do
    setup %{conn: conn} do
      params = %{
        name: "Maicon",
        password: "123456",
        nickname: "maicon",
        email: "maicon@teste.com",
        age: 27
      }

      {:ok, %User{account: %Account{id: account_id}}} = Rocketpay.create_user(params)

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
