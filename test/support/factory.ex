defmodule Rocketpay.Factory do
  def valid_user_params() do
    %{
      name: "Maicon",
      password: "123456",
      nickname: "maicon",
      email: "maicon@teste.com",
      age: 27
    }
  end

  def invalid_user_params() do
    %{
      name: "Maicon",
      nickname: "maicon",
      email: "maicon@teste.com",
      age: 15
    }
  end
end
