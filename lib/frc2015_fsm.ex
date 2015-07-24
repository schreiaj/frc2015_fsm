defmodule Robot do
  use Fsm, initial_state: :align_to_hp, initial_data: 0

  defstate align_to_hp do
    defevent hp_feed do
      next_state :intake_tote
    end
  end

  defstate intake_tote do
    defevent cycle_elevator, data: totes do
      if totes >= 6 do
        raise "Stack Too High"
      end
      next_state :stack_tote, totes + 1
    end
  end

  defstate stack_tote do
    defevent hp_feed  do
      next_state :intake_tote
    end
    defevent drive do
        next_state :deliver_stack
    end
  end

  defevent drop_stack, data: totes do
    next_state :align_to_hp, totes = 0
  end
end
