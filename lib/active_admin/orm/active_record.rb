# ActiveRecord-specific plugins should be required here

ActiveAdmin::DatabaseHitDuringLoad.database_error_classes << ActiveRecord::StatementInvalid

require "active_admin/orm/active_record/comments"
