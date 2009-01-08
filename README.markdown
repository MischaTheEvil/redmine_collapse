# Redmine Collapse plugin

A plugin to transform the default Redmine sidebar into a collapseable sidebar on the left side.

## Features

* Replaces the Redmine core's sidebar
  * The provided sidebar is collapseable using JavaScript-helpers
  * The default sidebar-content is available on the default Actions-tab
  * An optional Projects-tab provides (nested) project-links of projects for which the current user has a role
    * on Redmine 0.8.0 project-links are pointing to project overviews
    * on Redmine 0.8.1 project-links are pointing to the currently-watched views in the selected project (if available)
* Optionally, the core's project-selector drop-down menu can be hidden
* Used strings can be centrally translated to every language (currently only English and Dutch are translated, for others stubs are provided)

## Compatibility

This plugin is compatible with the Redmine 0.8-Stable branch.

## Installation

1. Download the plugin using the latest archive file from [http://www.evil-dev.net][1].
2. Install the plugin as described at [http://www.redmine.org/wiki/redmine/Plugins][2] (this plugin doesn't require migration).
3. Login to your Redmine

## Configuration

This plugin can be configured under Administration -> Plugins -> Redmine Collapse plugin -> Configure. It provides the following implemented settings:
* Show the projects tab (default: yes)
* Hide the core project selector (default: no)

## Upgrade

1. Download the latest archive file from [http://www.evil-dev.net][1]
2. Unzip the file to your Redmine into the vendor/plugins directory
3. Restart your Redmine

## Credits

Thanks goes out to the following people:

* Eric Davis, Little Stream Software (http://www.littlestreamsoftware.com)
** Provided skeleton for Redmine core patches (see lib/collapse_application_helper_patch.rb)
* Sebastian Kurfürst, Typo3 Development Team (http://www.typo3.org)
** Author of the Redmine core hacks, to implement this feature for Typo3-Forge, used as a base for this plugin
* Lalit Patel, (http://www.lalit.org)
** Provided Javascript code to store data as JSON-strings in cookies (initially used by Sebastian)

## License

This plugin is licensed under the GNU GPL v2. See LICENSE.txt and GPL.txt for details.

## Project help

If you need help, would like to report a bug or request a new feature you can contact the 
maintainer at his [website][1]


[1]: http://www.evil-dev.net
[2]: http://www.redmine.org/wiki/redmine/Plugins
