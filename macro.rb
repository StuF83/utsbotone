def units_building
  units.select_type(Api::UnitTypeId::EGG).map { |egg| egg.orders.first.to_h[:ability_id] }
end

def overlords_in_production_equal_to_hq_count?
  # (units_building.count(1344) < structures.hq.count) ? false : true
  (units_building.count(1344) < structures.hq.count)
end

def build_worker
  units.larva.first.action(ability_id: Api::AbilityId::LARVATRAIN_DRONE)
end

def overlord_and_overlord_production_count
  units_building.count(1344) + units.select_type(Api::UnitTypeId::OVERLORD).count
end

def empty_workers
  units.workers.select { |worker| worker.buff_ids.to_a.empty? }
end

def spawning_pool_count
  structures.select_type(Api::UnitTypeId::SPAWNINGPOOL).count
end

def structure_and_worker_build_order_count(structure_name)
  ability_id_string = "ZERGBUILD_" + structure_name
  ability_id = Api::AbilityId.const_get(ability_id_string)
  unit_type_id = Api::UnitTypeId.const_get(structure_name)
  builders = []
  units.workers.each do |worker|
    builders << worker if worker.orders.any? { |order| order.to_h.has_value?(ability_id) }
  end
  builders.count + structures.select_type(unit_type_id).count
end
