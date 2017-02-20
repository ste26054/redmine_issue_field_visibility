module RedmineIssueFieldVisibility
  module Patches
    module QueriesHelperPatch
      def self.included(base)

        base.send(:include, QueriesHelperInstanceMethods)

        base.class_eval do

          def column_content_with_issue_visibility(column, issue)
            column_content_without_issue_visibility(column, issue) unless issue.hidden_core_field?(column.name)
          end

          alias_method_chain :column_content, :issue_visibility

        end
      end
    end

    module QueriesHelperInstanceMethods
      
    end
  end
end

unless QueriesHelper.included_modules.include?(RedmineIssueFieldVisibility::Patches::QueriesHelperPatch)
  QueriesHelper.send(:include, RedmineIssueFieldVisibility::Patches::QueriesHelperPatch)
end