require 'redmine'

# Patches to the Redmine core.
require 'collapse_application_helper_patch'

RAILS_DEFAULT_LOGGER.info 'Starting Collapse plugin for Redmine'

Redmine::Plugin.register :redmine_collapse do
  name 'Redmine Collapse plugin'
  author 'Mischa The Evil'
  description 'This is a plugin for Redmine which transforms the static sidebar into a collapsible sidebar'
  version '0.1.0'
  
  requires_redmine :version_or_higher => '0.8.0'
  
  settings :default => {
    'position' => '0',
    'show_projects_tab' => '1',
    'show_menus_tab' => '0',
    'show_projectmenu_in_menustab' => '0',
    'hide_project_selector' => '0'
  }, :partial => 'settings/collapse_settings'
end
