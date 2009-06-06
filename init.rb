require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'
require 'collapse_application_helper_patch'
Dispatcher.to_prepare do
  ApplicationHelper.send(:include, CollapseApplicationHelperPatch)
end

RAILS_DEFAULT_LOGGER.info 'Starting Collapse plugin 0.2.2 for Redmine'

Redmine::Plugin.register :redmine_collapse do
  name 'Redmine Collapse plugin'
  author 'Mischa The Evil'
  description 'This is a plugin for Redmine which transforms the static sidebar into a collapsible sidebar with additional features'
  version '0.2.2'
  
  requires_redmine :version_or_higher => '0.8.0'
  
  settings :default => {
    'show_projects_tab' => '1',
    'hide_project_selector' => '0',
    'show_menus_tab' => '0',
    'show_projectmenu_in_menustab' => '0',
    'position' => '0'
  }, :partial => 'settings/collapse_settings'
end
