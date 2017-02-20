Rails.configuration.to_prepare do
  require 'redmine_issue_field_visibility/issue_field_visibility_logic'
  require 'redmine_issue_field_visibility/patches/queries_helper_patch'
  require 'redmine_issue_field_visibility/patches/issues_helper_patch'
  require 'redmine_issue_field_visibility/patches/issue_patch'
  require 'redmine_issue_field_visibility/patches/issue_query_patch'
  require 'redmine_issue_field_visibility/patches/journal_patch'
end