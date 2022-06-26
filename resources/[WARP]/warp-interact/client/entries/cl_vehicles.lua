local Entries = {}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_flip",
            label = "Flip Vehicle",
            icon = "car-crash",
            event = "FlipVehicle",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return not IsVehicleOnAllWheels(pEntity)
        end
    }
}

-- Entries[#Entries + 1] = {
--     type = 'entity',
--     group = { 2 },
--     data = {
--         {
--             id = "vehicle_refuel_station",
--             label = "Refuel Vehicle",
--             icon = "fas fa-gas-pump",
--             event = "vehicle:refuel:menu",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 1.2, boneId = 'wheel_lr' },
--         isEnabled = function(pEntity, pContext)
--             return exports['warp-interact']:NearGasFn()
--         end
--     }
-- }

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "carry_bike",
            label = "Carry Bike",
            icon = "spinner",
            event = "carryEntity",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 3.0 },
        isEnabled = function(pEntity, pContext)
            return IsThisModelABicycle(pContext.model) and not IsEntityAttachedToAnyPed(pEntity) and not IsEntityAttachedToAnyPed(PlayerPedId())
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_getintrunk",
            label = "Enter trunk",
            icon = "user-secret",
            event = "ped:forceTrunkSelf",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4.0 },
        isEnabled = function(pEntity, pContext)
            local lockStatus = GetVehicleDoorLockStatus(pEntity)
            return DoesVehicleHaveDoor(pEntity, 5) and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model) and (lockStatus == 1 or lockStatus == 0 or lockStatus == 4)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_runplate",
            label = "Run Plate",
            icon = "money-check",
            event = "clientcheckLicensePlate",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 7.0 },
        isEnabled = function(pEntity, pContext)
            return isPolice and (isCloseToHood(pEntity, PlayerPedId(), 2.0) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)) and not IsPedInAnyVehicle(PlayerPedId(), false)
        end
    }
}

-- Entries[#Entries + 1] = {
--     type = 'entity',
--     group = { 2 },
--     data = {
--         {
--             id = "vehicle_add_fakeplate",
--             label = "Add Fakeplate",
--             icon = "screwdriver",
--             event = "vehicle:addFakePlate",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 3.0 },
--         isEnabled = function(pEntity, pContext)
--             plate = GetVehicleNumberPlateText(pEntity)
--             hasKeys = exports["warp-keys"]:hasKey(plate)
--             return (isCloseToHood(pEntity, PlayerPedId(), 2.0) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)) and not IsPedInAnyVehicle(PlayerPedId(), false)
--             and hasKeys and exports["warp-inventory"]:hasEnoughOfItem("fakeplate", 1, false)
--             and not exports["warp-vehicles"]:GetVehicleMetadata(pEntity, 'fakePlate')
--         end
--     }
-- }

