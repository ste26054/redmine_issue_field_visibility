module RedmineIssueFieldVisibility
  module Patches
    module IssuePatch
      def self.included(base)

        base.send(:include, IssueInstanceMethods)

        base.class_eval do

          def disabled_core_fields_with_issue_visibility
            (disabled_core_fields_without_issue_visibility + hidden_core_fields).tap do |fields|
              fields.uniq!
            end
          end

          def hidden_core_field?(name)
            hidden_core_fields.include?(name.to_s) or
              hidden_core_fields.include?("#{name}_id")
          end

          def hidden_core_fields
            user = @user_for_hidden_core_fields || User.current
            @hidden_core_fields = {}
            @hidden_core_fields[user] ||= RedmineIssueFieldVisibility::hidden_core_fields user, project
          end

          def with_hidden_core_fields_for_user(user, &block)
            @user_for_hidden_core_fields = user
            yield
          ensure
            @user_for_hidden_core_fields = nil
          end

          # WARNING: if changed here change in journal_patch too
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


          alias_method_chain :disabled_core_fields, :issue_visibility
          alias_method_chain :each_notification, :issue_visibility

        end
      end
    end

    module IssueInstanceMethods
      RedmineIssueFieldVisibility::HIDEABLE_CORE_FIELDS.each do |field|
        define_method field do
          super() unless hidden_core_field?(field)
        end
      end
    end
  end
end

unless Issue.included_modules.include?(RedmineIssueFieldVisibility::Patches::IssuePatch)
  Issue.send(:include, RedmineIssueFieldVisibility::Patches::IssuePatch)
end