module RedmineIssueFieldVisibility
  module Patches
    module IssuesHelperPatch
      def self.included(base)

        base.send(:include, IssuesHelperInstanceMethods)

        base.class_eval do

          def email_issue_attributes_with_issue_visibility(issue, user)
            issue.with_hidden_core_fields_for_user(user) do
              email_issue_attributes_without_issue_visibility(issue, user)
            end
          end

          alias_method_chain :email_issue_attributes, :issue_visibility

        end
      end
    end

    module IssuesHelperInstanceMethods
      
    end
  end
end

unless IssuesHelper.included_modules.include?(RedmineIssueFieldVisibility::Patches::IssuesHelperPatch)
  IssuesHelper.send(:include, RedmineIssueFieldVisibility::Patches::IssuesHelperPatch)
end