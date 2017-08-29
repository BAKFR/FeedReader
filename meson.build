project('FeedReader', ['vala', 'c'],
  version: '2.0.2',
  meson_version: '>= 0.41.0',
  license: 'GPL-3.0',
  default_options: ['prefix=/usr']
)


VAPI_DIR = join_paths(meson.current_source_dir(), 'vapi')


# Define the vapi dir
add_project_arguments(
  ['--vapidir', VAPI_DIR],
  language: 'vala'
)


# Dependencies
dependencies = [
  dependency('gtk+-3.0', version: '>=3.22'),
  dependency('glib-2.0'),
  dependency('gee-0.8'),
  dependency('json-glib-1.0'),
  dependency('libsoup-2.4'),
  dependency('sqlite3'),
  dependency('libsecret-1'),
  dependency('libnotify'),
  dependency('libxml-2.0'),
  dependency('rest-0.7'),
  dependency('webkit2gtk-4.0'),
  dependency('gstreamer-1.0'),
  dependency('gstreamer-pbutils-1.0'),
  dependency('libpeas-1.0'),
  meson.get_compiler('c').find_library('libcurl'),
  dependency('goa-1.0'),
  meson.get_compiler('vala').find_library('gd-1.0', dirs: VAPI_DIR),
  meson.get_compiler('vala').find_library('gtkimageview', dirs: VAPI_DIR),
  meson.get_compiler('vala').find_library('libvilistextum', dirs: VAPI_DIR),
  meson.get_compiler('vala').find_library('posix')
]

gnome = import('gnome')
i18n = import('i18n')


DATA_DIR = join_paths(get_option('prefix'), get_option('datadir'), meson.project_name())

conf = configuration_data()
conf.set('PREFIX', get_option('prefix'))
conf.set('VERSION', meson.project_version())
conf.set('PKGDATADIR', DATA_DIR)

subdir('schemas')
subdir('data')
subdir('libgd')
subdir('libgtkimageview')
subdir('libIvy')
subdir('libVilistextum')
subdir('po')
subdir('plugins')



constants = configure_file(
  input: 'Constants.vala.in',
  output: 'Constants.vala',
  configuration: conf
)




executable('feedreader-daemon',
  'src/Daemon.vala',
  install: true,
  install_dir: join_paths(get_option('prefix'), get_option('bindir')),
  dependencies: dependencies
)

executable(
  'feedreader',
  constants,
  'src/ActionCache.vala',
  'src/CachedActionManager.vala',
  'src/dbBase.vala',
  'src/dbDaemon.vala',
  'src/dbUI.vala',
  'src/DBusConnection.vala',
  'src/Enums.vala',
  'src/FavIconCache.vala',
  'src/FeedReader.vala',
  'src/FuncUtils.vala',
  'src/Logger.vala',
  'src/LoginInterface.vala',
  'src/Notification.vala',
  'src/QueryBuilder.vala',
  'src/Settings.vala',
  'src/Structs.vala',
  'src/Utils.vala',
  'src/UtilsDaemon.vala',
  'src/UtilsUI.vala',
  'src/Backend/FeedServer.vala',
  'src/Backend/FeedServerInterface.vala',
  'src/Backend/OPMLparser.vala',
  'src/ContentGrabber/grabber.vala',
  'src/ContentGrabber/grabberConfig.vala',
  'src/ContentGrabber/grabberUtils.vala',
  'src/ContentGrabber/grabberUtils.vala',
  'src/ContentGrabber/stringPair.vala',
  'src/Model/Article.vala',
  'src/Model/CachedAction.vala',
  'src/Model/Category.vala',
  'src/Model/Feed.vala',
  'src/Model/InterfaceState.vala',
  'src/Model/ShareAccount.vala',
  'src/Model/Tag.vala',
  'src/Share/ServiceSetup.vala',
  'src/Share/share.vala',
  'src/Share/ShareAccountInterface.vala',
  'src/Widgets/ArticleList/ArticleList.vala',
  'src/Widgets/ArticleList/ArticleListBox.vala',
  'src/Widgets/ArticleList/ArticleListEmptyLabel.vala',
  'src/Widgets/ArticleList/ArticleListEmptyLabel.vala',
  'src/Widgets/ArticleList/ArticleListScroll.vala',
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
  'src/Widgets/MediaButton.vala',
  'src/Widgets/MediaPlayer.vala',
  'src/Widgets/MediaRow.vala',
  'src/Widgets/ModeButton.vala',
  'src/Widgets/RemovePopover.vala',
  'src/Widgets/ResetPage.vala',
  'src/Widgets/ServiceInfo.vala',
  'src/Widgets/ServiceSettingsPopover.vala',
  'src/Widgets/Setting.vala',
  'src/Widgets/SettingsDialog.vala',
  'src/Widgets/SharePopover.vala',
  'src/Widgets/ShareRow.vala',
  'src/Widgets/ShortcutsWindow.vala',
  'src/Widgets/SimpleHeader.vala',
  'src/Widgets/SpringCleanPage.vala',
  'src/Widgets/TagPopover.vala',
  'src/Widgets/TagPopoverRow.vala',
  'src/Widgets/TagRow.vala',
  'src/Widgets/UpdateButton.vala',
  'src/Widgets/WebLoginPage.vala',
  install: true,
  install_dir: join_paths(get_option('prefix'), get_option('bindir')),
  dependencies: dependencies,
  link_with: libivy
)