-- Entries[#Entries + 1] = {
--     type = 'entity',
--     group = { 2 },
--     data = {
--         {
--             id = "vehicle_remove_fakeplate",
--             label = "Remove Fakeplate",
--             icon = "ban",
--             event = "vehicle:removeFakePlate",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 3.0 },
--         isEnabled = function(pEntity, pContext)
--             plate = GetVehicleNumberPlateText(pEntity)
--             hasKeys = exports["warp-keys"]:hasKey(plate)
--             return isCloseToBoot(pEntity, PlayerPedId(), 1.8, pContext.model) and not IsPedInAnyVehicle(PlayerPedId(), false)
--             and hasKeys and exports["warp-vehicles"]:GetVehicleMetadata(pEntity, 'fakePlate')
--         end
--     }
-- }

 Entries[#Entries + 1] = {
     type = 'entity',
     group = { 2 },
     data = {
         {
             id = "vehicle_examine",
             label = "Examine Vehicle",
             icon = "wrench",
             event = "veh:requestUpdate",
             parameters = {}
         }
     },
     options = {
         distance = { radius = 3.0, boneId = "engine" },
         isEnabled = function(pEntity, pContext)
             return isCloseToEngine(pEntity, PlayerPedId(), 3.0, pContext.model)
         end
     }
 }

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isFuelPump' },
    data = {
        {
            id = 'gas_station',
            label = "Refill Vehicle",
            icon = "gas-pump",
            event = "warp-gas:checkpump",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.5 },
        isEnabled = function(pEntity, pContext)
            return polyChecks.gasStation.isInside
        end
    }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_refuel_station_plane",
          label = "Refuel Vehicle",
          icon = "gas-pump",
          event = "vehicle:refuel:showMenu",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.0 },
      isEnabled = function(pEntity, pContext)
          local vehicleClass = GetVehicleClass(pEntity)
          if vehicleClass ~= 16 then return false end
          return polyChecks.gasStation.isInside
      end
  }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_refuel_station_boat",
            label = "Refuel Vehicle",
            icon = "gas-pump",
            event = "vehicle:refuel:showMenu",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 5.0 },
        isEnabled = function(pEntity, pContext)
            local vehicleClass = GetVehicleClass(pEntity)
            if vehicleClass ~= 14 then return false end
            return polyChecks.gasStation.isInside
        end
    }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_refuel_station_chopter",
          label = "Refuel Vehicle",
          icon = "gas-pump",
          event = "vehicle:refuel:showMenu",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 5.0 },
      isEnabled = function(pEntity, pContext)
          local vehicleClass = GetVehicleClass(pEntity)
          if vehicleClass ~= 15 then return false end
          return polyChecks.gasStation.isInside
      end
  }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_refuel_jerrycan",
            label = "Refuel Vehicle",
            icon = "gas-pump",
            event = "warp-hud:jerry_can:refuel",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.2, boneId = 'wheel_lr' },
        isEnabled = function(pEntity, pContext)
            return HasWeaponEquipped(883325847) -- WEAPON_PetrolCan
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_putinvehicle",
            label = "seat in vehicle",
            icon = "chevron-circle-left",
            event = "police:forceEnter",
            parameters = {}
        },
        {
            id = "vehicle_unseatnearest",
            label = "unseat from vehicle",
            icon = "chevron-circle-right",
            event = "unseatPlayer",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 4.0 },
        isEnabled = function(pEntity, pContext)
            return (not (isCloseToHood(pEntity, PlayerPedId()) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model))
              or pContext.model == GetHashKey("emsnspeedo"))
              and not IsPedInAnyVehicle(PlayerPedId(), false)
              and NetworkGetEntityIsNetworked(pEntity)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_impound",
            label = "Request Impound",
            icon = "truck",
            event = "impound:request:context",
            parameters = {}
        }
    },
    options = {
        --job = {'police'},
        distance = { radius = 4.0 },
        isEnabled = function(pEntity, pContext)
            return isPolice and (not (isCloseToHood(pEntity, PlayerPedId()) or isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model))
              or pContext.model == GetHashKey("emsnspeedo"))
              and not IsPedInAnyVehicle(PlayerPedId(), false)
              and NetworkGetEntityIsNetworked(pEntity)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_keysgive",
            label = "give key",
            icon = "key",
            event = "keys:give",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 1.8 },
        isEnabled = function(pEntity, pContext)
            return true --hasKeys(pEntity)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_vinscratch",
            label = "scratch vin",
            icon = "eye-slash",
            event = "mizrp-boosting:scratchVehicleVin",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return pContext.meta ~= nil and pContext.meta.boostingInfo ~= nil and pContext.meta.boostingInfo.vinScratch
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_methdisturbdrop",
            label = "Intercept goods",
            icon = "eye-slash",
            event = "mizrp-meth:dropoff:cancelDropOff",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, false) and pContext.meta ~= nil and pContext.meta.dropoffInfo and pContext.meta.dropoffInfo.uuid and isPolice
        end
    }
}

