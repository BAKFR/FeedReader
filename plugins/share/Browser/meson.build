PLUGIN_NAME = 'browser'

message('Share Plugin: Browser')
# Dependencies
browser_dependencies = [
  dependency('gtk+-3.0', version: '>=3.22'),
  dependency('glib-2.0'),
  dependency('libpeas-1.0'),
  dependency('gee-0.8'),
  dependency('sqlite3'),
  dependency('libsoup-2.4'),
  dependency('libsecret-1'),
  dependency('libxml-2.0'),
  dependency('webkit2gtk-4.0'),
  meson.get_compiler('vala').find_library('gd-1.0', dirs: VAPI_DIR)
]

resoures = gnome.compile_resources(
  PLUGIN_NAME,
  PLUGIN_NAME + '.gresource.xml',
  c_name: 'as'
)

