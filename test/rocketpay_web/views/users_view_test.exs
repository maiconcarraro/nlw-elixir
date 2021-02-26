defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  import Phoenix.View

  test "renders create.json" do
    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      valid_user_params()
      |> Rocketpay.create_user()

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created",
      user: %{
        account: %{
          balance: Decimal.new("0.00"),
          id: account_id
        },
        id: user_id,
        name: "Maicon",
        nickname: "maicon"
      }
    }

    assert expected_response == response
  end
end