Entries[#Entries + 1] = {
    type = 'entity',
    group = { 2 },
    data = {
        {
            id = "vehicle_methdrop",
            label = "Drop off goods",
            icon = "cubes",
            event = "mizrp-meth:dropoff:doDropoff",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 4 },
        isEnabled = function(pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, false) and pContext.meta ~= nil and pContext.meta.dropoffInfo and pContext.meta.dropoffInfo.uuid
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isWheelchair' },
    data = {
        {
            id = "wheelchair",
            label = "toggle wheelchair",
            icon = "wheelchair",
            event = "drp:vehicle:wheelchair:control",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 0.9, boneId = 'misc_a' }
    }
}


Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isTowTruck' },
    data = {
        {
            id = "towtruck_tow",
            label = "tow vehicle",
            icon = "trailer",
            event = "jobs:towVehicle",
            parameters = {}
        }
    },
    options = {
        job = { 'impound', 'pd_impound' },
        distance = { radius = 2.5, boneId = 'wheel_lr' },
        isEnabled = function (pEntity, pContext)
            return not pContext.flags['isTowingVehicle']
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isTowTruck' },
    data = {
        {
            id = "towtruck_untow",
            label = "untow vehicle",
            icon = "trailer",
            event = "jobs:untowVehicle",
            parameters = {}
        }
    },
    options = {
        job = { 'impound', 'pd_impound' },
        distance = { radius = 2.5, boneId = 'wheel_lr' },
        isEnabled = function (pEntity, pContext)
            return pContext.flags['isTowingVehicle']
        end
    }
}

Entries[#Entries + 1] = {
    type = 'model',
    group = { GetHashKey('trash2') },
    data = {
        {
            id = "sanitation_worker_throw_trash",
            label = "throw in trash",
            icon = "trash-restore-alt",
            event = "warp-jobs:sanitationWorker:vehicleTrash",
            parameters = {}
        }
    },
    options = {
        job = { 'sanitation_worker' },
        distance = { radius = 3.8, boneId = 'wheel_lr' },
        isEnabled = function (pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId(), 1.1, true)
        end
    }
}

Entries[#Entries + 1] = {
    type = 'model',
    group = { GetHashKey('benson') },
    data = {
        {
            id = "247_deliveries_take_goods",
            label = "Grab goods",
            icon = "box",
            event = "warp-jobs:247delivery:takeGoods",
            parameters = {}
        }
    },
    options = {
        job = { '247_deliveries' },
        distance = { radius = 2.0, boneId = 'boot' },
        isEnabled = function (pEntity, pContext)
            return isCloseToTrunk(pEntity, PlayerPedId())
        end
    }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_buy_vehicle",
          label = "sell vehicle",
          icon = "money-check-alt",
          event = "mizrp-ottosauto:vehicle:transaction",
          parameters = {
            action = "sell"
          }
      }
  },
  options = {
      distance = { radius = 1.8 },
      isEnabled = function(pEntity, pContext)
          return polyChecks.ottosAuto.isInside and hasJobPermission("ottos_auto") and CanSellOrBuyCar(pEntity, true)
      end
  }
}

Entries[#Entries + 1] = {
  type = 'entity',
  group = { 2 },
  data = {
      {
          id = "vehicle_sell_vehicle",
          label = "buy vehicle",
          icon = "shopping-cart",
          event = "mizrp-ottosauto:vehicle:transaction",
          parameters = {
            action = "buy"
          }
      }
  },
  options = {
      distance = { radius = 1.8 },
      isEnabled = function(pEntity, pContext)
          return polyChecks.ottosAuto.isInside and hasJobPermission("ottos_auto", "buy_car") and CanSellOrBuyCar(pEntity, false)
      end
  }
}

-- local stockadeHash = `STOCKADE`
-- Entries[#Entries + 1] = {
--   type = 'entity',
--   group = { 2 },
--   data = {
--       {
--           id = "moneytruckthermite",
--           label = "Use Thermite",
--           icon = "circle",
--           event = "mizrp-heists:bobcatThermiteMoneyTruckDoor",
--           parameters = {}
--       }
--   },
--   options = {
--       distance = { radius = 8.0 },
--       isEnabled = function(pEntity, pContext)
--           return pContext.model == stockadeHash
--             and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)
--             and not DecorGetBool(pEntity, "BobcatMoneyTruck")
--             and exports["warp-inventory"]:hasEnoughOfItem("thermitecharge", 1, false, true)
--       end
--   }
-- }

-- Entries[#Entries + 1] = {
--   type = 'entity',
--   group = { 2 },
--   data = {
--       {
--           id = "moneytruckloot",
--           label = "Take Goods",
--           icon = "circle",
--           event = "mizrp-heists:bobcatMoneyTruckTakeGoods",
--           parameters = {}
--       }
--   },
--   options = {
--       distance = { radius = 8.0 },
--       isEnabled = function(pEntity, pContext)
--           return pContext.model == stockadeHash
--             and isCloseToBoot(pEntity, PlayerPedId(), 2.0, pContext.model)
--             and DecorGetBool(pEntity, "BobcatMoneyTruck")
--       end
--   }
-- }

Citizen.CreateThread(function()
    for _, entry in ipairs(Entries) do
        if entry.type == 'flag' then
            AddPeekEntryByFlag(entry.group, entry.data, entry.options)
        elseif entry.type == 'model' then
            AddPeekEntryByModel(entry.group, entry.data, entry.options)
        elseif entry.type == 'entity' then
            AddPeekEntryByEntityType(entry.group, entry.data, entry.options)
        elseif entry.type == 'polytarget' then
            AddPeekEntryByPolyTarget(entry.group, entry.data, entry.options)
        end
    end
end)