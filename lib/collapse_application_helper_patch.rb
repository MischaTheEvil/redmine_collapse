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
    # Tab renderers
    ###
    
    # Left-menu tab renderer
    # Returns the tabs-variable containing an array of the left-menu tabs to render
    def left_menu_tabs
      # Don't render the projects-tab unless specifically configured
      if Setting.plugin_redmine_collapse['show_projects_tab'] == '1'
        tabs = [ { :name => 'actions', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                 { :name => 'projects', :label => l(:label_projects_tab), :partial => 'left_menu/projects.rhtml' } ]
      else
        tabs = [ { :name => 'actions', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' } ]
      end
      return tabs
    end
    
  end

end

ApplicationHelper.send(:include, CollapseApplicationHelperPatch)
