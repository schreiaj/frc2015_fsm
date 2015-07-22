defmodule Robot do
  use Fsm, initial_state: :align_to_hp

  defstate align_to_hp do
    defevent hp_feed do
      next_state :intake_tote
    end
  end

  defstate intake_tote do
    defevent cycle_elevator do
      next_state :stack_tote
    end
  end

  defstate stack_tote do
    defevent hp_feed do
      next_state :intake_tote
    end
  end
end
