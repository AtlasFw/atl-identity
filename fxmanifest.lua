fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'atl-identity'
author 'Atlas Framework Developers'

ui_page 'dist/index.html'

files {
  'dist/index.html',
  'dist/**/*',
}

client_scripts {
  'client/*.lua'
}

provide 'identity'