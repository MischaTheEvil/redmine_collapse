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
    
    # Redmine Core trunk@r2304
    # Returns true if the method is defined, else it returns false
    def render_project_hierarchy_implemented 
      if ProjectsHelper.method_defined? "render_project_hierarchy" 
        return true
      else
        return false
      end
    end
    
    # Redmine Core trunk@r2485
    # Returns true if the method is defined, else it returns false
    def page_header_title_implemented
      if ApplicationHelper.method_defined? "page_header_title" 
        return true
      else
        return false
      end
    end
    
    # Redmine Core trunk@r2493
    # Returns true if the constant is defined, else it returns false
    def rails_i18n_implemented
      if Redmine.const_defined?(:I18n)
        return true
      else
        return false
      end
    end
    
    ###
    # Tab helpers
    ###
    
    # Renders the projects as a nested set of unordered lists  (Redmine 0.9.x)
    # The given collection may be a subset of the whole project tree
    # (eg. some intermediate nodes are private and can not be seen)
    # Returns a string containing the HTML for the bleeding-edge projects tab
    def render_projects_nestedset(projects)
      s = ''
      if projects.any?
        ancestors = []
        # Iterate over the projects
        projects.each do |project|
          if (ancestors.empty? || project.is_descendant_of?(ancestors.last))
            s << "<ul class='projects #{ ancestors.empty? ? 'root' : nil}'>\n"
          else
            ancestors.pop
            s << "</li>"
            while (ancestors.any? && !project.is_descendant_of?(ancestors.last)) 
              ancestors.pop
              s << "</ul></li>\n"
            end
          end
          classes = (ancestors.empty? ? 'root' : 'child')
          s << "<li>" +
                      # Only add ':jump => current_menu_item' URL-parameter if on project level
                      if !@project.nil?
                        # Only add ':class => selected' URL-parameter if the current project (@project) is equal to project (project)
                        if (project.identifier == @project.identifier)
                          link_to (h(project), {:controller => 'projects', :action => 'show', :id => project, :jump => current_menu_item}, :class => 'selected')
                        else
                          link_to (h(project), {:controller => 'projects', :action => 'show', :id => project, :jump => current_menu_item})
                        end
                      else
                        link_to (h(project), {:controller => 'projects', :action => 'show', :id => project})
                      end
          ancestors << project
        end
        s << ("</li></ul>\n" * ancestors.size)
      end
      return s
    end
    
    # Renders the projects as a tree of unordered lists (Redmine 0.8.x)
    # Returns a string containing the HTML for the legacy projects tab
    def render_projects_tree(projects)
      s = ''
      if projects.any?
        s << "<ul>\n"
        # Iterate over the root-projects
        projects.keys.sort.each do |root|
          if jump_to_current_view_implemented == true
            s << "<li>" +
                        # Only add ':jump => current_menu_item' URL-parameter if on project level
                        if !@project.nil?
                          # Only add ':class => selected' URL-parameter if the current project (@project) is equal to project (project)
                          if (root.identifier == @project.identifier)
                            link_to (h(root), {:controller => 'projects', :action => 'show', :id => root, :jump => current_menu_item}, :class => 'selected')
                          else
                            link_to (h(root), {:controller => 'projects', :action => 'show', :id => root, :jump => current_menu_item})
                          end
                        else
                          link_to (h(root), {:controller => 'projects', :action => 'show', :id => root})
                        end
            s << "</li>\n"
          else
            s << "<li>" +
                        # Only add ':jump => current_menu_item' URL-parameter if on project level
                        if !@project.nil?
                          # Only add ':class => selected' URL-parameter if the current project (@project) is equal to project (project)
                          if (root.identifier == @project.identifier)
                            link_to (h(root), {:controller => 'projects', :action => 'show', :id => root}, :class => 'selected')
                          else
                            link_to (h(root), {:controller => 'projects', :action => 'show', :id => root})
                          end
                        else
                          link_to (h(root), {:controller => 'projects', :action => 'show', :id => root})
                        end
            s << "</li>\n"
          end
          s << "<ul>\n"
          # Iterate over the sub-projects
          projects[root].sort.each do |project|
            # Skip if the project is a root-project
            next if project == root
            if jump_to_current_view_implemented == true
              s << "<li>" +
                          # Only add ':jump => current_menu_item' URL-parameter if on project level
                          if !@project.nil?
                            # Only add ':class => selected' URL-parameter if the current project (@project) is equal to project (project)
                            if (project.identifier == @project.identifier)
                              link_to (h(project), {:controller => 'projects', :action => 'show', :id => project, :jump => current_menu_item}, :class => 'selected')
                            else
                              link_to (h(project), {:controller => 'projects', :action => 'show', :id => project, :jump => current_menu_item})
                            end
                          else
                            link_to (h(project), {:controller => 'projects', :action => 'show', :id => project})
                          end
              s << "</li>\n"
            else
              s << "<li>" +
                          # Only add ':jump => current_menu_item' URL-parameter if on project level
                          if !@project.nil?
                            # Only add ':class => selected' URL-parameter if the current project (@project) is equal to project (project)
                            if (project.identifier == @project.identifier)
                              link_to (h(project), {:controller => 'projects', :action => 'show', :id => project}, :class => 'selected')
                            else
                              link_to (h(project), {:controller => 'projects', :action => 'show', :id => project})
                            end
                          else
                            link_to (h(project), {:controller => 'projects', :action => 'show', :id => project})
                          end
              s << "</li>\n"
            end
          end          
          s << "</ul>\n" # close the UL-element of the sub-projects iteration
        end
        s << "</ul>\n" # close the UL-element of the root-projects iteration
      end
      return s
    end
    
    # Renders the CSS-style used for selected global menu items
    # Returns a string containing the CSS-style name or nil
    def global_menu_item_class(selected=false)
      if selected
        'alt-selected'
      else
        ''
      end
    end
    
    # Renders the global menu as an unordered list (relies on backwards-compatibility in the core for the RESTful-routes of Redmine 0.9.x)
    # Returns an array named 'globalmenu' containing the HTML for the global menu
    def render_global_menu
      returning '' do |globalmenu|
        globalmenu << "<ul>\n"
        
        # Global activity link
        activity_selected = params[:controller] == 'projects' && params[:action] == 'activity' && params[:id].nil?
        globalmenu << content_tag(:li, link_to(l(:label_activity), { :controller => 'projects', :action => 'activity', :id => nil }, :class => global_menu_item_class(activity_selected)))
        
        # Global issues link
        issues_selected = params[:controller] == 'issues' && params[:action] == 'index' && params[:project_id].nil?
        globalmenu << content_tag(:li, link_to(l(:label_issue_plural), { :controller => 'issues', :id => nil }, :class => global_menu_item_class(issues_selected)))
        
        # Global calendar link
        if User.current.allowed_to?(:view_calendar, @project, :global => true)
          calendar_selected = params[:controller] == 'issues' && params[:action] == 'calendar' && params[:project_id].nil?
          globalmenu << content_tag(:li, link_to(l(:label_calendar), { :controller => 'issues', :action => 'calendar', :project_id => nil }, :class => global_menu_item_class(calendar_selected)))
        end
        
        # Global gantt link
        if User.current.allowed_to?(:view_gantt, @project, :global => true)
          gantt_selected = params[:controller] == 'issues' && params[:action] == 'gantt' && params[:project_id].nil?
          globalmenu << content_tag(:li, link_to(l(:label_gantt), { :controller => 'issues', :action => 'gantt', :project_id => nil }, :class => global_menu_item_class(gantt_selected)))
        end
        
        # Global spent-time details link
        if User.current.allowed_to?(:view_time_entries, @project, :global => true)
          spent_time_details_selected = params[:controller] == 'timelog' && params[:action] == 'details' && params[:project_id] == nil
          globalmenu << content_tag(:li, link_to(l(:label_spenttime_details), { :controller => 'timelog', :action => 'details', :project_id => nil }, :class => global_menu_item_class(spent_time_details_selected)))
        end
        
        # Global spent-time report link
        if User.current.allowed_to?(:view_time_entries, @project, :global => true)
          spent_time_report_selected = params[:controller] == 'timelog' && params[:action] == 'report' && params[:project_id] == nil
          globalmenu << content_tag(:li, link_to(l(:label_spenttime_report), { :controller => 'timelog', :action => 'report', :project_id => nil }, :class => global_menu_item_class(spent_time_report_selected)))
        end
        
        # Global news link
        if User.current.allowed_to?(:view_news, @project, :global => true)
          news_selected = params[:controller] == 'news' && params[:action] == 'index' && params[:project_id] == nil
          globalmenu << content_tag(:li, link_to(l(:label_news), { :controller => 'news', :action => 'index', :project_id => nil }, :class => global_menu_item_class(news_selected)))
        end
        
        globalmenu << "</ul>\n"
      end
    end
    
    # Left-menu tabs renderer
    # Returns an array named 'tabs' containing the left-menu tabs to render
    def left_menu_tabs
      # Don't render the menus-tab nor the projects-tab unless specifically configured
      if Setting.plugin_redmine_collapse['show_menus_tab'] == '1' && Setting.plugin_redmine_collapse['show_projects_tab'] == '1'
        if rails_i18n_implemented == true
          tabs = [ { :name => 'actions-tab', :label => :label_actions_tab, :partial => 'left_menu/actions.rhtml' },
                   { :name => 'menus-tab', :label => :label_menus_tab, :partial => 'left_menu/menus.rhtml' },
                   { :name => 'projects-tab', :label => :label_projects_tab, :partial => 'left_menu/projects.rhtml' } ]
        else
          tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                   { :name => 'menus-tab', :label => l(:label_menus_tab), :partial => 'left_menu/menus.rhtml' },
                   { :name => 'projects-tab', :label => l(:label_projects_tab), :partial => 'left_menu/projects.rhtml' } ]
        end
      # Don't render the menus-tab unless specifically configured
      elsif Setting.plugin_redmine_collapse['show_menus_tab'] == '1'
        if rails_i18n_implemented == true
          tabs = [ { :name => 'actions-tab', :label => :label_actions_tab, :partial => 'left_menu/actions.rhtml' },
                   { :name => 'menus-tab', :label => :label_menus_tab, :partial => 'left_menu/menus.rhtml' } ]
        else
          tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                   { :name => 'menus-tab', :label => l(:label_menus_tab), :partial => 'left_menu/menus.rhtml' } ]
        end
      # Don't render the projects-tab unless specifically configured
      elsif Setting.plugin_redmine_collapse['show_projects_tab'] == '1'
        if rails_i18n_implemented == true
          tabs = [ { :name => 'actions-tab', :label => :label_actions_tab, :partial => 'left_menu/actions.rhtml' },
                   { :name => 'projects-tab', :label => :label_projects_tab, :partial => 'left_menu/projects.rhtml' } ]
        else
          tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                   { :name => 'projects-tab', :label => l(:label_projects_tab), :partial => 'left_menu/projects.rhtml' } ]
        end
      # Always render the actions-tab
      else
        if rails_i18n_implemented == true
          tabs = [ { :name => 'actions-tab', :label => :label_actions_tab, :partial => 'left_menu/actions.rhtml' } ]
        else
          tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' } ]
        end
      end
      return tabs
    end
    
    # Left-menu selected-tab based on active controller and activated-tabs settings
    # Returns a string containing the name of the selected tab
    def left_menu_selected_tab
    # Initialize an array named "projecttab_controllers" containing the controllers on which the projects-tab should be activated by default
      projecttab_controllers = [ 'welcome', 'account', 'admin', 'users', 'roles', 'trackers', 'issue_statuses', 'workflows', 'custom_fields', 'enumerations', 'settings' ]
      
      # Activate the projects-tab by default if the projects-tab is activated and the "projecttab_controllers"-array contains the current :controller-param
      if (Setting.plugin_redmine_collapse['show_projects_tab'] == '1' ) && (projecttab_controllers.include?(params[:controller]))
        selectedtab = 'projects-tab'
      # Activate the menus-tab by default if the menus-tab is activated and the project-menu is shown in the menus-tab
      elsif (Setting.plugin_redmine_collapse['show_menus_tab'] == '1') && (Setting.plugin_redmine_collapse['show_projectmenu_in_menustab'] == '1')
        selectedtab = 'menus-tab'
      # Else activate the actions-tab by default
      else
        selectedtab = 'actions-tab'
      end
      return selectedtab
    end
    
    # Currently used Redmine Theme based on the global setting
    # Returns a string named 'currenttheme' containing the name of the current theme
    def current_redmine_theme
      case Setting.ui_theme
        when ''
          currenttheme = 'default'
        when 'alternate'
          currenttheme = 'alternate'
        when 'classic'
          currenttheme = 'classic'
        when 'basecamp'
          currenttheme = 'basecamp'
        when 'squeejee'
          currenttheme = 'squeejee'
        else
          currenttheme = 'default'
      end
      return currenttheme
    end
    
  end
end
