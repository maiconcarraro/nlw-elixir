defmodule RocketpayWeb.AccountsControllerTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{User, Account}

  describe "deposit/2" do
    setup %{conn: conn} do
      {:ok, %User{account: %Account{id: account_id}}} =
        valid_user_params()
        |> Rocketpay.create_user()

      conn = add_basic_auth(conn)

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

      assert %{"message" => "Invalid deposit value!"} = response
    end
  end

  describe "withdraw/2" do
    setup %{conn: conn} do
      {:ok, %User{account: %Account{id: account_id}}} =
        valid_user_params()
        |> Rocketpay.create_user()

      %{"id" => account_id, "value" => "50.00"}
      |> Rocketpay.deposit()

      conn = add_basic_auth(conn)

      {:ok, conn: conn, account_id: account_id}
    end

    test "when all params are valid, returns a withdraw", %{conn: conn, account_id: account_id} do
      params = %{"value" => "25.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:ok)

      assert %{
               "account" => %{"balance" => "25.00", "id" => _id},
               "message" => "Balance changed successfully"
             } = response
    end

    test "when there are invalid params, returns an error", %{conn: conn, account_id: account_id} do
      params = %{"value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :withdraw, account_id, params))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid withdraw value!"} = response
    end
  end

  describe "transaction/2" do
    setup %{conn: conn} do
      {:ok, %User{account: %Account{id: from_id}}} =
        valid_user_params()
        |> Rocketpay.create_user()

      {:ok, %User{account: %Account{id: to_id}}} =
        valid_user_params()
        |> Map.put(:nickname, "different")
        |> Map.put(:email, "different@teste.com")
        |> Rocketpay.create_user()

      %{"id" => from_id, "value" => "50.00"}
      |> Rocketpay.deposit()

      conn = add_basic_auth(conn)

      {:ok, conn: conn, from_id: from_id, to_id: to_id}
    end

    test "when all params are valid, returns a withdraw", %{
      conn: conn,
      from_id: from_id,
      to_id: to_id
    } do
      params = %{"from" => from_id, "to" => to_id, "value" => "25.00"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:ok)

      expected_response = %{
        "message" => "Transaction done successfully",
        "transaction" => %{
          "from_account" => %{
            "balance" => "25.00",
            "id" => from_id
          },
          "to_account" => %{
            "balance" => "25.00",
            "id" => to_id
          }
        }
      }

      assert expected_response == response
    end

    test "when there are invalid params, returns an error", %{
      conn: conn,
      from_id: from_id,
      to_id: to_id
    } do
      params = %{"from" => from_id, "to" => to_id, "value" => "banana"}

      response =
        conn
        |> post(Routes.accounts_path(conn, :transaction, params))
        |> json_response(:bad_request)

      assert %{"message" => "Invalid withdraw value!"} = response
    end
  end

  defp add_basic_auth(conn),
    do: put_req_header(conn, "authorization", "Basic YmFuYW5hOm5hbmljYTEyMw==")
end
