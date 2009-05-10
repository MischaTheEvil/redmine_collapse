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
    # Compatibility helpers
    ###
    
    # Redmine Core 0.8-stable@r2229 (0.8.1)
    # Returns true if the method is defined, else it returns false
    def jump_to_current_view_implemented
      return Redmine::MenuManager::MenuController.method_defined?("redirect_to_project_menu_item")
    end
    
    # Redmine Core 0.8-stable@r2230 (0.8.1)
    # Returns true if the method is defined, else it returns false
    def render_flash_messages_implemented 
      return ApplicationHelper.method_defined?("render_flash_messages")
    end
    
    # Redmine Core trunk@r2304 (0.9-devel)
    # Returns true if the method is defined, else it returns false
    def render_project_hierarchy_implemented 
      return ProjectsHelper.method_defined?("render_project_hierarchy")
    end
    
    # Redmine Core trunk@r2485 (0.9-devel)
    # Returns true if the method is defined, else it returns false
    def page_header_title_implemented
      return ApplicationHelper.method_defined?("page_header_title")
    end
    
    # Redmine Core trunk@r2493 (0.9-devel)
    # Returns true if the constant is defined, else it returns false
    def rails_i18n_implemented
      return Redmine.const_defined?(:I18n)
    end
    
    ###
    # Tab helpers
    ###
    
    # Left-menu tabs renderer
    # Returns an array named 'tabs' containing the left-menu tabs to render
    def left_menu_tabs
      # Don't render the menus-tab nor the projects-tab unless specifically configured
      if Setting.plugin_redmine_collapse['show_menus_tab'] == '1' && Setting.plugin_redmine_collapse['show_projects_tab'] == '1'
        if rails_i18n_implemented
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
        if rails_i18n_implemented
          tabs = [ { :name => 'actions-tab', :label => :label_actions_tab, :partial => 'left_menu/actions.rhtml' },
                   { :name => 'menus-tab', :label => :label_menus_tab, :partial => 'left_menu/menus.rhtml' } ]
        else
          tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                   { :name => 'menus-tab', :label => l(:label_menus_tab), :partial => 'left_menu/menus.rhtml' } ]
        end
      # Don't render the projects-tab unless specifically configured
      elsif Setting.plugin_redmine_collapse['show_projects_tab'] == '1'
        if rails_i18n_implemented
          tabs = [ { :name => 'actions-tab', :label => :label_actions_tab, :partial => 'left_menu/actions.rhtml' },
                   { :name => 'projects-tab', :label => :label_projects_tab, :partial => 'left_menu/projects.rhtml' } ]
        else
          tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                   { :name => 'projects-tab', :label => l(:label_projects_tab), :partial => 'left_menu/projects.rhtml' } ]
        end
      # Always render the actions-tab
      else
        if rails_i18n_implemented
          tabs = [ { :name => 'actions-tab', :label => :label_actions_tab, :partial => 'left_menu/actions.rhtml' } ]
        else
          tabs = [ { :name => 'actions-tab', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' } ]
        end
      end
      
      return tabs
    end
    
    # Left-menu selected-tab based on active controller and activated-tabs settings
    # Returns a string named 'selectedtab' containing the name of the selected tab
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
    
    ###
    # Tab design helpers
    ###

    # List of additional themes that are supported by the Collapse plugin besides the default Redmine theme.
    # Others will use the 'default' Collapse plugin style.
    def supported_themes
      [
       'alternate',
       'classic',
       'basecamp',
       'squeejee'
      ]
    end
    
    # Determine the currently-used Redmine theme based on the global setting
    # Returns a string named 'currenttheme' containing the name of the current theme
    def current_redmine_theme
      if supported_themes.include?(Setting.ui_theme)
        currenttheme = Setting.ui_theme
      else
        currenttheme = 'default'
      end
      
      return currenttheme
    end
    
    # Renders the CSS-style used for selected project menu items in the projects-tab
    # Returns a string containing the style-name or nil
    def project_menu_item_class(selected=false)
      if selected
        'selected'
      else
        ''
      end
    end
    
    # Renders the CSS-style used for selected global menu items in the menus-tab
    # Returns a string containing the style-name or nil
    def global_menu_item_class(selected=false)
      if selected
        'alt-selected'
      else
        ''
      end
    end
    
    ###
    # Tab content helpers
    ###
    
    # Renders the projects as a nested set of unordered lists  (Redmine 0.9-devel)
    # The given collection may be a subset of the whole project tree
    # (eg. some intermediate nodes are private and can not be seen)
    # Returns a string containing the HTML for the bleeding-edge projects-tab
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
                        # Add 'selected'-class if the following condition is true
                        project_selected = project.identifier == @project.identifier
                        link_to(h(project), {:controller => 'projects', :action => 'show', :id => project, :jump => current_menu_item}, :class => project_menu_item_class(project_selected))
                      else
                        link_to(h(project), {:controller => 'projects', :action => 'show', :id => project})
                      end
          ancestors << project
        end
        s << ("</li></ul>\n" * ancestors.size)
      end
      
      return s
    end
    
    # Renders the projects as a tree of unordered lists (Redmine 0.8-stable)
    # Returns a string containing the HTML for the legacy projects-tab
    def render_projects_tree(projects)
      s = ''
      if projects.any?
        s << "<ul>\n"
        # Iterate over the root-projects
        projects.keys.sort.each do |root|
          if jump_to_current_view_implemented
            s << "<li>" +
                        # Only add ':jump => current_menu_item' URL-parameter if on project level
                        if !@project.nil?
                          # Add 'selected'-class if the following condition is true
                          project_selected = root.identifier == @project.identifier
                          link_to(h(root), {:controller => 'projects', :action => 'show', :id => root, :jump => current_menu_item}, :class => project_menu_item_class(project_selected))
                        else
                          link_to(h(root), {:controller => 'projects', :action => 'show', :id => root})
                        end
            s << "</li>\n"
          else
            s << "<li>" +
                        # Only add ':jump => current_menu_item' URL-parameter if on project level
                        if !@project.nil?
                          # Add 'selected'-class if the following condition is true
                          project_selected = root.identifier == @project.identifier
                          link_to(h(root), {:controller => 'projects', :action => 'show', :id => root}, :class => project_menu_item_class(project_selected))
                        else
                          link_to(h(root), {:controller => 'projects', :action => 'show', :id => root})
                        end
            s << "</li>\n"
          end
          s << "<ul>\n"
          # Iterate over the sub-projects
          projects[root].sort.each do |project|
            # Skip if the project is a root-project
            next if project == root
            if jump_to_current_view_implemented
              s << "<li>" +
                          # Only add ':jump => current_menu_item' URL-parameter if on project level
                          if !@project.nil?
                            # Add 'selected'-class if the following condition is true
                            project_selected = project.identifier == @project.identifier
                            link_to(h(project), {:controller => 'projects', :action => 'show', :id => project, :jump => current_menu_item}, :class => project_menu_item_class(project_selected))
                          else
                            link_to(h(project), {:controller => 'projects', :action => 'show', :id => project})
                          end
              s << "</li>\n"
            else
              s << "<li>" +
                          # Only add ':jump => current_menu_item' URL-parameter if on project level
                          if !@project.nil?
                            # Add 'selected'-class if the following condition is true
                            project_selected = project.identifier == @project.identifier
                            link_to(h(project), {:controller => 'projects', :action => 'show', :id => project}, :class => project_menu_item_class(project_selected))
                          else
                            link_to(h(project), {:controller => 'projects', :action => 'show', :id => project})
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
        
    # Renders the global menu as an unordered list (relies on backwards-compatibility in the core for the RESTful-routes of Redmine 0.9.x)
    # Returns an array named 'globalmenu' containing the HTML for the global menu section in the menus-tab
    def render_global_menu
      returning '' do |globalmenu|
        globalmenu << "<ul>\n"
        
        ## Global activity link ##
        # 'alt-selected'-class is added if the defined condition is true
        activity_selected = params[:controller] == 'projects' && params[:action] == 'activity' && params[:id].nil?
        globalmenu << content_tag(:li, link_to(l(:label_activity), { :controller => 'projects', :action => 'activity', :id => nil }, :class => global_menu_item_class(activity_selected)))
        
        ## Global issues link ##
        # 'alt-selected'-class is added if the defined condition is true
        issues_selected = params[:controller] == 'issues' && params[:action] == 'index' && params[:project_id].nil?
        globalmenu << content_tag(:li, link_to(l(:label_issue_plural), { :controller => 'issues', :id => nil }, :class => global_menu_item_class(issues_selected)))
        
        ## Global calendar link ##
        if User.current.allowed_to?(:view_calendar, @project, :global => true)
          # 'alt-selected'-class is added if the defined condition is true
          calendar_selected = params[:controller] == 'issues' && params[:action] == 'calendar' && params[:project_id].nil?
          globalmenu << content_tag(:li, link_to(l(:label_calendar), { :controller => 'issues', :action => 'calendar', :project_id => nil }, :class => global_menu_item_class(calendar_selected)))
        end
        
        ## Global gantt link ##
        if User.current.allowed_to?(:view_gantt, @project, :global => true)
          # 'alt-selected'-class is added if the defined condition is true
          gantt_selected = params[:controller] == 'issues' && params[:action] == 'gantt' && params[:project_id].nil?
          globalmenu << content_tag(:li, link_to(l(:label_gantt), { :controller => 'issues', :action => 'gantt', :project_id => nil }, :class => global_menu_item_class(gantt_selected)))
        end
        
        ## Global spent-time details link ##
        if User.current.allowed_to?(:view_time_entries, @project, :global => true)
          # 'alt-selected'-class is added if the defined condition is true
          spent_time_details_selected = params[:controller] == 'timelog' && params[:action] == 'details' && params[:project_id].nil?
          globalmenu << content_tag(:li, link_to(l(:label_spenttime_details), { :controller => 'timelog', :action => 'details', :project_id => nil }, :class => global_menu_item_class(spent_time_details_selected)))
        end
        
        ## Global spent-time report link ##
        if User.current.allowed_to?(:view_time_entries, @project, :global => true)
          # 'alt-selected'-class is added if the defined condition is true
          spent_time_report_selected = params[:controller] == 'timelog' && params[:action] == 'report' && params[:project_id].nil?
          globalmenu << content_tag(:li, link_to(l(:label_spenttime_report), { :controller => 'timelog', :action => 'report', :project_id => nil }, :class => global_menu_item_class(spent_time_report_selected)))
        end
        
        ## Global news link ##
        if User.current.allowed_to?(:view_news, @project, :global => true)
          # 'alt-selected'-class is added if the defined condition is true
          news_selected = params[:controller] == 'news' && params[:action] == 'index' && params[:project_id].nil?
          globalmenu << content_tag(:li, link_to(l(:label_news), { :controller => 'news', :action => 'index', :project_id => nil }, :class => global_menu_item_class(news_selected)))
        end
        
        globalmenu << "</ul>\n"
      end
    end    
  end # Close the module CollapseApplicationHelperPatch::InstanceMethods
end # Close the module CollapseApplicationHelperPatch
