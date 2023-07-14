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
    lights =
      Enum.reduce(1..5, %{}, fn idx, grid ->
        {:ok, pid} = Light.start_link()
        Map.put(grid, idx, pid)
      end)

    GenServer.start_link(__MODULE__, %{lights: lights, current_light: 1})
  end

  @doc "Retrieve the current state of all light in the grid"
  def current_lights(pid), do: GenServer.call(pid, :current_lights)

  @doc "Transition one light in the grid, in a sequence"
  def transition(pid), do: GenServer.cast(pid, :transition)

  def init(data), do: {:ok, data}

  def handle_call(:current_lights, _from, %{lights: lights} = state) do
    lights_status = Enum.map(lights, fn {_idx, light} -> Light.current_light(light) end)
    {:reply, lights_status, state}
  end

  def handle_cast(:transition, %{lights: lights, current_light: current_index} = state) do
    max_lights = Map.keys(lights) |> length()
    current_light_pid = Map.get(lights, current_index)
    Light.transition(current_light_pid)
    next_light = if current_index == max_lights, do: 1, else: current_index + 1
    {:noreply, %{state | current_light: next_light}}
  end
end
