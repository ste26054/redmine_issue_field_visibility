module RedmineIssueFieldVisibility
  module Patches
    module IssueQueryPatch
      def self.included(base)

        base.send(:include, IssueQueryInstanceMethods)

        base.class_eval do

          def initialize_available_filters_with_issue_visibility
            initialize_available_filters_without_issue_visibility

            RedmineIssueFieldVisibility::hidden_core_fields(User.current, project).each do |field|
              delete_available_filter field
            end
          end

          def available_columns_with_issue_visibility
            return @available_columns if @available_columns
            
            available_columns_without_issue_visibility
            @available_columns.reject! do |col|
              hidden_core_fields.include? col.name.to_s
            end
            @available_columns
          end

          def hidden_core_fields
            @hidden_core_fields ||= RedmineIssueFieldVisibility::hidden_core_fields(User.current, project)
          end

          alias_method_chain :available_columns, :issue_visibility
          alias_method_chain :initialize_available_filters, :issue_visibility

        end
      end
    end

    module IssueQueryInstanceMethods
      
    end
  end
end

unless IssueQuery.included_modules.include?(RedmineIssueFieldVisibility::Patches::IssueQueryPatch)
  IssueQuery.send(:include, RedmineIssueFieldVisibility::Patches::IssueQueryPatch)
end