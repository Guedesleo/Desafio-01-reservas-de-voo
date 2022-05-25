defmodule Flightex.Bookings.Booking do
  @moduledoc false

  @message_all_fields "All fields must be informed: complete_date, local_origin, local_destination, user_id"

  @keys [:complete_date, :local_origin, :local_destination, :user_id, :id]

  @enforce_keys @keys

  defstruct @keys

  def build(complete_date, local_origin, local_destination, user_id) do
    id = UUID.uuid4()

    complete_date = parse_br_date_to_naive(complete_date)

    {:ok,
     %__MODULE__{
       complete_date: complete_date,
       local_origin: local_origin,
       local_destination: local_destination,
       user_id: user_id,
       id: id
     }}
  end

  def build(_, _, _), do: {:error, @message_all_fields}

  def build(_, _), do: {:error, @message_all_fields}

  def build(_), do: {:error, @message_all_fields}

  def build, do: {:error, @message_all_fields}

  defp parse_br_date_to_naive(complete_date_br) do
    [day, month, year] = String.split(complete_date_br, "/", trim: true)

    day = String.to_integer(day)
    month = String.to_integer(month)
    year = String.to_integer(year)

    NaiveDateTime.new!(year, month, day, 0, 0, 0)
  end
end
