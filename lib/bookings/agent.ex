defmodule Flightex.Bookings.Agent do

  use Agent

  alias Flightex.Bookings.Booking

  def start_link(initial_value \\ %{}) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def save(%Booking{id: id} = booking) do
    Agent.update(__MODULE__, fn state -> update_booking(state, booking) end)

    {:ok, id}
  end

  def get(booking_id) do
    Agent.get(__MODULE__, fn state -> get_booking(state, booking_id) end)
  end

  def get_all do
    Agent.get(__MODULE__, & &1)
  end

  def get_all_by_date(from_date, to_date) do
    Agent.get(__MODULE__, fn bookings -> filter_dates(bookings, from_date, to_date) end)
  end

  defp filter_dates(%{} = bookings, from_date, to_date) do
    from_date = string_to_date(from_date)
    to_date = string_to_date(to_date)

    bookings
    |> Map.values()
    |> Enum.filter(fn booking -> compare_dates(booking.complete_date, from_date, to_date) end)
  end

  defp compare_dates(booking_date, from_date, to_date) do
    booking_date = NaiveDateTime.to_date(booking_date)

    from_date
    |> Date.range(to_date)
    |> Enum.member?(booking_date)
  end

  defp string_to_date(string_date) do
    [day, month, year] = String.split(string_date, "/", trim: true)

    year = String.to_integer(year)
    month = String.to_integer(month)
    day = String.to_integer(day)

    {:ok, date} = Date.new(year, month, day)

    date
  end


  defp update_booking(state, %Booking{id: id} = booking) do
    Map.put(state, id, booking)
  end

  defp get_booking(state, booking_id) do
    case Map.get(state, booking_id) do
      nil -> {:error, "Flight Booking not found!"}
      booking -> {:ok, booking}
    end
  end
end
