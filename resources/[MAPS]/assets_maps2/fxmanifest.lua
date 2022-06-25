this_is_a_map 'yes'

files {
	'gabztimecyclemods.xml',
	'shellprops.ytyp',
    'gabz_timecycle_mods_1.xml',
    'gabz_bennys_timecycle.xml',
    'gabzharmony.xml',
    'Void-pillbox/interiorproxies.meta',
    "gabz_mrpd_timecycle.xml",
    "interiorproxies_pdm.meta",
    "peds.meta",
    "gardoor_game.dat151.rel",
    'popcycle.dat',
}

data_file 'DLC_ITYP_REQUEST' 'shellprops.ytyp'
data_file 'TIMECYCLEMOD_FILE' 'gabztimecyclemods.xml'
data_file 'TIMECYCLEMOD_FILE' 'gabzharmony.xml'
data_file 'TIMECYCLEMOD_FILE' 'gabz_timecycle_mods_1.xml'
data_file 'TIMECYCLEMOD_FILE' 'gabz_bennys_timecycle.xml'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies_pdm.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'Void-pillbox/interiorproxies.meta'
data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/misc/shell-mansion/v_int_44.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/slbBuildings/def_props.ytyp'
data_file 'TIMECYCLEMOD_FILE' 'gabz_mrpd_timecycle.xml'
data_file "AUDIO_GAMEDATA" "gardoor_game.dat"
data_file "PED_METADATA_FILE" "peds.meta"
data_file 'POPSCHED_FILE' 'popcycle.dat'


client_scripts {
    "client.lua",
}

fx_version 'adamant'
games { 'gta5' }