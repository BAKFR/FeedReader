message('TODO: Compiling resources')
UI_RESOURCES = gnome.compile_resources(
  'FeedReader',
  'org.gnome.FeedReader.gresource.xml'
)

message('TODO: Making a .desktop file')
i18n.merge_file(
  input: 'org.gnome.FeedReader.desktop.in',
  output: 'org.gnome.FeedReader.desktop',
  po_dir: '../po',
  type: 'desktop',
  install: true,
  install_dir: join_paths(get_option('prefix'), get_option('datadir'), 'applications')
)

i18n.merge_file(
  input: 'org.gnome.FeedReader-autostart.desktop.in',
  output: 'org.gnome.FeedReader-autostart.desktop',
  po_dir: '../po',
  type: 'desktop',
  install: true,
  install_dir: DATA_DIR
)

message('TODO: Preparing appdata')
i18n.merge_file(
  input: 'org.gnome.FeedReader.appdata.xml.in',
  output: 'org.gnome.FeedReader.appdata.xml',
  po_dir: '../po',
  install: true,
  install_dir: join_paths(get_option('prefix'), get_option('datadir'), 'appdata')
)

message('TODO: Preparing Daemon service')
configure_file(
  input:'org.gnome.FeedReader.Daemon.service.in',
  output: 'org.gnome.FeedReader.Daemon.service',
  configuration: conf,
  install_dir: join_paths(get_option('prefix'), get_option('datadir'), 'dbus-1/services')
)

subdir('application-icons')
