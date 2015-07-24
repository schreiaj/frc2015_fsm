defmodule Frc2015FsmTest do
  use ExUnit.Case

  test "initially we have 0 totes" do
    assert Robot.new.data == 0
  end

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

  test "we can drive to deliver a stack" do
    bot = Robot.new
       |> Robot.hp_feed
       |> Robot.cycle_elevator
       |> Robot.drive
    assert bot.state == :deliver_stack
  end

  test "while intaking a tote we can drop the stack" do
    bot = Robot.new |> Robot.hp_feed |> Robot.drop_stack
    assert bot.state == :align_to_hp
  end

  test "while stacking a tote we can drop the stack" do
    bot = Robot.new |> Robot.hp_feed |> Robot.cycle_elevator |>Robot.drop_stack
    assert bot.state == :align_to_hp
  end


  test "while delivering a stack we can drop the stack" do
    bot = Robot.new |> Robot.hp_feed |> Robot.cycle_elevator |> Robot.drive |> Robot.drop_stack
    assert bot.state == :align_to_hp
  end

  test "cycling the elevator increments our totes" do
    bot = Robot.new
       |> Robot.hp_feed
       |> Robot.cycle_elevator
    assert bot.data == 1
  end

  test "cycling the elevator 7 times fails" do
    assert_raise RuntimeError, fn ->
      Robot.new
         |> Robot.hp_feed
         |> Robot.cycle_elevator
         |> Robot.hp_feed
         |> Robot.cycle_elevator
         |> Robot.hp_feed
         |> Robot.cycle_elevator
         |> Robot.hp_feed
         |> Robot.cycle_elevator
         |> Robot.hp_feed
         |> Robot.cycle_elevator
         |> Robot.hp_feed
         |> Robot.cycle_elevator
         |> Robot.hp_feed
         |> Robot.cycle_elevator
      end
  end

end
