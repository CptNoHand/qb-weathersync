Config                  = {}
Config.DynamicWeather   = true -- Set this to false if you don't want the weather to change automatically every 10 minutes.

-- On server start
Config.StartWeather     = 'CLEAR' -- Default weather                       default: 'EXTRASUNNY'
Config.BaseTime         = 0 -- Time                                             default: 8
Config.TimeOffset       = 0 -- Time offset                                      default: 0
Config.FreezeTime       = false -- freeze time                                  default: false
Config.Blackout         = false -- Set blackout                                 default: false
Config.BlackoutVehicle  = false -- Set blackout affects vehicles                default: false
Config.NewWeatherTimer  = 5 -- Time (in minutes) between each weather change   default: 10
Config.Disabled         = false -- Set weather disabled                         default: false

Config.Locale           = 'en' -- Languages : en, fr, pt, tr, pt_br

Config.DynamicWeatherTypes = { -- DON'T TOUCH EXCEPT IF YOU KNOW WHAT YOU ARE DOING
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
}
