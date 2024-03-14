Silent's ASI Loader 1.3


DESCRIPTION

	This is a DLL file which adds ASI plugin loading functionality to San Andreas.
	What makes it better from any other ASI Loaders available?

	*	Increased compatibility - all current loaders share a flaw, which sometimes results in a plugin loading failure. This loader uses a brand new
		loading method developed by NTAuthority, which makes it work all the time.
	*	Compatible with 3.0 (old Steam) and new Steam Executables.
	*	Loads files located in the game root directory and 'scripts' folder (although not all the plugins are guaranteed to work properly when located
		in the latter!).
	*	Has an INI file in which you can toggle on/off plugins loading.
	*	Has an ability of loading plugins exclusive for specific Executable and/or exclude another plugins from loading on specific Executable.
	*	Lightweight and fast.
	*	When an encrypted EXE (like Steam EXE) is used, plugins are loaded after it gets decrypted - no need to wait in the ASI code.

	This loader is also used in Grand Theft Auto: Vice City Stories PC Edition and Vigilante Justice Total Conversions.


INSTALLATION

	In order to install it, you just need to place both DLL provided files into game directory, overwriting the old files.


USAGE

	Basic Plugin Installation:
		If you want to add an ASI for all Executable versions you have, put it either in game root directory or 'scripts' folder.
		Various plugins may fail to work properly when running from 'scripts' folder, it is advised to move it to the game directory if plugin fails to
		launch properly.

	Advanced Plugin Installation:
		If you have multiple Executable versions and want to make each one use different ASI plugins, you can create a new folder inside 'scripts' folder
		with the same name as your Executable (so gta_sa.exe gets gta_sa folder, my_fancy_exe.exe gets my_fancy_exe folder etc.). Plugins placed in this
		folder will be exclusive to specific Executable.
		You also can make specific Executables override global settings and load/ignore all plugins via settings.ini edit. Specific Executable can also
		ignore only some of the plugins - see 'advanced_plugin_management_example' for more info.


CREDITS & LICENSE

	Firstly, thanks to NTAuthority for sharing his code snippet, and also for Stanislav "listener" Golovin for sharing his
	ASI Loader source, which acted as a base for my version of the tool.
	As the following tool is open source (source is NOT included in this package), it's under the Silent's License.
	It means that the source code is for learning purposes, as all source code is. You may only use it for your own projects
	but NOT to recreate or build on the original work.


CONTACT

	zdanio95@gmail.com - e-mail
	zdanio95 - Skype

Follow my Twitter account to be up to all my mods updates!
http://twitter.com/__silent_