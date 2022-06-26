local myJob = nil
local isPolice = false
local isEMS = false
local isBurger = false
local isArtGal = false
local isredCir = false
local isTow = false
local isCosmuic = false
local UnderGroundCas = false
local isWinery = false
local isRockford = false
local isDrift = false
local isPearls = false
local isCasino = false
local isBondiBoy = false
local isIllegalShop = false
local isSuit = false
local isVanillaUnicorn = false
local isAkcustoms = false
local isAOD = false
local isImportShop = false
local isBeanMachine = false
local isPDM = false
local isBahama = false

local accessCheckCache = {}
local accessCheckCacheTimer = {}
local businesses = {}
local businessesCacheTimer = nil

local securityAccess = {}

function setSecuredAccesses(pAccesses, pType)
    securityAccess[pType] = pAccesses
    accessCheckCache[pType] = {}
    accessCheckCacheTimer[pType] = {}
end

function clearAccessCache()
    for accessType, _ in pairs(accessCheckCache) do
        accessCheckCacheTimer[accessType] = {}
    end
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(500)
		local job = exports["isPed"]:isPed("myJob")
        local pRadicalCoffee = exports["isPed"]:GroupRank('radical_coffee')
        local pBurger = exports["isPed"]:GroupRank('burger_shot')
        local pBeanMachine = exports["isPed"]:GroupRank('radical_coffee')
        local pArtGal = exports["isPed"]:GroupRank('art_gallery')
        local pRedCircle = exports["isPed"]:GroupRank('red_circle')
        local pLost = exports["isPed"]:GroupRank('lostmc')
        local pMAF = exports["isPed"]:GroupRank('maf_racing')
        local pTuner = exports["isPed"]:GroupRank('tuner_shop')
        local pHayes = exports["isPed"]:GroupRank('hayes_autos')
        local pMPG = exports["isPed"]:GroupRank('mpg')
        local pPizzeria = exports["isPed"]:GroupRank('maldinis_pizzeria')
        local pCosmic = exports["isPed"]:GroupRank('cosmic_cannabis')
        local pUgCasino = exports["isPed"]:GroupRank('ug_casino')
        local pWinery = exports["isPed"]:GroupRank('winery')
        local pRockford = exports["isPed"]:GroupRank('rockford_records')
        local pDrift = exports["isPed"]:GroupRank('drift_school')
        local pPearls = exports["isPed"]:GroupRank('pearls')
        local pCasino = exports["isPed"]:GroupRank('casino')
        local pBondiBoy = exports["isPed"]:GroupRank('bondi_boys')
        local pIllegalShop = exports["isPed"]:GroupRank('illegal_shop')
        local pSuit = exports["isPed"]:GroupRank('suits')
        local pVanillaUnicorn = exports["isPed"]:GroupRank("vanilla_unicorn")
        local pAkcustoms = exports["isPed"]:GroupRank("ak_customs")
        local pAOD = exports["isPed"]:GroupRank("aod")
        local pImportShop = exports["isPed"]:GroupRank("import_shop")
        local pBahamaMammas = exports["isPed"]:GroupRank("bahama_mammas")
        local pPDM = exports["isPed"]:GroupRank("pdm")
        if isPolice and job ~= "police" then isPolice = false end
        if isEMS and job ~= "ems" then isEMS = false end
        if isDoc and job ~= "ems" then isDoc = false end
        if isTher and job ~= "ems" then isTher = false end
        if isTow and job ~= "towunion" then isTow = false end
        if job == "police" or job == "sheriff" or job == "state" then isPolice = true end
        if job == "ems" then isEMS = true end
        if job == "ems" then isDosc = true end
        if job == "ems" then isTher = true end
        if job == "suits" then isSuit = true end
        if job == "towunion" then isTow = true end
        if pBurger >= 1 then 
            isBurger = true 
        else
            isBurger = false
        end
        if pBeanMachine >= 1 then 
            isBeanMachine = true 
        else
            isBeanMachine = false
        end
        if pDrift >= 1 then 
            isDrift = true 
        else
            isDrift = false
        end
        if pArtGal >= 1 then 
            isArtGal = true 
        else
            isArtGal = false
        end
        if pPizzeria >= 1 then
            isPizza = true
        end
        if pRedCircle >= 1 then 
            isredCir = true 
        else
            isredCir = false
        end
        if pLost >= 1 then 
            isMC = true 
        else
            isMC = false
        end
        if pMAF >= 1 then 
            isMAF = true 
        else
            isMAF = false
        end
        if pTuner >= 1 then 
            isTuner = true 
        else
            isTuner = false
        end
        if pHayes >= 1 then 
            isHayes = true 
        else
            isHayes = false
        end
        if pMPG >= 1 then 
            isMPG = true 
        else
            isMPG = false
        end
        if pCosmic >= 1 then 
            isCosmuic = true
        else
            isCosmuic = false
        end
        if pUgCasino >= 1 then 
            UnderGroundCas = true 
        else 
            UnderGroundCas = false
        end
        if pWinery >= 1 then 
            isWinery = true 
        else 
            isWinery = false
        end
        if pRockford >= 1 then 
            isRockford = true 
        else 
            isRockford = false
        end
        if pPearls >= 1 then 
            isPearls = true 
        else 
            isPearls = false
        end
        if pCasino >= 1 then 
            isCasino = true 
        else 
            isCasino = false
        end
        if pBondiBoy >= 1 then 
            isBondiBoy = true 
        else 
            isBondiBoy = false
        end
        if pIllegalShop >= 1 then
            isIllegalShop = true
        else
            isIllegalShop = false
        end
        if pSuit >= 1 then
            isSuit = true
        else
            isSuit = false
        end
        if pVanillaUnicorn >= 1 then
            isVanillaUnicorn = true
        else
            isVanillaUnicorn = false
        end
        if pAkcustoms >= 1 then
            isAkcustoms = true
        else
            isAkcustoms = false
        end
        if pAOD >= 1 then
            isAOD = true
        else
            isAOD = false
        end
        if pBahamaMammas >= 1 then
            isBahama = true
        else
            isBahama = false
        end
        if pImportShop >= 1 then
            isImportShop = true
        else
            isImportShop = false
        end
        if pPDM >= 1 then
            isPDM = true
        else
            isPDM = false
        end
        clearAccessCache()
	end
