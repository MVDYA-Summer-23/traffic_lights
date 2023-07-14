defmodule TrafficLights.LightTest do
  use ExUnit.Case
  doctest TrafficLights.Light

  test "current_light/1 should (sync) retrieve the current light state" do
    {:ok, pid} = TrafficLights.Light.start_link()
    assert TrafficLights.Light.current_light(pid) == :green
  end

  test "transition/1 should (async) change the light to the next phase" do
    {:ok, pid} = TrafficLights.Light.start_link()
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :yellow
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :red
    TrafficLights.Light.transition(pid)
    assert TrafficLights.Light.current_light(pid) == :green
  end
end
