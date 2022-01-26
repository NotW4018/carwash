fx_version 'cerulean'
game 'gta5'

ui_page "html/index.html"

files {
  "html/index.html",
  "html/skripta.js",
  "html/css/*.css",
  "html/fonts/*",
}

client_script {
  'client.lua'
}

server_scripts{
  'server.lua'
}
