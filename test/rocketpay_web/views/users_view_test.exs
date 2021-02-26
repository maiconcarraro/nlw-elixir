defmodule RocketpayWeb.UsersViewTest do
  use RocketpayWeb.ConnCase, async: true

  alias Rocketpay.{Account, User}
  alias RocketpayWeb.UsersView

  import Phoenix.View

  test "renders create.json" do
    params = %{
      name: "Maicon",
      password: "123456",
      nickname: "maicon",
      email: "maicon@teste.com",
      age: 27
    }

    {:ok, %User{id: user_id, account: %Account{id: account_id}} = user} =
      Rocketpay.create_user(params)

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
