local CurrentWeather = Config.StartWeather
local lastWeather = CurrentWeather
local baseTime = Config.BaseTime
local timeOffset = Config.TimeOffset
local timer = 0
local freezeTime = Config.FreezeTime
local blackout = Config.Blackout
local blackoutVehicle = Config.BlackoutVehicle
local disable = Config.Disabled

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    disable = false
    TriggerServerEvent('qb-weathersync:server:RequestStateSync')
    TriggerServerEvent('qb-weathersync:server:RequestCommands')
end)

RegisterNetEvent('qb-weathersync:client:EnableSync', function()
    disable = false
    TriggerServerEvent('qb-weathersync:server:RequestStateSync')
end)

RegisterNetEvent('qb-weathersync:client:DisableSync', function()
	disable = true
	CreateThread(function()
		while disable do
			SetRainLevel(0.0)
			SetWeatherTypePersist('CLEAR')
			SetWeatherTypeNow('CLEAR')
			SetWeatherTypeNowPersist('CLEAR')
			NetworkOverrideClockTime(18, 0, 0)
			Wait(5000)
		end
	end)
end)

RegisterNetEvent('qb-weathersync:client:SyncWeather', function(NewWeather, newblackout)
    CurrentWeather = NewWeather
    blackout = newblackout
end)

RegisterNetEvent('qb-weathersync:client:RequestCommands', function(isAllowed)
    if isAllowed then
        TriggerEvent('chat:addSuggestion', '/freezetime', Lang:t('help.freezecommand'), {})
        TriggerEvent('chat:addSuggestion', '/freezeweather', Lang:t('help.freezeweathercommand'), {})
        TriggerEvent('chat:addSuggestion', '/weather', Lang:t('help.weathercommand'), {
            { name=Lang:t('help.weathertype'), help=Lang:t('help.availableweather') }
        })
        TriggerEvent('chat:addSuggestion', '/blackout', Lang:t('help.blackoutcommand'), {})
        TriggerEvent('chat:addSuggestion', '/morning', Lang:t('help.morningcommand'), {})
        TriggerEvent('chat:addSuggestion', '/noon', Lang:t('help.nooncommand'), {})
        TriggerEvent('chat:addSuggestion', '/evening', Lang:t('help.eveningcommand'), {})
        TriggerEvent('chat:addSuggestion', '/night', Lang:t('help.nightcommand'), {})
        TriggerEvent('chat:addSuggestion', '/time', Lang:t('help.timecommand'), {
            { name=Lang:t('help.timehname'), help=Lang:t('help.timeh') },
            { name=Lang:t('help.timemname'), help=Lang:t('help.timem') }
        })
    end
end)

RegisterNetEvent('qb-weathersync:client:SyncTime', function(base, offset, freeze)
    freezeTime = freeze
    timeOffset = offset
    baseTime = base
end)

CreateThread(function()
    while true do
        if not disable then
            if lastWeather ~= CurrentWeather then
                lastWeather = CurrentWeather
                SetWeatherTypeOverTime(CurrentWeather, 15.0)
                Wait(15000)
            end
            Wait(100) -- Wait 0 seconds to prevent crashing.
            SetArtificialLightsState(blackout)
            SetArtificialLightsStateAffectsVehicles(blackoutVehicle)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)
            if lastWeather == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
            if lastWeather == 'RAIN' then
                SetRainLevel(0.3)
            elseif lastWeather == 'THUNDER' then
                SetRainLevel(0.5)
            else
                SetRainLevel(0.0)
            end
        else
            Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    local hour = 00
    local minute = 00
    while true do
        if not disable then
            Citizen.Wait(500)
            local years, months, days, hours, minutes, seconds = Citizen.InvokeNative(0x50C7A99057A69748, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
            local newBaseTime = baseTime
            if GetGameTimer() - 500  > timer then
                newBaseTime = newBaseTime + 0.25
                timer = GetGameTimer()
            end
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime            
            end
            baseTime = newBaseTime
            hour = hours
            minute = minutes
            day=days
            month=months
            year=years
            second=seconds
            NetworkOverrideClockTime(hour, minute, second)
            TriggerServerEvent("realtime:server:event")
        else
            Citizen.Wait(1000)
        end
    end
end)

SetMillisecondsPerGameMinute(60000)
RegisterNetEvent("realtime:client:event")
AddEventHandler("realtime:client:event", function(h, m, s)
    NetworkOverrideClockTime(tonumber(h), tonumber(m), tonumber(s))
end)
TriggerServerEvent("realtime:server:event")