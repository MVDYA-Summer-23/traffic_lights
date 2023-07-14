defmodule TrafficLights.LightTest do
  use ExUnit.Case
  doctest TrafficLights.Light

  setup [:start_light]

  defp start_light(_context) do
    {:ok, pid} = TrafficLights.Light.start_link()
    [pid: pid]
  end

  test "initial traffic light state should start as :green", context do
    assert :sys.get_state(context[:pid]) == :green
  end

  test "transition/1 should (async) change the light to the next phase", context do
    TrafficLights.Light.transition(context[:pid])
    assert TrafficLights.Light.current_light(context[:pid]) == :yellow
    TrafficLights.Light.transition(context[:pid])
    assert TrafficLights.Light.current_light(context[:pid]) == :red
    TrafficLights.Light.transition(context[:pid])
    assert TrafficLights.Light.current_light(context[:pid]) == :green
  end

  test "current_light/1 should (sync) retrieve the current light state", context do
    assert TrafficLights.Light.current_light(context[:pid]) == :green
  end
end
