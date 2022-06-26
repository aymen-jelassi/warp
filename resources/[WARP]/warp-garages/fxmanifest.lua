game 'common'
fx_version 'bodacious'

client_scripts {
    '@warp-lib/client/cl_rpcother.lua',
    'client/*.lua',
    'shared/sh*.lua',
}

server_scripts {
    '@warp-lib/server/sv_rpcother.lua',
    '@warp-lib/server/sv_sql.lua',
    'server/*.lua',
    'shared/sh*.lua',
}
