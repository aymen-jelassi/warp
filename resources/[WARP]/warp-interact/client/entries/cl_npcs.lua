local Entries = {}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isRecycleExchange' },
    data = {
        {
            id = "recycle_exchange",
            label = "Exchange recyclables",
            icon = "circle",
            event = "warp-npcs:ped:exchangeRecycleMaterial",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isBankAccountManager' },
    data = {
        {
            id = "bank_paycheck_collect",
            label = "Collect paycheck",
            icon = "circle",
            event = "dreams-collect:paycheck",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isBankAccountManager' },
    data = {
        {
            id = "bank_receipt_collect",
            label = "trade in receipts",
            icon = "money-bill-wave",
            event = "warp-npcs:ped:receiptTradeIn",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function()
            local isEmployedAtBurgerShot = exports["mizrp-business"]:IsEmployedAt("burger_shot")
            local isEmployedAtRoosters = exports["mizrp-business"]:IsEmployedAt("rooster")
            local publicTradeIn = exports["mizrp-config"]:GetMiscConfig("jobs.receipts.public")
            return isEmployedAtBurgerShot or isEmployedAtRoosters or publicTradeIn
        end
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isBankAccountManager' },
  data = {
      {
          id = "bank_receipt_m_collect",
          label = "Trade in Market Receipts",
          icon = "money-bill-wave",
          event = "warp-npcs:ped:receiptTradeInMarket",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 },
      isEnabled = function()
          return exports["warp-inventory"]:getQuantity("farmersmarketreceipt", true) > 0
      end
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isCommonJobProvider' },
    data = {
        {
            id = "common_job_signIn",
            label = "Sign in",
            icon = "circle",
            event = "warp-npcs:ped:signInJob",
            parameters = {}
        },
        {
            id = "common_job_signOut",
            label = "Sign out",
            icon = "circle",
            event = "warp-npcs:ped:signInJob",
            parameters = { "unemployed" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "jobs_employer_checkIn",
            label = "Sign in",
            icon = "circle",
            event = "jobs:checkIn",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function()
            return CurrentJob == 'unemployed'
        end
    }
}

-- Entries[#Entries + 1] = {
--     type = 'flag',
--     group = { 'isJobEmployer' },
--     data = {
--         {
--             id = "fishing_borrow_boat",
--             label = "Borrow Fishing Boat",
--             icon = "circle",
--             event = "mizrp-fishing:rentBoat",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 2.5 },
--         isEnabled = function(pEntity, pContext)
--             return pContext.job.id == CurrentJob and not IsDisabled() and not IsPedInAnyVehicle(PlayerPedId()) and (pEntity and pContext.flags['isBoatRenter']) and (currentlyRentedBoat == nil or not DoesEntityExist(currentlyRentedBoat))
--         end
--     }
-- }

-- Entries[#Entries + 1] = {
--     type = 'flag',
--     group = { 'isJobEmployer' },
--     data = {
--         {
--             id = "fishing_return_boat",
--             label = "Return Fishing Boat",
--             icon = "circle",
--             event = "mizrp-fishing:returnBoat",
--             parameters = {}
--         }
--     },
--     options = {
--         distance = { radius = 2.5 },
--         isEnabled = function(pEntity, pContext)
--             return pContext.job.id == CurrentJob and not IsDisabled() and not IsPedInAnyVehicle(PlayerPedId()) and (pEntity and pContext.flags['isBoatRenter']) and (currentlyRentedBoat ~= nil and DoesEntityExist(currentlyRentedBoat))
--         end
--     }
-- }

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "jobs_employer_paycheck",
            label = "Get paycheck",
            icon = "circle",
            event = "jobs:getPaycheck",
            parameters = {}
        },
        {
            id = "jobs_employer_checkOut",
            label = "Sign Out",
            icon = "circle",
            event = "jobs:checkOut",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            return pContext.job.id == CurrentJob
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isJobEmployer' },
    data = {
        {
            id = "dodologistics_getpackage",
            label = "Get Packaging",
            icon = "circle",
            event = "mizrp-business:dodoLogisticsDisplayPackaging",
            parameters = {}
        },
    },
    options = {
        distance = { radius = 2.5 },
        isEnabled = function(pEntity, pContext)
            local isEmployedAtDodoLogistics = exports["mizrp-business"]:IsEmployedAt("dodologistics")
            return isEmployedAtDodoLogistics
        end
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isShopKeeper' },
    data = {
        {
            id = "shopkeeper_",
            label = "Purchase goods",
            icon = "circle",
            event = "warp-npcs:ped:keeper",
            parameters = { "2" }
        }
    },
    options = {
        distance = { radius = 3.0 }
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "liqourkeeper",
          label = "Purchase alcohol",
          icon = "circle",
          event = "warp-npcs:ped:keeperLiqour",
          parameters = { "42076" }
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"liqourkeeper_1", "liqourkeeper_2", "liqourkeeper_3", "liqourkeeper_4", "liqourkeeper_5", "liqourkeeper_6","liqourkeeper_7", "liqourkeeper_8", "liqourkeeper_9", "liqourkeeper_10", "liqourkeeper_11"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "getpaintballgun",
          label = "Pickup Paintball Gun",
          icon = "circle",
          event = "mizrp-paintball:getPaintballGun",
          parameters = {},
      },
      {
          id = "getpaintballsmoke",
          label = "Pickup Smoke Grenade",
          icon = "circle",
          event = "mizrp-paintball:getPaintballSmoke",
          parameters = {},
      },
      {
          id = "getpaintballammo",
          label = "Pickup Paintball Ammo",
          icon = "circle",
          event = "mizrp-paintball:getPaintballAmmo",
          parameters = {},
      },
      {
          id = "getpaintballmegaphone",
          label = "Pickup Megaphone",
          icon = "circle",
          event = "mizrp-paintball:getMegaphone",
          parameters = {},
      },
      {
          id = "getpaintballcaddy",
          label = "Pickup Caddy",
          icon = "circle",
          event = "mizrp-paintball:getCaddy",
          parameters = {},
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"paintball_vendor"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "arenawasteland",
          label = "Enable 'Wasteland'",
          icon = "circle",
          event = "mizrp-paintball:setArenaType",
          parameters = { "wasteland" },
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"paintball_arena_map"}
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "arenagotomain",
            label = "Take me to The Arena!",
            icon = "circle",
            event = "mizrp-paintball:swapLocations",
            parameters = {},
        },
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"paintball_arena_grass_swapper_1", "paintball_arena_grass_swapper_2"}
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "casinoswapinterior",
          label = "Enable Betting Stations",
          icon = "circle",
          event = "mizrp-casino:betting:interiorSwap",
          parameters = { "bets" },
      },
      {
          id = "casinoswapinteriorpoker",
          label = "Enable Poker Tables",
          icon = "circle",
          event = "mizrp-casino:betting:interiorSwap",
          parameters = { "poker" },
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"casino_interior_swap"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "galleryinteriorcars",
          label = "Enable Auction Stand",
          icon = "circle",
          event = "mizrp-gallery:interiorSwap",
          parameters = { "cars" },
      },
      {
          id = "galleryinteriorfights",
          label = "Enable Fight Ring",
          icon = "circle",
          event = "mizrp-gallery:interiorSwap",
          parameters = { "fights" },
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"gallery_interior_swap"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "paintballjoineastteam",
          label = "Join East Team",
          icon = "circle",
          event = "mizrp-paintball:game:interact",
          parameters = { "join", "east" },
      },
      {
          id = "paintballjoinwestteam",
          label = "Join West Team",
          icon = "circle",
          event = "mizrp-paintball:game:interact",
          parameters = { "join", "west" },
      },
      {
          id = "paintballjoinleaveteam",
          label = "Leave Team",
          icon = "circle",
          event = "mizrp-paintball:game:interact",
          parameters = { "leave" },
      },
      {
          id = "paintballjoinstartgame",
          label = "Start Game",
          icon = "circle",
          event = "mizrp-paintball:game:interact",
          parameters = { "start" },
      },
      {
          id = "paintballjoinsendgame",
          label = "End Game",
          icon = "circle",
          event = "mizrp-paintball:game:interact",
          parameters = { "end" },
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"paintball_signup"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
        id = "getminingprobe",
        label = "Get Probe",
        icon = "circle",
        event = "mizrp-mining:client:collectItem",
        parameters = {
            itemId = "miningprobe"
        }
    },
    {
        id = "getminingpickaxe",
        label = "Get Pickaxe",
        icon = "circle",
        event = "mizrp-mining:client:collectItem",
        parameters = {
            itemId = "miningpickaxe"
        }
    }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"mining_vendor"}
  }
}

Entries[#Entries + 1] = {
	type = 'flag',
	group = { 'isNPC' },
	data = {
		{
			id = "hoimports_pickup_sticks_deposit_stick",
			label = "Open Storage",
			icon = "box-open",
			event = "mizrp-hoimports:client:OpenDepositInventory",
			parameters = {
				id = "hoimports_pickup_sticks_deposit_stick"
			}
		},
		{
			id = "hoimports_pickup_sticks_confirm_delivery",
			label = "Deliver Sticks",
			icon = "check",
			event = "mizrp-hoimports:client:DepositSticks",
			parameters = {
				id = "hoimports_pickup_sticks_confirm_delivery"
			}
		},
		{
			id = "hoimports_pickup_sticks_claim_tax",
			label = "Claim Profits",
			icon = "horse-head",
			event = "mizrp-hoimports:client:ClaimTax",
			parameters = {
				id = "hoimports_pickup_sticks_claim_tax"
			}
		},
	},
	options = {
		distance = { radius = 2.5 },
		npcIds = {"hoimport_vendor"},
		isEnabled = function()
			local isEmployedAtHOImports = exports["mizrp-business"]:IsEmployedAt("hno_imports")
			local hasCraftAccess = exports["mizrp-business"]:HasPermission("hno_imports", "craft_access")
			return isEmployedAtHOImports and hasCraftAccess
		end,
	}
}

Entries[#Entries + 1] = {
	type = 'flag',
	group = { 'isNPC' },
	data = {
		{
			id = "hoimports_pickup_sticks_pickup_goods",
			label = "Pickup Goods",
			icon = "hand-spock",
			event = "mizrp-hoimports:client:PickupOrder",
			parameters = {
				id = "hoimports_pickup_sticks_pickup_goods"
			}
		},
	},
	options = {
		distance = { radius = 2.5 },
		npcIds = {"hoimport_vendor"},
		isEnabled = function()
			return true
		end,
	}
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "golfclubseller",
          label = "Browse Goods",
          icon = "circle",
          event = "warp-inventory:openGolfStore",
          parameters = {},
      },
      {
          id = "golfclubcaddyseller",
          label = "Get Caddy",
          icon = "circle",
          event = "mizrp-golf:spawnCaddy",
          parameters = {},
      },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"golfclubseller"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "licensekeeper",
          label = "Purchase License ($500.00)",
          icon = "id-card-alt",
          event = "warp-npcs:ped:licenseKeeper",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"npc_license_keeper_1", "npc_license_keeper_2"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "vendorlicensekeeper",
          label = "Get Vendor License",
          icon = "id-card-alt",
          event = "mizrp-farmersmarket:generateVendorLicense",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"npc_license_keeper_1"},
      isEnabled = function()
        return myJob == "judge" or myJob == "mayor" or myJob == "police" or myJob == "sheriff" or myJob == "state" or myJob == "deputy_mayor" or myJob == "county_clerk"
      end,
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "craftitemvendor",
          label = "Collect Farmers Market Items",
          icon = "hand-holding",
          event = "mizrp-farmersmarket:craftItem",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"fm_craft_shopkeeper"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "fmregisterbanner",
          label = "Register Farmers Market Banner",
          icon = "image",
          event = "mizrp-farmersmarket:registerBanner",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"fm_craft_shopkeeper"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwfindloststuff",
          label = "Find Lost Stuff",
          icon = "search",
          event = "mizrp-deanworld:findLostStuff",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_drop_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwbuyshitfood",
          label = "Purchase Food",
          icon = "hamburger",
          event = "mizrp-deanworld:buyShitFood",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_food_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwbuybumperupgrades",
          label = "Purchase Upgrades",
          icon = "circle",
          event = "mizrp-deanworld:purchaseRLUpgrades",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_bumper_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwdropoffstuff",
          label = "Drop Off",
          icon = "handshake",
          event = "mizrp-deanworld:dropOffCases",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_drop_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "dwadminentrance",
          label = "Buy Entrance Ticket",
          icon = "times-circle",
          event = "mizrp-deanworld:buyAdministrationTicket",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_admin_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "fmregisteritem",
          label = "Register Farmers Market Item",
          icon = "hamburger",
          event = "mizrp-farmersmarket:registerItem",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"fm_craft_shopkeeper"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "pcagrader",
          label = "Grade Items",
          icon = "circle",
          event = "mizrp-business:pcaGradeItems",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"dw_pca_grader_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "airxvendor",
          label = "Collect Parachute",
          icon = "parachute-box",
          event = "mizrp-business:collectAirXParachute",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"airx_1"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
      {
          id = "laptopvendor2",
          label = "Check Availability",
          icon = "clock",
          event = "warp-illegalactivities:check_availability",
      }
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"laptop_1"},
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "vehicle_rental_shit",
            label = "Open Rental Catalogue",
            icon = "circle",
            event = "warp-rentals:vehicles",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"vehicle_rental"},
    }
  }

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "drugdealer",
            label = "Get List",
            icon = "circle",
            event = "warp-drugsales:clockin",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"druggy"},
    }
  }

  
Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isWeaponShopKeeper' },
    data = {
        {
            id = "weaponshop_keeper",
            label = "Purchase weapons",
            icon = "circle",
            event = "weapon:general",
            parameters = {}
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isToolShopKeeper' },
    data = {
        {
            id = "toolshop_keeper",
            label = "Purchase tools",
            icon = "circle",
            event = "toolshop:general",
            parameters = { "4" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isSportShopKeeper' },
    data = {
        {
            id = "sportshop_keeper",
            label = "Purchase gear",
            icon = "circle",
            event = "warp-npcs:ped:keeper",
            parameters = { "34" }
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isWeedShopKeeper' },
  data = {
      {
          id = "weedshop_keeper",
          label = "Purchase Weed",
          icon = "cannabis",
          event = "warp-npcs:ped:weedSales",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isJobVehShopKeeper' },
  data = {
      {
          id = "jobveh_keeper",
          label = "Purchase Job Vehicle",
          icon = "car",
          event = "mizrp-showrooms:buyJobVehicles",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isWineryShopKeeper' },
  data = {
      {
          id = "winery_keeper",
          label = "Pick up Wine",
          icon = "wine-bottle",
          event = "mizrp-business:buyWineryWine",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isWineryShopKeeper' },
  data = {
      {
          id = "winery_keeper_goods",
          label = "Purchase Goods",
          icon = "wine-glass-alt",
          event = "mizrp-business:buyWineryGoods",
          parameters = {}
      }
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isCasinoChipSeller' },
    data = {
      {
          id = "casino_purchase_chips",
          label = "Purchase Chips",
          icon = "circle",
          event = "mizrp-casino:purchaseChipsAction",
          parameters = { "purchase" }
      },
      {
          id = "casino_withdraw_cash",
          label = "Cashout (Cash)",
          icon = "wallet",
          event = "mizrp-casino:purchaseChipsAction",
          parameters = { "withdraw:cash" }
      },
      {
          id = "casino_withdraw_bank",
          label = "Cashout (Bank)",
          icon = "university",
          event = "mizrp-casino:purchaseChipsAction",
          parameters = { "withdraw:bank" }
      },
      {
          id = "casino_transfer_chips",
          label = "Transfer Chips",
          icon = "circle",
          event = "mizrp-casino:purchaseChipsAction",
          parameters = { "transfer" }
      },
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isNPC' },
  data = {
    {
        id = "casino_wheel_spin_npc_toggle",
        label = "Toggle Wheel Enabled",
        icon = "circle",
        event = "mizrp-casino:wheel:toggleEnable",
    },
    {
        id = "casino_wheel_spin_npc_spin",
        label = "Spin Wheel! ($500)",
        icon = "dollar-sign",
        event = "mizrp-casino:wheel:spinWheel",
    },
    {
        id = "casino_wheel_spin_npc_turbo",
        label = "Turbo Spin! ($5,000)",
        icon = "dollar-sign",
        event = "mizrp-casino:wheel:spinWheelTurbo",
    },
    {
        id = "casino_wheel_spin_npc_omega",
        label = "Omega Spin! ($20,000)",
        icon = "dollar-sign",
        event = "mizrp-casino:wheel:spinWheelOmega",
    },
    {
        id = "casino_wheel_spin_npc_check",
        label = "Check Spent Amount",
        icon = "dollar-sign",
        event = "mizrp-casino:wheel:checkSpentAmount",
    },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"casino_wheel_spin_npc"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { '' },
  data = {
    {
        id = "cgchaincraft",
        label = "Craft Chainz",
        icon = "circle",
        event = "mizrp-clothing:openCGChainCrafting",
    },
    {
        id = "cgchaininfuse",
        label = "Infuse Chain",
        icon = "gem",
        event = "mizrp-clothing:infuseChainWithGems",
    },
  },
  options = {
      distance = { radius = 2.5 },
      npcIds = {"cgjvendor"}
  }
}

Entries[#Entries + 1] = {
  type = 'flag',
  group = { 'isCasinoMembershipGiver' },
  data = {
    {
        id = "casino_membership_giver",
        label = "Purchase Membership ($250)",
        icon = "circle",
        event = "mizrp-casino:purchaseMembershipCard",
        parameters = {}
    },
    {
        id = "casino_membership_giver_emp",
        label = "Get Membership Card",
        icon = "circle",
        event = "mizrp-casino:purchaseMembership",
        parameters = {}
    },
    {
        id = "casino_membership_loyalty",
        label = "Get Loyalty Card",
        icon = "circle",
        event = "mizrp-casino:getLoyaltyCard",
        parameters = {}
    },
  },
  options = {
      distance = { radius = 2.5 }
  }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "vehicleshoprenter",
            label = "Rent vehicle",
            icon = "circle",
            event = "mizrp-rentals:vehiclelist",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"veh_rental"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isCasinoLuckyWheel' },
    data = {
      {
          id = "casino_adjust_spin",
          label = "Enable/Disable Wheel!",
          icon = "adjust",
          event = "attempt:change:spin",
          parameters = {}
      },
      {
          id = "casino_adjust_slots",
          label = "Enable/Disable Slots!",
          icon = "adjust",
          event = "attempt:change:slot",
          parameters = {}
      },
    },
    options = {
        business = {"casino"},
        distance = { radius = 4.0 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isCasinoLuckyWheel' },
    data = {
        {
            id = "casino_spin_wheel",
            label = "Spin Wheel ($500)",
            icon = "money-bill-wave",
            event = "attempt:spin-in",
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isBarry' },
    data = {
        {
            id = "barry",
            label = "View personal impounded vehicles",
            icon = "car",
            event = "impound:barry",
        }
    },
    options = {
        distance = { radius = 2.5 }
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "pd_purchase_vehicle",
            label = "Purchase Police Vehicle",
            icon = "car",
            event = "PDSpawnVeh",
        }
    },
    options = {
        job = {"police", "state", "sheriff"},
        distance = { radius = 2.5 },
        npcIds = {"pd_benny"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "pd_spawn_heli",
            label = "Police Air Garage",
            icon = "helicopter",
            event = "spawn:hei:pd",
        }
    },
    options = {
        job = {"police", "state", "sheriff"},
        distance = { radius = 2.5 },
        npcIds = {"pd_pilot"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "ems_spawn_vehicle",
            label = "EMS Vehicles",
            icon = "car",
            event = "EMSSpawnVeh",
        }
    },
    options = {
        job = {"ems"},
        distance = { radius = 2.5 },
        npcIds = {"ems_spawn"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "ems_heli",
            label = "EMS Air Garage",
            icon = "helicopter",
            event = "spawn:hei:ems",
        }
    },
    options = {
        job = {"ems"},
        distance = { radius = 2.5 },
        npcIds = {"ems_pilot"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = 1,
            label = "Start Hunting ($500)",
            icon = "horse-head",
            event = "mizrp-hunting:start",
        },
        {
            id = "sell",
            label = "Return Hunting Gear",
            icon = "scroll",
            event = "mizrp-hunting:stop",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"hunting_shop"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "hunting_sell",
            label = "Sell Hunting Materials",
            icon = "money-bill-alt",
            event = "hunting:sell",
        }
    },
    options = {
        distance = { radius = 2.5 },
        npcIds = {"hunting_seller"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "fcadrive_npc",
            label = "Speak to Shady Dude",
            icon = "upload",
            event = "dude-menu",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"fc_shady_dude"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "lappy_npc",
            label = "Speak to Shady Dude",
            icon = "laptop",
            event = "lap-menu",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"lappy_shady_dude"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "nug_strap_dude",
            label = "Speak to Nug Strap Dude",
            icon = "book-dead",
            event = "nug-menu",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"nug_strap"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "toe_guy_man",
            label = "Can I suck on them toes?",
            icon = "book-dead",
            event = "toe-menu",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"toe_dude"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "meth_guy_bro",
            label = "Hand something over...",
            icon = "hand-holding",
            event = "meth:sell",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"meth_dude"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "meth_guy_bro_2",
            label = "Hand something over...",
            icon = "hand-holding",
            event = "meth:sell",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"meth_dude_2"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "chop_shop_donny",
            label = "Clock In",
            icon = "circle",
            event = "warp-chopshop:clock-in",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"chop_shop"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "chop_shop_donny_1",
            label = "Clock Out",
            icon = "circle",
            event = "warp-chopshop:clock-out",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"chop_shop"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "void_house_robberies_ped",
            label = "Get A Job",
            icon = "circle",
            event = "warp-houserobbery:getJob",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"void_house_robberies"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "void_fishing_start",
            label = "Start Fishing",
            icon = "circle",
            event = "warp-civjobs-fishing:start",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"evan_fishing"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "void_fishing_stop",
            label = "Stop Fishing",
            icon = "circle",
            event = "warp-fishing:stop",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"evan_fishing"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "evan_post_op_start",
            label = "Start Post OP",
            icon = "circle",
            event = "dreams-civjobs:start-post-op",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"evan_post_op"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "evan_post_op_stop",
            label = "Collect Post OP Paycheck",
            icon = "circle",
            event = "dreams-civjobs:post-op:paycheck",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"evan_post_op"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "evan_hunting_shit",
            label = "Purchase Hunting Equipment",
            icon = "circle",
            event = "dreams-hunting:equip",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"evan_hunting"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "evan_garbage_shit",
            label = "Sign In",
            icon = "trash-alt",
            event = "warp-jobs:garbagestart:menu",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"evan_garbage"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "pd_heli_shit",
            label = "Get PD Heli",
            icon = "helicopter",
            event = "police:spawnshitheli",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"pd_heli"},
        job = {"police", "state", "sheriff"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "cayo_heli",
            label = "Get Transport",
            icon = "helicopter",
            event = "cayo:spawnshitheli",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"cayo_heli"},
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "ems_ambulance",
            label = "Purchase Ambulance",
            icon = "car",
            event = "warp-garages:openBuyMenu2",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"purchase_car_ems"},
        job = {"ems"}
    }
}

Entries[#Entries + 1] = {
    type = 'flag',
    group = { 'isNPC' },
    data = {
        {
            id = "ems_heli_shit",
            label = "Get EMS Heli",
            icon = "helicopter",
            event = "ems:spawnshitheli",
        }
    },
    options = {
        distance = { radius = 1.5 },
        npcIds = {"ems_heli"},
        job = {"ems"}
    }
}

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