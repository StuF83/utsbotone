# This file should require your bot and create a $bot.
# You are free to rename your bot class, name or restructure your code as long
# as $bot is created correctly. if not, your ladder bot will break.

require_relative "uts_bot_one.rb"
$bot = UtsBotOne.new(name: "utsBotOne", race: Api::Race::Zerg)
