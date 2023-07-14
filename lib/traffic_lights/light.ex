defmodule TrafficLights.Light do
  use GenServer

  @moduledoc """
  A traffic light that can be in one of three states: :green, :yellow, :red
  """
  @doc """
  The initial state of the traffic light
  """
  @initial_state :green

  def start_link(_opts \\ []), do: GenServer.start_link(__MODULE__, @initial_state)

  @doc """
  Retrieve the current light state
  """
  def current_light(pid) do
    GenServer.call(pid, :current_light)
  end

  @doc """
  Transition the light to the next phase
  """
  def transition(pid), do: GenServer.cast(pid, :transition)

  def init(data), do: {:ok, data}

  def handle_call(:current_light, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:transition, state) do
    new_phase =
      case state do
        :green -> :yellow
        :yellow -> :red
        :red -> :green
      end

    {:noreply, new_phase}
  end
end
