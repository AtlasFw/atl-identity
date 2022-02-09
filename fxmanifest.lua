fx_version 'cerulean'
game 'gta5'
use_fxv2_oal 'yes'
lua54 'yes'

name 'atl-identity'
author 'Atlas Framework Developers'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/**/*',
}

client_scripts {
    'client/*.lua'
}

provide 'identity'