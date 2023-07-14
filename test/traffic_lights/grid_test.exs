defmodule TrafficLights.GridTest do
  alias TrafficLights.Grid
  use ExUnit.Case
  doctest Grid

  setup_all [:start_grid]

  defp start_grid(_context) do
    {:ok, pid} = Grid.start_link()
    [pid: pid]
  end

  @tag :skip_setup
  test "start_link starts a Grid GenServer with 5 Light pids" do
    {:ok, pid} = Grid.start_link()
    grid = :sys.get_state(pid)
    Enum.each(grid, fn light -> assert is_pid(light) end)
  end

  test "current_lights/1 returns a list of 5 Light processes, each initialized to green",
       context do
    [:green, :green, :green, :green, :green] = Grid.current_lights(context[:pid])
  end

  test "transition/1 transitions all lights in the grid to the next phase",
       context do
    [:green, :green, :green, :green, :green] = Grid.current_lights(context[:pid])
    Grid.transition(context[:pid])
    [:yellow, :yellow, :yellow, :yellow, :yellow] = Grid.current_lights(context[:pid])
    Grid.transition(context[:pid])
    [:red, :red, :red, :red, :red] = Grid.current_lights(context[:pid])
    Grid.transition(context[:pid])
    [:green, :green, :green, :green, :green] = Grid.current_lights(context[:pid])
  end
end
