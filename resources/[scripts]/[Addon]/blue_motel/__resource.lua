resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'froberg_motell'

version '1.0'

server_scripts {
	'@es_extended/locale.lua',
	'locales/sen.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'instance'
}
