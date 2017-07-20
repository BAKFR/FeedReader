project('FeedReader', 'c',
  version: '2.0.2',
  meson_verison: '>= 0.41.0',
  license: 'GPL-3.0'
)

# Dependencies
dependency('gtk+-3.0', version: '>=3.22')
dependency('json-glib-1.0')
dependency('libsoup-2.4')
dependency('sqlite3')
dependency('libsecret-1')
dependency('libnotify')
dependency('libxml-2.0')
dependency('rest-0.7')
dependency('webkit2gtk-4.0')
dependency('gstreamer-1.0')
dependency('gstreamer-pbutils-1.0')
dependency('libpeas-1.0')
dependency('libcurl')
dependency('goa-1.0')


gnome = import('gnome')
i18n = import('i18n')


DATA_DIR = join_paths(get_option('prefix'), get_option('datadir'), meson.project_name())

conf = configuration_data()
conf.set('PREFIX', get_option('prefix'))
conf.set('VERSION', meson.project_version())
conf.set('PKGDATADIR', DATA_DIR)

subdir('schemas')
subdir('data')
#subdir('libgd')
#subdir('libgtkimageview')
subdir('libVilistextum')
subdir('po')
subdir('src')
