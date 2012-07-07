# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120707213816) do

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.integer  "weight"
    t.string   "response_class"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.boolean  "is_exclusive"
    t.integer  "display_length"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "default_value"
    t.string   "api_id"
    t.string   "display_type"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dependencies", :force => true do |t|
    t.integer  "question_id"
    t.integer  "question_group_id"
    t.string   "rule"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "dependency_conditions", :force => true do |t|
    t.integer  "dependency_id"
    t.string   "rule_key"
    t.integer  "question_id"
    t.string   "operator"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "finished_survey_email_lists", :force => true do |t|
    t.string   "name"
    t.string   "email_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "finished_surveys", :force => true do |t|
    t.string   "url"
    t.string   "grantee_name"
    t.string   "project_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "questionnaire_file_name"
    t.string   "questionnaire_content_type"
    t.integer  "questionnaire_file_size"
    t.datetime "questionnaire_updated_at"
  end

  create_table "mcoc_assets", :force => true do |t|
    t.integer  "mcoc_renewal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "supporting_doc_file_name"
    t.string   "supporting_doc_content_type"
    t.integer  "supporting_doc_file_size"
    t.datetime "supporting_doc_updated_at"
    t.string   "doc_name"
  end

  create_table "mcoc_constants", :force => true do |t|
    t.string   "mcoc_constant_name"
    t.string   "mcoc_constant_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mcoc_extapp_sessions", :force => true do |t|
    t.integer  "external_user_id"
    t.boolean  "is_active",        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mcoc_renewals", :force => true do |t|
    t.string   "grantee_name"
    t.string   "project_name"
    t.string   "component"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_ude_file_name"
    t.string   "attachment_ude_content_type"
    t.integer  "attachment_ude_file_size"
    t.datetime "attachment_ude_updated_at"
    t.integer  "hud_report_folder_id"
    t.integer  "questionnaire_folder_id"
    t.integer  "supporting_doc_folder_id"
    t.integer  "grantee_folder_id"
    t.integer  "project_folder_id"
    t.string   "doc_name"
    t.integer  "questionnaire_doc_name"
    t.string   "attachment_apr_file_name"
    t.string   "attachment_apr_content_type"
    t.integer  "attachment_apr_file_size"
    t.datetime "attachment_apr_updated_at"
    t.integer  "apr_report_folder_id"
    t.integer  "apr_report_doc_name"
  end

  create_table "mcoc_renewals_supporting_assets", :force => true do |t|
    t.integer  "renewals_id"
    t.string   "asset_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "supporting_file_name"
    t.string   "supporting_content_type"
    t.integer  "supporting_file_size"
  end

  create_table "mcoc_renewals_ude_assets", :force => true do |t|
    t.integer  "renewals_id"
    t.string   "asset_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ude_file_name"
    t.string   "ude_content_type"
    t.integer  "ude_file_size"
  end

  create_table "mcoc_user_renewals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mcoc_renewal_id"
    t.integer  "response_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mcoc_users", :force => true do |t|
    t.integer  "external_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question_groups", :force => true do |t|
    t.text     "text"
    t.text     "help_text"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.string   "display_type"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "api_id"
  end

  create_table "questions", :force => true do |t|
    t.integer  "survey_section_id"
    t.integer  "question_group_id"
    t.text     "text"
    t.text     "short_text"
    t.text     "help_text"
    t.string   "pick"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "display_type"
    t.boolean  "is_mandatory"
    t.integer  "display_width"
    t.string   "custom_class"
    t.string   "custom_renderer"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "correct_answer_id"
    t.string   "api_id"
  end

  create_table "response_sets", :force => true do |t|
    t.integer  "user_id"
    t.integer  "survey_id"
    t.string   "access_code"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "api_id"
  end

  add_index "response_sets", ["access_code"], :name => "response_sets_ac_idx", :unique => true

  create_table "responses", :force => true do |t|
    t.integer  "response_set_id"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "response_group"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.integer  "survey_section_id"
    t.string   "api_id"
  end

  add_index "responses", ["survey_section_id"], :name => "index_responses_on_survey_section_id"

  create_table "survey_sections", :force => true do |t|
    t.integer  "survey_id"
    t.string   "title"
    t.text     "description"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.integer  "display_order"
    t.string   "custom_class"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "surveys", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "access_code"
    t.string   "reference_identifier"
    t.string   "data_export_identifier"
    t.string   "common_namespace"
    t.string   "common_identifier"
    t.datetime "active_at"
    t.datetime "inactive_at"
    t.string   "css_url"
    t.string   "custom_class"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.integer  "display_order"
    t.string   "api_id"
  end

  add_index "surveys", ["access_code"], :name => "surveys_ac_idx", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "validation_conditions", :force => true do |t|
    t.integer  "validation_id"
    t.string   "rule_key"
    t.string   "operator"
    t.integer  "question_id"
    t.integer  "answer_id"
    t.datetime "datetime_value"
    t.integer  "integer_value"
    t.float    "float_value"
    t.string   "unit"
    t.text     "text_value"
    t.string   "string_value"
    t.string   "response_other"
    t.string   "regexp"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "validations", :force => true do |t|
    t.integer  "answer_id"
    t.string   "rule"
    t.string   "message"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
