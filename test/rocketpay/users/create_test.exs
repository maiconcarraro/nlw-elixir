defmodule Rocketpay.Users.CreateTest do
  use Rocketpay.DataCase, async: true

  import Rocketpay.Factory

  alias Rocketpay.{User, Repo}

  describe "call/1" do
    test "when all params are valid, returns an user" do
      {:ok, %User{id: user_id}} =
        valid_user_params()
        |> Rocketpay.create_user()

      user = Repo.get(User, user_id)

      assert %User{name: "Maicon", age: 27, id: ^user_id} = user
    end

    test "when there are invalid params, returns an error" do
      {:error, changeset} =
        invalid_user_params()
        |> Rocketpay.create_user()

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        password: ["can't be blank"]
      }

      assert errors_on(changeset) == expected_response
    end
  end
end
