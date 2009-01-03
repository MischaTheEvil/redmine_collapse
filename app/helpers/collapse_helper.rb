module CollapseHelper

  def left_menu_tabs
    if Setting.plugin_redmine_collapse['show_projects_tab'] == '1'
        tabs = [ { :name => 'actions', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' },
                 { :name => 'projects', :label => l(:label_projects_tab), :partial => 'left_menu/projects.rhtml' } ]
    else
        tabs = [ { :name => 'actions', :label => l(:label_actions_tab), :partial => 'left_menu/actions.rhtml' } ]
    end
    return tabs
  end

end