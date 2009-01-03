require 'redmine'

# Patches to the Redmine core.
require 'collapse_helper_inclusion.rb'

RAILS_DEFAULT_LOGGER.info 'Starting Collapse plugin for Redmine'

Redmine::Plugin.register :redmine_collapse do
  name 'Redmine Collapse plugin'
  author 'Mischa The Evil'
  description 'This is a plugin for Redmine which transforms the static sidebar into a collapseable sidebar'
  version '0.0.0'

  settings :default => {
    'position' => '0',
    'show_projects_tab' => '1',
    'hide_project_selector' => '0'
  }, :partial => 'settings/collapse_settings'
end
