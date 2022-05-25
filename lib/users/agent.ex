defmodule Flightex.Users.Agent do
  alias Flightex.Users.User

  use Agent


  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  def get_by_id(id) do
    Agent.get(__MODULE__, fn all_users -> get_user_by_id(all_users, id) end)
  end

  def get_by_cpf(cpf) do
    Agent.get(__MODULE__, fn state -> get_user_by_cpf(state, cpf) end)
  end

  def save(%User{} = user) do
    Agent.update(__MODULE__, fn state -> update_user(state, user) end)

    {:ok, user.id}
  end

  defp update_user(state, %User{cpf: cpf} = user) do
    Map.put(state, cpf, user)
  end

  defp get_user_by_id(state, id) do
    state
    |> Map.values()
    |> Enum.find(fn curr_user_map -> curr_user_map.id == id end)
    |> handle_get_user()
  end

  defp get_user_by_cpf(state, cpf) do
    state
    |> Map.get(cpf)
    |> handle_get_user()
  end

  defp handle_get_user(%User{} = user), do: {:ok, user}
  defp handle_get_user(nil), do: {:error, "User not found!"}
end
