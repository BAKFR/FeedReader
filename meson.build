project('FeedReader', ['vala', 'c'],
  version: '2.0.2',
  meson_version: '>= 0.41.0',
  license: 'GPL-3.0',
  default_options: ['prefix=/usr']
)

# Constants (paths)
VAPI_DIR              = join_paths(meson.current_source_dir(), 'vapi')
DATA_DIR              = join_paths(get_option('prefix'),
                                    get_option('datadir'),
                                    meson.project_name())
PKGLIBDIR             = join_paths(get_option('prefix'),
                                    get_option('libdir'),
                                    meson.project_name())
SHARE_PLUGINS_DIR      = join_paths(PKGLIBDIR, 'pluginsShare')
BACKEND_PLUGINS_DIR    = join_paths(PKGLIBDIR, 'plugins')
BACKEND_UI_PLUGINS_DIR = join_paths(PKGLIBDIR, 'pluginsUI')

# Define the vapi dir
add_project_arguments(
  ['--vapidir', VAPI_DIR],
  language: 'vala'
)

# Modules
gnome = import('gnome')
i18n = import('i18n')

# Compilers
vala_compiler = meson.get_compiler('vala')
c_compiler = meson.get_compiler('c')
# Dependencies
gdk_pixbuf          = dependency('gdk-pixbuf-2.0')
gee                 = dependency('gee-0.8')
glib                = dependency('glib-2.0')
goa                 = dependency('goa-1.0')
gstreamer           = dependency('gstreamer-1.0')
gstreamer_pbutils   = dependency('gstreamer-pbutils-1.0')
gtk                 = dependency('gtk+-3.0', version: '>=3.22')
json_glib           = dependency('json-glib-1.0')
libcurl             = c_compiler.find_library('libcurl')
libnotify           =  dependency('libnotify')
libpeas             = dependency('libpeas-1.0')
libsecret           = dependency('libsecret-1')
libsoup             = dependency('libsoup-2.4')
libxml              = dependency('libxml-2.0')
linux               = vala_compiler.find_library('linux')
posix               = vala_compiler.find_library('posix')
rest                = dependency('rest-0.7')
sqlite3             = dependency('sqlite3')
webkit2gtk          = dependency('webkit2gtk-4.0')
# VAPI's
libgd_vapi          = vala_compiler.find_library('gd-1.0', dirs: VAPI_DIR)
gtkimageview_vapi   = vala_compiler.find_library('gtkimageview', dirs: VAPI_DIR)
libvilistextum_vapi = vala_compiler.find_library('libvilistextum', dirs: VAPI_DIR)
libivy_vapi         = vala_compiler.find_library('ivy', required: false,
                                                  dirs: join_paths(meson.build_root(), 'libIvy'))

libvilistextum  = declare_dependency(dependencies: libvilistextum_vapi)
libgd           = declare_dependency(dependencies: libgd_vapi)
libgtkimageview = declare_dependency(dependencies: gtkimageview_vapi)
libivy          = declare_dependency(dependencies: libivy_vapi)

# Configuration
conf = configuration_data()
conf.set('GETTEXT_PACKAGE', meson.project_name())
conf.set('PREFIX', get_option('prefix'))
conf.set('VERSION', meson.project_version())
conf.set('PKGDATADIR', DATA_DIR)
conf.set('PKGLIBDIR', PKGLIBDIR)


configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')
c_args = [
  '-include', 'config.h'
]


subdir('schemas')
subdir('data')
subdir('libgd')
subdir('libgtkimageview')
subdir('libIvy')
subdir('libVilistextum')
subdir('po')
subdir('plugins')
subdir('WebExtension')

FeedReaderCommon = library('FeedReaderCommon',
  [
    'src/Logger.vala',
    'src/Enums.vala',
    'src/FuncUtils.vala',
    'src/dbBase.vala',
    'src/Settings.vala',
    'src/Structs.vala',
    'src/Utils.vala',
    'src/QueryBuilder.vala',
    'src/ContentGrabber/grabberUtils.vala',
    'src/ContentGrabber/stringPair.vala',
    'src/Model/Feed.vala',
    'src/Model/Category.vala',
    'src/Model/Article.vala',
    'src/Model/Tag.vala',
    'src/Model/CachedAction.vala',
    'src/Model/InterfaceState.vala',
    'src/Model/ShareAccount.vala',
    configure_file(
      input: 'Constants.vala.in',
      output: 'Constants.vala',
      configuration: conf
    )
  ],
  c_args: c_args,
  dependencies: [
    gdk_pixbuf,
    gee,
    libivy,
    libsecret,
    libsoup,
    libvilistextum,
    libxml,
    sqlite3
  ],
  vala_vapi: 'FeedReaderCommon.vapi'
)
