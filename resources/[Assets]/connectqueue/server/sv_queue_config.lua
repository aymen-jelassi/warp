Config = {}

-- priority list can be any identifier. (hex steamid, steamid32, ip) Integer = power over other people with priority
-- a lot of the steamid converting websites are broken rn and give you the wrong steamid. I use https://steamid.xyz/ with no problems.
-- you can also give priority through the API, read the examples/readme.
Config.Priority = {
    
    -- Management / Owner | 100 --

    ["steam:1100001424368e2"] = 100, -- Shane
    ["steam:110000141a31d5d"] = 100, -- Bakers
    ["steam:1100001161769e9"] = 100, -- Ant

        -- Developer 90 --

    ["steam:110000143bd35ff"] = 90, -- Slump
    ["steam:1100001429eb87b"] = 90, -- Cool
    ["steam:110000145d1bc91"] = 90, -- Nic
    ["steam:11000013fcd2349"] = 90, -- Evan

        -- Admin 80 --

    ["steam:11000013d7a5937"] = 80, -- DT


        -- Diamond Priority [70] --

    -- Format ["steam:000000000000000"]

        -- Gold Priority [60] --

    -- Format ["steam:000000000000000"]

        -- Silver Priority [50] --

    -- Format ["steam:000000000000000"]

        -- Deserved Prio 40 --

    ["steam:110000114104c4e"] = 40, -- DSR

}

-- require people to run steam
Config.RequireSteam = true

-- "whitelist" only server
Config.PriorityOnly = false

-- disables hardcap, should keep this true
Config.DisableHardCap = true

-- will remove players from connecting if they don't load within: __ seconds; May need to increase this if you have a lot of downloads.
-- i have yet to find an easy way to determine whether they are still connecting and downloading content or are hanging in the loadscreen.
-- This may cause session provider errors if it is too low because the removed player may still be connecting, and will let the next person through...
-- even if the server is full. 10 minutes should be enough
Config.ConnectTimeOut = 600

-- will remove players from queue if the server doesn't recieve a message from them within: __ seconds
Config.QueueTimeOut = 120

-- will give players temporary priority when they disconnect and when they start loading in
Config.EnableGrace = true

-- how much priority power grace time will give
Config.GracePower = 80

-- how long grace time lasts in seconds
Config.GraceTime = 480

-- on resource start, players can join the queue but will not let them join for __ milliseconds
-- this will let the queue settle and lets other resources finish initializing
Config.JoinDelay = 60000

-- will show how many people have temporary priority in the connection message
Config.ShowTemp = false

-- simple localization
Config.Language = {
    joining = "\xF0\x9F\x8E\x89Joining...",
    connecting = "\xE2\x8F\xB3Connecting...",
    idrr = "\xE2\x9D\x97[Queue] Error: Couldn't retrieve any of your id's, try restarting.",
    err = "\xE2\x9D\x97[Queue] There was an error",
    pos = "\xF0\x9F\x90\x8CYou are %d/%d in queue \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[Queue] Error: Error adding you to connecting list",
    timedout = "\xE2\x9D\x97[Queue] Error: Timed out?",
    wlonly = "\xE2\x9D\x97[Queue] You must be part of the discord to join this server. To apply, head to : https://discord.gg/voidroleplay",
    steam = "\xE2\x9D\x97 [Queue] Error: Steam must be running"
}