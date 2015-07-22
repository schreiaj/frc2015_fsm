defmodule Frc2015FsmTest do
  use ExUnit.Case

  test "we start aligned to the human player" do
    assert Robot.new.state == :align_to_hp
  end

  test "we should intake a tote after we hp_feed" do
    bot = Robot.new |> Robot.hp_feed
    assert bot.state == :intake_tote
  end

  test "after intaking a tote we should cycle the elevator to stack the tote" do
    bot = Robot.new |> Robot.hp_feed |> Robot.cycle_elevator
    assert bot.state == :stack_tote
  end

  test "after stacking a tote we should intake another tote" do
    bot = Robot.new
       |> Robot.hp_feed
       |> Robot.cycle_elevator
       |> Robot.hp_feed
    assert bot.state == :intake_tote
  end

  # And now the things we can't do...

  test "we can't cycle elevator until we've got a tote" do
    assert_raise FunctionClauseError, fn ->
      Robot.new |> Robot.cycle_elevator
    end
  end

  test "we can't hp_feed once we are intaking a tote" do
    assert_raise FunctionClauseError, fn ->
      Robot.new
        |> Robot.hp_feed
        |> Robot.hp_feed
      end
  end
end
