defmodule Flightex.Bookings.CreateOrUpdate do
  @moduledoc false

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.Booking
  alias Flightex.Users.Agent, as: UsersAgent

  @all_fields_message "Inform all fields: user_uuid, %{complete_date: value, local_origin: value, local_destination: value}"

  def call(user_uuid, %{} = booking_params) do
    with {:ok, _user} <- UsersAgent.get_by_id(user_uuid),
         {:ok, %Booking{} = booking} <- build_booking(user_uuid, booking_params) do
      BookingsAgent.save(booking)
    else
      error -> error
    end
  end

  def call(_user_uuid, _any) do
    {:error, @all_fields_message}
  end

  defp build_booking(user_uuid, %{
         complete_date: complete_date,
         local_origin: local_origin,
         local_destination: local_destination
       }) do
    Booking.build(complete_date, local_origin, local_destination, user_uuid)
  end

  defp build_booking(_user_uuid, _any) do
    {:error, @all_fields_message}
  end
end
