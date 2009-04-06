require_dependency 'application_helper'

module CollapseApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
    
    ###
    # Compatibility validations
    ###
    
    # Redmine Core 0.8-stable@r2229 (0.8.1)
    # Returns true if the method is defined, else it returns false
    def jump_to_current_view_implemented
      if Redmine::MenuManager::MenuController.method_defined? "redirect_to_project_menu_item"
        return true
      else
        return false
      end
    end
    
    # Redmine Core 0.8-stable@r2230 (0.8.1)
    # Returns true if the method is defined, else it returns false
    def render_flash_messages_implemented 
      if ApplicationHelper.method_defined? "render_flash_messages" 
        return true
      else
        return false
      end
    end
    
    ###
    # Tab helpers
    ###
    
    # Left-menu tabs renderer
    # Returns the tabs-variable containing an array of the left-menu tabs to render
    def left_menu_tabs
      # Don't render the projects-tab unless specifically configured
      if Setting.plugin_redmine_collapse['show_projects_tab'] == '1'
        tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                 { :name => 'projects-tab', :label => l(:label_projects_tab), :partial => 'left_menu/projects.rhtml' } ]
      else
        tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' } ]
      end
      return tabs
    end
    
    # Left-menu selected-tab based on active controller and activated-tabs settings
    # Returns a string containing the name of the selected tab
    def left_menu_selected_tab
      if (Setting.plugin_redmine_collapse['show_projects_tab'] == '1' ) && ( params[:controller] == 'welcome' ||
                                                                             params[:controller] == 'account' ||
                                                                             params[:controller] == 'admin' ||
                                                                             params[:controller] == 'users' ||
                                                                             params[:controller] == 'roles' ||
                                                                             params[:controller] == 'trackers' ||
                                                                             params[:controller] == 'issue_statuses' ||
                                                                             params[:controller] == 'workflows' ||
                                                                             params[:controller] == 'custom_fields' ||
                                                                             params[:controller] == 'enumerations' ||
                                                                             params[:controller] == 'settings')
        selectedtab = 'projects-tab'
      else
        selectedtab = 'actions-tab'
      end
      return selectedtab
    end
    
    # Currently used Redmine Theme based on the global setting
    # Returns a string containing the name of the current theme
    def current_redmine_theme
      if (Setting.ui_theme == '')
        currenttheme = 'default'
      elsif (Setting.ui_theme == 'alternate')
        currenttheme = 'alternate'
      elsif (Setting.ui_theme == 'classic')
        currenttheme = 'classic'
      elsif (Setting.ui_theme == 'basecamp')
        currenttheme = 'basecamp'
      elsif (Setting.ui_theme == 'squeejee')
        currenttheme = 'squeejee'
      else
        currenttheme = 'default'
      end
      return currenttheme
    end
    
  end
end

ApplicationHelper.send(:include, CollapseApplicationHelperPatch)
