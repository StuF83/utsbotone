require "sc2ai"

class UtsBotOne < Sc2::Player::Bot

  def configure
    @realtime = false # Step-mode vs Bot, Realtime vs Humans
    @step_size = 1 # Gives 22.4ms, typically compete at 2 (44.8ms) or 4 (179.2ms).
    @enable_feature_layer = false; # Enables ui_ and spatial_ actions. Advanced, and has performance cost.
  end

  def on_step

    main = structures.hq.first

    if common.food_used < common.food_cap && common.minerals > 50
      units.larva.random.action(ability_id: Api::AbilityId::LARVATRAIN_DRONE)
    end 

    # If your attack fails, "good game" and exit
    if units.workers.size.zero?
      action_chat("gg", channel: Api::ActionChat::Channel::Broadcast)
      leave_game
    end
  end
end
