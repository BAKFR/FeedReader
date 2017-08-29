project('FeedReader', ['vala', 'c'],
  version: '2.0.2',
  meson_version: '>= 0.41.0',
  license: 'GPL-3.0',
  default_options: ['prefix=/usr']
)


VAPI_DIR = join_paths(meson.current_source_dir(), 'vapi')
PKGLIBDIR = join_paths(get_option('libdir'), meson.project_name())
SHARE_PLUGINS_DIR = join_paths(PKGLIBDIR, 'pluginsShare')
BACKEND_PLUGINS_DIR = join_paths(PKGLIBDIR, 'plugins')
BACKEND_UI_PLUGINS_DIR = join_paths(PKGLIBDIR, 'pluginsUI')

# Define the vapi dir
add_project_arguments(
  ['--vapidir', VAPI_DIR],
  language: 'vala'
)


gnome = import('gnome')
i18n = import('i18n')

vala_compiler = meson.get_compiler('vala')
c_compiler = meson.get_compiler('c')

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
posix               = vala_compiler.find_library('posix')
rest                = dependency('rest-0.7')
sqlite3             = dependency('sqlite3')
webkit2gtk          = dependency('webkit2gtk-4.0')
# VAPI's
libgd_vapi          = vala_compiler.find_library('gd-1.0', dirs: VAPI_DIR)
gtkimageview_vapi   = vala_compiler.find_library('gtkimageview', dirs: VAPI_DIR)
libvilistextum_vapi = vala_compiler.find_library('libvilistextum', dirs: VAPI_DIR)


DATA_DIR = join_paths(get_option('prefix'),
                      get_option('datadir'), meson.project_name())

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
#subdir('WebExtension')


libivy_vapi = vala_compiler.find_library('ivy', dirs: join_paths(meson.build_root(), 'libIvy'))


libvilistextum  = declare_dependency(dependencies: libvilistextum_vapi)
libgd           = declare_dependency(dependencies: libgd_vapi)
libgtkimageview = declare_dependency(dependencies: gtkimageview_vapi)
libivy          = declare_dependency(dependencies: libivy_vapi)

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

# GUI executable
executable('feedreader',
  'src/DBusConnection.vala',
  'src/FavIconCache.vala',
  'src/FeedReader.vala',
  'src/LoginInterface.vala',
  'src/dbUI.vala',
  'src/UtilsUI.vala',
  'src/Widgets/AddPopover.vala',
  'src/Widgets/ArticleRow.vala',
  'src/Widgets/ArticleView.vala',
  'src/Widgets/ArticleViewHeader.vala',
  'src/Widgets/ArticleViewLoadProgress.vala',
  'src/Widgets/ArticleViewUrlOverlay.vala',
  'src/Widgets/BackendInfoPopover.vala',
  'src/Widgets/CategorieRow.vala',
  'src/Widgets/ColorCircle.vala',
  'src/Widgets/ColorPopover.vala',
  'src/Widgets/ColumnView.vala',
  'src/Widgets/ColumnViewHeader.vala',
  'src/Widgets/FeedList.vala',
  'src/Widgets/FeedListFooter.vala',
  'src/Widgets/FeedRow.vala',
  'src/Widgets/FullscreenButton.vala',
  'src/Widgets/FullscreenHeader.vala',
  'src/Widgets/HoverButton.vala',
  'src/Widgets/ImagePopup.vala',
  'src/Widgets/InAppNotification.vala',
  'src/Widgets/InfoBar.vala',
  'src/Widgets/LoginPage.vala',
  'src/Widgets/LoginRow.vala',
  'src/Widgets/MainWindow.vala',
  'src/Widgets/MediaPlayer.vala',
  'src/Widgets/MediaButton.vala',
  'src/Widgets/MediaRow.vala',
  'src/Widgets/ModeButton.vala',
  'src/Widgets/RemovePopover.vala',
  'src/Widgets/ResetPage.vala',
  'src/Widgets/ServiceSettingsPopover.vala',
  'src/Widgets/ShareRow.vala',
  'src/Widgets/ShortcutsWindow.vala',
  'src/Widgets/ServiceInfo.vala',
  'src/Widgets/Setting.vala',
  'src/Widgets/SettingsDialog.vala',
  'src/Widgets/SharePopover.vala',
  'src/Widgets/SimpleHeader.vala',
  'src/Widgets/SpringCleanPage.vala',
  'src/Widgets/TagRow.vala',
  'src/Widgets/TagPopover.vala',
  'src/Widgets/TagPopoverRow.vala',
  'src/Widgets/UpdateButton.vala',
  'src/Widgets/WebLoginPage.vala',
  'src/Widgets/ArticleList/ArticleList.vala',
  'src/Widgets/ArticleList/ArticleListBox.vala',
  'src/Widgets/ArticleList/ArticleListEmptyLabel.vala',
  'src/Widgets/ArticleList/ArticleListScroll.vala',
  'src/Share/share.vala',
  'src/Share/ServiceSetup.vala',
  'src/Share/ShareAccountInterface.vala',
  UI_RESOURCES,
  dependencies: [
    gee,
    glib,
    goa,
    gstreamer,
    gstreamer_pbutils,
    gtk,
    json_glib,
    libgd,
    libgtkimageview,
    libnotify,
    libpeas,
    libsecret,
    libsoup,
    libxml,
    libvilistextum,
    posix,
    rest,
    sqlite3,
    webkit2gtk,
  ],
  vala_vapi: 'FeedReaderUI.vapi'
)

