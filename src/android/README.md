# 1.Plugin initialization
After working on plugin you need to execute this command 

    gradle -b plugin.gradle -q clean preparePlugin

This will create plugin-dependencies.jar archive in lib directory with all dependencies of project,
and generate content for plugin.xml related to this plugin. You may copy this content and paste to
plugin.xml in android platform.

