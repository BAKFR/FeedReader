lib_ivy = library(
  'ivy',
  [
    'Extractor.vala',
    'Frame.vala',
    'Printer.vala',
    'Stacktrace.vala'
  ],
  dependencies: [
    dependency('gee-0.8'),
    meson.get_compiler('vala').find_library('posix'),
    meson.get_compiler('vala').find_library('linux')
  ],
  vala_vapi: 'ivy.vapi'
)
