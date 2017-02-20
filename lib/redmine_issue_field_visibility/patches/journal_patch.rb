module RedmineIssueFieldVisibility
  module Patches
    module JournalPatch
      def self.included(base)

        base.send(:include, JournalInstanceMethods)

        base.class_eval do

          def visible_details_with_issue_visibility(user=User.current)
            visible_details_without_issue_visibility(user).select do |detail|
              if 'Issue' == journalized_type
                journalized.with_hidden_core_fields_for_user(user) do
                  !journalized.hidden_core_fields.include?(detail.prop_key)
                end
              else
                true
              end
            end
          end

          # WARNING: if changed here change in issue_patch too
          def each_notification_with_issue_visibility(users, &block)
            users.group_by do |user|
              if user.admin?
                :admin
              else
                user.roles_for_project(project).sort
              end
            end.values.each do |part|
              each_notification_without_issue_visibility(part, &block)
            end
          end



          alias_method_chain :visible_details, :issue_visibility
          alias_method_chain :each_notification, :issue_visibility

        end
      end
    end

    module JournalInstanceMethods
      
    end
  end
end

unless Journal.included_modules.include?(RedmineIssueFieldVisibility::Patches::JournalPatch)
  Journal.send(:include, RedmineIssueFieldVisibility::Patches::JournalPatch)
end