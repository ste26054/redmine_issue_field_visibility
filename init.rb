require 'redmine_issue_field_visibility'

Redmine::Plugin.register :redmine_issue_field_visibility do
  name 'Redmine Issue Field Visibility Plugin'
  url  'https://github.com/planio-gmbh/redmine_issue_field_visibility'

  description 'Hide core issue fields per role'

  author     'Jens Krämer, Planio GmbH'
  author_url 'https://plan.io/'

  version '1.0.1'

  requires_redmine version_or_higher: '2.6.0'

  settings partial: 'settings/redmine_issue_field_visibility', default: {}
end