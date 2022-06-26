fx_version 'bodacious'
games { 'rdr3', 'gta5' }

client_scripts {
    'client_whitelist_jobs/cl_*.lua',
    'client_jobs/cl_*.lua',
    'hunting_client/cl_*.lua',
}

server_scripts {
    'hunting_server/sv_*.lua',
    'server_whitelist_jobs/server*.lua',
    'server_jobs/server*.lua',
    'server_jobs/sv_*.lua',
}

shared_scripts{
    'shared_jobs/cl_*.lua'
}