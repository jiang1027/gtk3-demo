
gnome = import('gnome')

demos = files([
	'application.c',
	'appwindow.c',
	'assistant.c',
	'builder.c',
	'button_box.c',
	'changedisplay.c',
	'clipboard.c',
	'colorsel.c',
	'combobox.c',
	'css_accordion.c',
	'css_basics.c',
	'css_multiplebgs.c',
	'css_pixbufs.c',
	'css_shadows.c',
	'dialog.c',
	'drawingarea.c',
	'editable_cells.c',
	'entry_buffer.c',
	'entry_completion.c',
	'expander.c',
	'hypertext.c',
	'iconview.c',
	'iconview_edit.c',
	'images.c',
	'infobar.c',
	'links.c',
	'list_store.c',
	'menus.c',
	'offscreen_window.c',
	'offscreen_window2.c',
	'overlay.c',
	'panes.c',
	'pickers.c',
	'pixbufs.c',
	'printing.c',
	'rotated_text.c',
	'search_entry.c',
	'sizegroup.c',
	'spinner.c',
	'stock_browser.c',
	'textview.c',
	'textscroll.c',
	'theming_style_classes.c',
	'theming_custom_css.c',
	'toolpalette.c',
	'transparent.c',
	'tree_store.c',
	'ui_manager.c'
])

extra_demo_sources = files([
	'main.c'
])

libgtk_dep = dependency('gtk+-3.0')

gtkdemo_args = [ 
	# '-DGDK_DISABLE_DEPRECATED', 
	# '-DGTK_DISABLE_DEPRECATED', 
	]

demo_cflags = []

gtkdemo_deps = ([libgtk_dep])

confinc = []

script_name = 'geninclude.pl'

demos_h = custom_target(
	'gtk3 demo header',
	output: 'demos.h',
	input: demos,
	command: [ find_program('perl'), '@CURRENT_SOURCE_DIR@/geninclude.pl', '@OUTPUT@', '@INPUT@' ],
)

gtkdemo_resources = gnome.compile_resources(
	'gtkdemo_resources',
	'demo.gresource.xml',
	source_dir: '.',
)
  
executable(
	'gtk3-demo',
	sources: [demos, demos_h, extra_demo_sources, gtkdemo_resources],
	c_args: gtkdemo_args + demo_cflags,
	dependencies: gtkdemo_deps,
	include_directories: confinc,
	win_subsystem: 'windows',
	install: true,
)
