RPC.register("housing:getBankBalance", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT bank FROM characters WHERE id = @cid", {
        ["cid"] = pCid.param
    }))
    return data[1].bank
end)

RPC.register("housing:getProperties", function(pSource)
    local data = Await(SQL.execute("SELECT * FROM properties", {}))
    return data
end)

RPC.register("housing:resetProperty", function(pSource, pPropertyId)
    local data = Await(SQL.execute("UPDATE properties SET owner = NULL, cid = NULL, propertysold = @propertysold WHERE id = @propertyid", {
        ["propertysold"] = 1,
        ["propertyid"] = pPropertyId.param
    }))
end)

RPC.register("housing:getPropertyCount", function(pSource, pCid)
    local data = Await(SQL.execute("SELECT COUNT(*) AS total FROM properties WHERE cid = @cid", {
        ["cid"] = pCid.param
    }))
    return data[1].total
end)

RPC.register("housing:buyProperty", function(pSource, pCid, pPropertyId, pPropertyName, pPropertyPrice)
    local user = exports["warp-base"]:getModule("Player"):GetUser(pSource)
    local owner = GetPlayerIdentifier(pSource, 0)
    
    Await(SQL.execute("UPDATE characters SET bank = bank - @propertyprice WHERE id = @cid",{
        ["propertyprice"] = pPropertyPrice.param,
        ["cid"] = pCid.param
    }))

    local propertysold = 1
    local data = Await(SQL.execute("UPDATE properties SET owner = @owner, cid = @cid, propertysold = @propertysold WHERE id = @propertyid AND propertyname = @propertyname",{
        ["owner"] = owner,
        ["cid"] = pCid.param,
        ["propertysold"] = propertysold,
        ["propertyid"] = pPropertyId.param,
        ["propertyname"] = pPropertyName.param,
    }))

    return "success"
end)

function string:split( inSplitPattern, outResults )
    if not outResults then
      outResults = { }
    end
    local theStart = 1
    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    end
    table.insert( outResults, string.sub( self, theStart ) )
    return outResults
end

RPC.register("phone:lockProperty", function(pSource, pPropertyName)
    local data = Await(SQL.execute("UPDATE properties SET locked = 1 WHERE propertyname = @propertyname",{
        ["propertyname"] = pPropertyName.param
    }))

    return "success"
end)

RPC.register("phone:unlockProperty", function(pSource, pPropertyName)
    local data = Await(SQL.execute("UPDATE properties SET locked = 0 WHERE propertyname = @propertyname",{
        ["propertyname"] = pPropertyName.param
    }))

    return "success"
end)

RPC.register("phone:setGps", function(pSource, pPropertyName)
    local data = Await(SQL.execute("SELECT coords FROM properties WHERE propertyname = @propertyname",{
        ["propertyname"] = pPropertyName.param
    }))

    local coordstring = result[1].coords
    local coords = coordstring:split(",")
    local propertycoords = vector3(tonumber(coords[1]), tonumber(coords[2]), tonumber(coords[3]))

    return propertycoords
end)
