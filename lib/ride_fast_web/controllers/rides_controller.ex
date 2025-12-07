defmodule RideFastWeb.RidesController do
  use RideFastWeb, :controller

  alias RideFast.Ride
  alias RideFast.Ride.Rides

  action_fallback RideFastWeb.FallbackController

  def index(conn, params) do
    rides = Ride.list_rides(params)
    render(conn, :index, rides: rides)
  end

  def index_histories(conn,  %{"rides_id" => id}) do
    histories = Ride.list_history(id)
    render(conn, :index, histories: histories)
  end

  def create(conn, %{ "origin" => origin, "destination" => destination, "payment_method" => payment_method }) do
    with {:ok, %Rides{} = rides} <- Ride.create_rides(conn.assigns.current_scope, %{
      origin_lat: origin["lat"],
      origin_lng: origin["lng"],
      dest_lat: destination["lat"],
      dest_lng: destination["lng"],
      payment_method: payment_method
    }) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/rides/#{rides}")
      |> render(:show, rides: rides)
    end
  end

  def accept(conn, %{"rides_id" => id, "vehicle_id" => vehicle_id}) do
    rides = Ride.get_rides!(conn.assigns.current_scope, id)

    with {:ok, %Rides{} = rides} <- Ride.accept(conn.assigns.current_scope, rides, vehicle_id) do
      conn
      |> put_resp_header("location", ~p"/api/rides/#{rides}")
      |> render(:show, rides: rides)
    end
  end

  def start(conn, %{"rides_id" => id}) do
    rides = Ride.get_rides!(conn.assigns.current_scope, id)

    with {:ok, %Rides{} = rides} <- Ride.start(conn.assigns.current_scope, rides) do
      conn
      |> put_resp_header("location", ~p"/api/rides/#{rides}")
      |> render(:show, rides: rides)
    end
  end

  def complete(conn, %{"rides_id" => id, "final_price" => final_price}) do
    rides = Ride.get_rides!(conn.assigns.current_scope, id)

    with {:ok, %Rides{} = rides} <- Ride.complete(conn.assigns.current_scope, rides, %{final_price: final_price}) do
      conn
      |> put_resp_header("location", ~p"/api/rides/#{rides}")
      |> render(:show, rides: rides)
    end
  end

  def show(conn, %{"id" => id}) do
    rides = Ride.get_rides!(conn.assigns.current_scope, id)
    render(conn, :show, rides: rides)
  end

  def delete(conn, %{"id" => id, "reason" => cancelation_reason}) do
    rides = Ride.get_rides!(conn.assigns.current_scope, id)

    with {:ok, %Rides{} = ride} <- Ride.delete_rides(conn.assigns.current_scope, rides, %{cancelation_reason: cancelation_reason}) do
      render(conn, :show, rides: ride)
    end
  end

  def delete(conn, %{"rides_id" => id, "reason" => cancelation_reason}) do
    rides = Ride.get_rides!(conn.assigns.current_scope, id)

    with {:ok, %Rides{} = ride} <- Ride.delete_rides(conn.assigns.current_scope, rides, %{cancelation_reason: cancelation_reason}) do
      render(conn, :show, rides: ride)
    end
  end
end
