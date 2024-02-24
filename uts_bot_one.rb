require "sc2ai"
require_relative "macro"
require_relative "field_marshal"

class UtsBotOne < Sc2::Player::Bot
  def initialize(race:, name:)
    super(race:, name:)
    @bases = []
  end

  def configure
    @realtime = false # Step-mode vs Bot, Realtime vs Humans
    @step_size = 1 # Gives 22.4ms, typically compete at 2 (44.8ms) or 4 (179.2ms).
    @enable_feature_layer = false; # Enables ui_ and spatial_ actions. Advanced, and has performance cost.
  end

  def on_step
    # roach timing attack pvx

    # p units.select_type(unit_type_id: Api::UnitTypeId::TYPE_GEYSER)
    if game_loop == 0
      build_worker
      @bases << structures.hq.first
    end

    hello_general

    if common.food_used == 13 && common.minerals > 100
      units.larva.first.action(ability_id: Api::AbilityId::LARVATRAIN_OVERLORD) unless overlords_in_production_equal_to_hq_count?
    end

    if common.food_used < 16 && common.minerals > 50 && (overlord_and_overlord_production_count == 2) && (common.food_used < common.food_cap)
      build_worker
    end

    if common.food_used == 16 && common.minerals > 200 && spawning_pool_count < 1
      worker = empty_workers.random
      build_location = geo.build_placement_near(length: 4, target: @bases[0], random: 3)
      worker.build(unit_type_id: Api::UnitTypeId::SPAWNINGPOOL, target: build_location)
    end

    if common.food_used == 16 && common.minerals > 200 && spawning_pool_count == 1 && structure_and_worker_build_order_count("HATCHERY") < 2
      build_worker
    end

    if common.food_used == 17 && common.minerals > 300 && structure_and_worker_build_order_count("HATCHERY") < 2
      worker = empty_workers.random
      build_location = geo.expansions_unoccupied.keys.min_by { |point| point.distance_to(@bases[0].pos) }
      worker.build(unit_type_id: Api::UnitTypeId::HATCHERY, target: build_location)
    end

    if common.food_used == 16 && common.minerals > 75 && spawning_pool_count == 1 && structure_and_worker_build_order_count("HATCHERY") == 2 && structure_and_worker_build_order_count("EXTRACTOR") < 1
      gasses = @bases[0].nearest(units: neutral.geysers, amount: 2)
      empty_workers.random.build(unit_type_id: Api::UnitTypeId::EXTRACTOR, target: gasses.random)
    end

    if common.food_used < 19 && common.minerals > 75 && spawning_pool_count == 1 && structure_and_worker_build_order_count("HATCHERY") == 2 && structure_and_worker_build_order_count("EXTRACTOR") == 1
      build_worker if units.larva.any?
      # main_extractors = @bases[0].nearest(units: structures.select_type(unit_type_id: Api::UnitTypeId::EXTRACTOR), amount: 2)

      # p main_extractors.count
    end

    # main_extractors = @bases[0].nearest(units: units.select([unit_type_id: Api::UnitTypeId::EXTRACTOR, unit_type_id: Api::UnitTypeId::TYPE_GEYSER]), amount: 2)

    # If your attack fails, "good game" and exit
    if units.workers.size.zero?
      action_chat("gg", channel: Api::ActionChat::Channel::Broadcast)
      leave_game
    end
  end
end
