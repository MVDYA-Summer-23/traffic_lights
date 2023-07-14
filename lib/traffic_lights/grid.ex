defmodule TrafficLights.Grid do
  alias TrafficLights.Light
  use GenServer

  @moduledoc """
  GenServer that manages a pool of TrafficLight.Light processes
  The initial state of the grid should contain a list with five TrafficLights.Light pids in addition to any other state you want to track
  Create a current_lights/1 and transition/1 function
  """
  @doc "Start the grid with a list of five TrafficLights.Light pids"
  def start_link(_opts \\ []) do
    lights = Enum.map(1..5, fn _ -> Light.start_link() |> elem(1) end)
    GenServer.start_link(__MODULE__, lights)
  end

  @doc "Retrieve the current state of all light in the grid"
  def current_lights(pid), do: GenServer.call(pid, :current_lights)

  @doc "Transition all lights in the grid"
  def transition(pid), do: GenServer.cast(pid, :transition)

  def init(data), do: {:ok, data}

  def handle_call(:current_lights, _from, state) do
    lights = Enum.map(state, fn light -> Light.current_light(light) end)
    {:reply, lights, state}
  end

  def handle_cast(:transition, state) do
    Enum.each(state, fn light -> Light.transition(light) end)
    {:noreply, state}
  end
end