end)


function isCop(job)
    return isPolice or isEMS
end

function isEMSActive()
    return isEMS
end

function isDoc()
    return isDoc
end

function isTher()
    return isTher
end

function isBurgerActive()
    return isBurger
end

function artGal()
    return isArtGal
end

function isRedActive()
    return isredCir
end

function isMCActive()
    return isMC
end

function isMAFActive()
    return isMAF
end

function isTunerActive()
    return isTuner
end

function isHayesActive()
    return isHayes
end

function isMPGActive()
    return isMPG
end

function isTowActive()
    return isTow
end

function isCosmuicActive()
    return isCosmuic
end

function isUGActive()
    return UnderGroundCas
end

function isWineryActive()
    return isWinery
end

function isRockfordActive()
    return isRockford
end

function isDriftSchool()
    return isDrift
end

function isPearlsActive()
    return isPearls
end

function isCasinoActive()
    return isCasino
end

function isBondiBoyActive()
    return isBondiBoy
end

function isBeanMachineActive()
    return isBeanMachine
end

function isIllegalShopActive()
    return isIllegalShop
end

function isSuitActive()
    return isSuit
end

function isVanillaUnicornActive()
    return isVanillaUnicorn
end

function isAkcustomsActive()
    return isAkcustoms
end

function isAODActive()
    return isAOD
end

function isBeanMachineActive()
    return isBeanMachine
end

function isImportShopActive()
    return isImportShop
end

function isPDMActive()
    return isPDM
end

function isBahmaActive()
    return isBahama
end

function hasSecuredAccess(pId, pType)
    if accessCheckCacheTimer[pType][pId] ~= nil and accessCheckCacheTimer[pType][pId] + 60000 > GetGameTimer() then -- 1 minute
        return accessCheckCache[pType][pId] == true
    end

    local characterId = exports["isPed"]:isPed("cid")

    accessCheckCacheTimer[pType][pId] = GetGameTimer()

    local job = exports["isPed"]:isPed("myJob")

    local authorized = securityAccess[pType][pId]

    if not authorized then return end

    if authorized.forceUnlocked then
      return false
    end

    if      (authorized.access.job and authorized.access.job[myJob] or false)
        or  (authorized.access.job["PD"] ~= nil and isCop(job))
        or  (authorized.access.job["police"] ~= nil and isCop(job))
        or  (authorized.access.job["EMS"] ~= nil and isEMSActive())
        or  (authorized.access.job["DR"] ~= nil and isDoc())
        or  (authorized.access.job["burger_shot"] ~= nil and isBurgerActive())
        or  (authorized.access.job["radical_coffee"] ~= nil and isBeanMachineActive())
        or  (authorized.access.job["art_gallery"] ~= nil and artGal())
        or  (authorized.access.job["redcircle"] ~= nil and isRedActive())
        or  (authorized.access.job["lostmc"] ~= nil and isMCActive())
        or  (authorized.access.job["maf_racing"] ~= nil and isMAFActive())
        or  (authorized.access.job["tuner_shop"] ~= nil and isTunerActive())
        or  (authorized.access.job["hayes_autos"] ~= nil and isHayesActive())
        or  (authorized.access.job["mpg"] ~= nil and isMPGActive())
        or  (authorized.access.job["towunion"] ~= nil and isTowActive())
        or  (authorized.access.job["cosmic_cannabis"] ~= nil and isCosmuicActive())
        or  (authorized.access.job["ugcasino"] ~= nil and isUGActive())
        or  (authorized.access.job["winery"] ~= nil and isWineryActive())
        or  (authorized.access.job["rockford_records"] ~= nil and isRockfordActive())
        or  (authorized.access.job["drift_school"] ~= nil and isDriftSchool())
        or  (authorized.access.job["pearls"] ~= nil and isPearlsActive())
        or  (authorized.access.job["casino"] ~= nil and isCasinoActive())
        or  (authorized.access.job["bondi_boy"] ~= nil and isBondiBoyActive())
        or (authorized.access.job["illegal_shop"] ~= nil and isIllegalShopActive())
        or (authorized.access.job["suits"] ~= nil and isSuitActive())
        or (authorized.access.job["vanilla_unicorn"] ~= nil and isVanillaUnicornActive())
        or (authorized.access.job["ak_customs"] ~= nil and isAkcustomsActive())
        or (authorized.access.job["aod"] ~= nil and isAODActive())
        or (authorized.access.job["import_shop"] ~= nil and isImportShopActive())
        or (authorized.access.job["PDM"] ~= nil and isPDMActive())
        or (authorized.access.job["bahama_mammas"] ~= nil and isBahmaActive())
        or (authorized.access.cid ~= nil and authorized.access.cid[characterId] ~= nil)
    then
        accessCheckCache[pType][pId] = true
        return true
    end

    if authorized.access.item ~= nil then
        accessCheckCacheTimer[pType][pId] = 0
        for i, v in pairs(authorized.access.item) do
            if exports["warp-inventory"]:hasEnoughOfItem(i, 1, false) then
                return true
            end
        end
    end
  
    accessCheckCache[pType][pId] = false
    return false
end