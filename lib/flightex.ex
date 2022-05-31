defmodule Flightex do
  @moduledoc """
  Flight booking/reservation application.
  Registration of users and registration of flight bookings for a user.
  """

  alias Flightex.Bookings.Agent, as: BookingsAgent
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking
   alias Flightex.Bookings.Report, as: BookingsReport
  alias Flightex.Users.Agent, as: UsersAgent
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUser

  def start_agents do
    UsersAgent.start_link()
    BookingsAgent.start_link()
  end


  defdelegate create_user(params),
    to: CreateOrUpdateUser,
    as: :call


  defdelegate create_booking(user_uuid, params),
    to: CreateOrUpdateBooking,
    as: :call


  defdelegate get_booking(booking_id),
    to: BookingsAgent,
    as: :get

    defdelegate generate_report(from_date, to_date, file_name \\ "report.csv"),
    to: BookingsReport,
    as: :build
end
