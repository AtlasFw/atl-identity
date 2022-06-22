fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

name 'atl-identity'
author 'Atlas Framework Developers'

ui_page 'http://localhost:3000/'
files {
  'dist/**/*',
}

client_scripts {
  'client/*.lua'
}

provide 'identity'