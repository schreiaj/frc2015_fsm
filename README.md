## Using FSMs to Model Game Activities

Today, we're going to build a simple FSM to model the FRC2015 game, Recycle Rush. I'm going to focus on the part of the game I know, so we're going to build a FSM for a HP loaded stacker. I'm also going to introduce the concept of multiple possible transitions from a single state.

### The State Machine
Last time I wrote out all the states and transitions, today I'm going to skip that and provide a simple diagram. You'll notice it's a fair bit more complicated than before. I've also eliminated a lot of states (such as collecting cans and driving  to the HP station). The diagram started getting cramped so those events and states are left as exercises for the reader.

![](resources/img/fsm.png)

I was nice and color coded it for you; Blue denotes the good path through the system. Red denotes bad paths. Let's get started coding...


### The Good
We're going to start with the good options. I've separated those out below.

![](resources/img/good.png)

Like last time, we're going to write tests and then write the code to make the tests work. This is called Test Driven Development. Why write tests first? Because otherwise you'll never write them. Why write tests? Because when these start getting more complicated you want to have simple tests to verify behavior.

```elixir
# test/frc2015_fsm_test.exs
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
    assert bot.state = :stack_tote
  end

  test "after stacking a tote we should intake another tote" do
    bot = Robot.new
       |> Robot.hp_feed
       |> Robot.stack_tote
       |> Robot.hp_feed
    assert bot.state = :intake_tote
  end

  # And now the things we can't do...

  test "we can't cycle elevator until we've got a tote" do
    assert raise FunctionClauseError, fn ->
      Robot.new |> Robot.cycle_elevator
    end
  end

end





```
