gnome = import('gnome')

files = files([
	'widget-factory.c'
])

libgtk_dep = dependency('gtk+-3.0')

gtkdemo_args = [ 
	# '-DGDK_DISABLE_DEPRECATED', 
	# '-DGTK_DISABLE_DEPRECATED', 
	]

demo_cflags = []

gtkdemo_deps = ([libgtk_dep])


widget_factory_resources = gnome.compile_resources(
	'widget_factory_resources',
	'widget-factory.gresource.xml',
	source_dir: '.',
)
  
executable(
	'widget-factory',
	sources: [files, widget_factory_resources],
	c_args: gtkdemo_args + demo_cflags,
	dependencies: gtkdemo_deps,
	win_subsystem: 'windows',
	install: true,
)
