# if common.food_used > 19 && units.select_type(Api::UnitTypeId::ZERGLING, Api::AbilityId::LARVATRAIN_ZERGLING) < 2
#   units.larva.first.action(ability_id: Api::AbilityId::LARVATRAIN_ZERGLING)
# end
require_relative "macro"

def zergling_and_zergling_production_count
  units_building.count(1343) + units.select_type(Api::UnitTypeId::ZERGLING).count
end

def hello_general
  # p "hello from fieldmarshal"
  p units_building

  if common.food_used >= 19 && zergling_and_zergling_production_count <= 2
    units.larva.first.action(ability_id: Api::AbilityId::LARVATRAIN_ZERGLING) if units.larva.any?
  end
end
