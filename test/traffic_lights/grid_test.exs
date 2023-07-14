defmodule TrafficLights.GridTest do
  alias TrafficLights.Grid
  use ExUnit.Case
  doctest Grid

  test "start_link starts a Grid GenServer" do
    assert {:ok, pid} = Grid.start_link()
  end

  test "current_lights/1 returns a list of 5 Light phases, each initialized to green" do
    {:ok, pid} = Grid.start_link()
    assert [:green, :green, :green, :green, :green] = Grid.current_lights(pid)
  end

  test "transition/1 transitions all lights in the grid to the next phase" do
    {:ok, pid} = Grid.start_link()
    [:green, :green, :green, :green, :green] = Grid.current_lights(pid)
    Grid.transition(pid)
    [:yellow, :green, :green, :green, :green] = Grid.current_lights(pid)
    Grid.transition(pid)
    [:yellow, :yellow, :green, :green, :green] = Grid.current_lights(pid)
    Grid.transition(pid)
    [:yellow, :yellow, :yellow, :green, :green] = Grid.current_lights(pid)
  end
end
