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

ActiveRecord::Schema.define(:version => 20120109070218) do

  create_table "admins", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "studio_id"
    t.boolean  "configuration_only"
    t.boolean  "reporting_only"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "brandings", :force => true do |t|
    t.integer  "studio_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clips", :force => true do |t|
    t.string   "video_id"
    t.string   "thumbnail_url"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id",      :limit => 8
    t.boolean  "is_commentary"
    t.integer  "shares_count",  :limit => 8, :default => 0
  end

  add_index "clips", ["movie_id"], :name => "index_clips_on_movie_id"

  create_table "comments", :force => true do |t|
    t.string   "text"
    t.integer  "commented_at"
    t.integer  "movie_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string  "iso"
    t.string  "name"
    t.string  "printable_name"
    t.string  "iso3"
    t.integer "numcode"
  end

  create_table "coupon_redeemers", :force => true do |t|
    t.integer  "order_id"
    t.integer  "coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupon_redeemers", ["coupon_id"], :name => "index_coupon_redeemers_on_coupon_id"
  add_index "coupon_redeemers", ["order_id"], :name => "index_coupon_redeemers_on_order_id"

  create_table "coupons", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.string   "comments"
    t.datetime "expires_at"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "percent"
  end

  add_index "coupons", ["code"], :name => "index_coupons_on_code"
  add_index "coupons", ["movie_id"], :name => "index_coupons_on_movie_id"

  create_table "group_discounts", :force => true do |t|
    t.integer  "order_id"
    t.string   "discount_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hot_spots", :force => true do |t|
    t.integer  "movie_id"
    t.integer  "marked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ie_issues", :force => true do |t|
    t.boolean  "fb_popped_up"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
    t.integer  "user_id"
  end

  add_index "ie_issues", ["movie_id"], :name => "index_ie_issues_on_movie_id"
  add_index "ie_issues", ["user_id"], :name => "index_ie_issues_on_user_id"

  create_table "invitations", :force => true do |t|
    t.string   "email"
    t.string   "token"
    t.integer  "creator_id"
    t.integer  "redeemer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "studio_id"
    t.boolean  "configuration_only"
    t.boolean  "reporting_only"
  end

  create_table "ip_addresses", :force => true do |t|
    t.string   "ip"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", :force => true do |t|
    t.string   "link"
    t.string   "name"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_url"
    t.integer  "shares_count", :limit => 8, :default => 0
  end

  create_table "movie_metrics_reports", :force => true do |t|
    t.date     "date"
    t.integer  "movie_id_id"
    t.integer  "daily_active_users"
    t.integer  "page_views"
    t.integer  "page_view_unique"
    t.integer  "page_like"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movies", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
    t.integer  "studio_id"
    t.string   "facebook_fan_page_url"
    t.string   "cdn_path"
    t.string   "video_file_path"
    t.integer  "rental_length"
    t.string   "font_color_help"
    t.string   "button_color_gradient_1"
    t.string   "popup_bk_color_1"
    t.string   "description"
    t.string   "pay_dialog_title"
    t.string   "feed_dialog_link"
    t.string   "feed_dialog_name"
    t.string   "feed_dialog_caption"
    t.string   "button_color_gradient_2"
    t.string   "popup_bk_color_2"
    t.string   "action_box_top"
    t.string   "action_box_left"
    t.text     "facebook_share_text"
    t.text     "twitter_share_text"
    t.boolean  "released"
    t.boolean  "age_restricted"
    t.string   "facebook_fan_page_id"
    t.string   "brightcove_movie_id"
    t.string   "fb_comments_color"
    t.integer  "like_box_top"
    t.integer  "like_box_left"
    t.string   "action_link_name"
    t.string   "action_link_url"
    t.string   "discount_redirect_link"
    t.integer  "badge_number"
    t.string   "badge_text"
    t.boolean  "rental_badge"
    t.string   "original_video_link"
    t.string   "subtitled_video_link"
    t.string   "dubbed_video_link"
    t.integer  "series_id",                 :limit => 8
    t.integer  "position"
    t.boolean  "serial"
    t.string   "linter_url"
    t.string   "director"
    t.string   "lead_actors"
    t.datetime "year_released"
    t.string   "MPAA_rating",               :limit => 10
    t.string   "running_time",              :limit => 10
    t.boolean  "top_clips_enabled"
    t.boolean  "top_quotes_enabled"
    t.boolean  "top_bestsellers_enabled"
    t.float    "wysiwyg_watch_now_x"
    t.float    "wysiwyg_watch_now_y"
    t.float    "wysiwyg_rental_length_x"
    t.float    "wysiwyg_rental_length_y"
    t.float    "wysiwyg_share_buttons_x"
    t.float    "wysiwyg_share_buttons_y"
    t.float    "wysiwyg_fan_page_likers_x"
    t.float    "wysiwyg_fan_page_likers_y"
    t.float    "wysiwyg_coupon_code_x"
    t.float    "wysiwyg_coupon_code_y"
    t.string   "custom_button_watch_now",   :limit => 140
    t.string   "custom_link_coupon_code"
    t.boolean  "fb_likers_enabled"
  end

  add_index "movies", ["series_id"], :name => "index_movies_on_series_id"

  create_table "orders", :force => true do |t|
    t.string   "facebook_order_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "movie_id"
    t.datetime "rented_at"
    t.integer  "total_credits"
    t.integer  "user_id"
    t.string   "zip_code"
    t.float    "tax_collected"
    t.integer  "left_at"
    t.string   "flash_config_key"
  end

  create_table "page_visits", :force => true do |t|
    t.integer  "movie_id"
    t.string   "page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "paypals", :force => true do |t|
    t.string   "token",         :limit => 100
    t.string   "payerid",       :limit => 50
    t.string   "status",        :limit => 40
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "correlationid", :limit => 40
  end

  add_index "paypals", ["order_id"], :name => "index_paypals_on_order_id"

  create_table "quizzes", :force => true do |t|
    t.text     "question"
    t.text     "optiona"
    t.text     "optionb"
    t.text     "optionc"
    t.text     "optiond"
    t.integer  "movie_id"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "description"
    t.string   "accesstoken"
    t.string   "picture"
    t.string   "source"
    t.string   "fanpageurl"
    t.string   "message"
  end

  create_table "quotes", :force => true do |t|
    t.string   "text"
    t.integer  "quoted_at"
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shares_count", :limit => 8, :default => 0
  end

  create_table "redeem_discounts", :force => true do |t|
    t.integer  "order_id"
    t.integer  "group_discount_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_schedules", :force => true do |t|
    t.string   "report_name"
    t.integer  "report_id"
    t.string   "frequency"
    t.datetime "time"
    t.text     "email_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "series", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
    t.boolean  "enable_series_pass"
    t.integer  "studio_id"
  end

  create_table "shares", :force => true do |t|
    t.integer  "clip_id"
    t.integer  "like_id"
    t.integer  "quote_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shares", ["clip_id"], :name => "index_shares_on_clip_id"
  add_index "shares", ["like_id"], :name => "index_shares_on_like_id"
  add_index "shares", ["quote_id"], :name => "index_shares_on_quote_id"
  add_index "shares", ["user_id"], :name => "index_shares_on_user_id"

  create_table "skins", :force => true do |t|
    t.integer  "movie_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "purchase_background_file_name"
    t.string   "purchase_background_content_type"
    t.integer  "purchase_background_file_size"
    t.datetime "purchase_background_updated_at"
    t.string   "watch_background_file_name"
    t.string   "watch_background_content_type"
    t.integer  "watch_background_file_size"
    t.datetime "watch_background_updated_at"
    t.string   "splash_image_file_name"
    t.string   "splash_image_content_type"
    t.integer  "splash_image_file_size"
    t.datetime "splash_image_updated_at"
    t.string   "tax_popup_logo_file_name"
    t.string   "tax_popup_logo_content_type"
    t.integer  "tax_popup_logo_file_size"
    t.datetime "tax_popup_logo_updated_at"
    t.string   "tax_popup_icon_file_name"
    t.string   "tax_popup_icon_content_type"
    t.integer  "tax_popup_icon_file_size"
    t.datetime "tax_popup_icon_updated_at"
    t.string   "player_background_file_name"
    t.string   "player_background_content_type"
    t.integer  "player_background_file_size"
    t.datetime "player_background_updated_at"
    t.string   "facebook_dialog_icon_file_name"
    t.string   "facebook_dialog_icon_content_type"
    t.integer  "facebook_dialog_icon_file_size"
    t.datetime "facebook_dialog_icon_updated_at"
    t.string   "gallery_poster_file_name"
    t.string   "gallery_poster_content_type"
    t.integer  "gallery_poster_file_size"
    t.datetime "gallery_poster_updated_at"
  end

  create_table "streams", :force => true do |t|
    t.integer  "movie_id"
    t.string   "url"
    t.integer  "bitrate"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studios", :force => true do |t|
    t.string   "facebook_canvas_page"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "facebook_app_id"
    t.string   "name"
    t.string   "privacy_policy_url"
    t.text     "help_text"
    t.text     "viewing_details"
    t.integer  "max_ips_for_movie"
    t.string   "facebook_app_secret"
    t.string   "brightcove_id"
    t.string   "brightcove_key"
    t.boolean  "comment_stream_enabled"
    t.string   "white_listed_country_codes"
    t.string   "black_listed_country_codes"
    t.text     "copyright_notice"
    t.boolean  "group_buy_enabled"
    t.boolean  "paypal_enabled"
    t.string   "player",                     :limit => 40, :default => "milyoni"
    t.boolean  "series_enabled",                           :default => false
    t.string   "og_prefix"
    t.string   "paypal_api_user"
    t.string   "paypal_api_password"
    t.string   "paypal_api_signature"
    t.text     "gallery_footer_box"
    t.text     "gallery_header_box"
  end

  add_index "studios", ["player"], :name => "index_studios_on_player"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "twitterfeeds", :force => true do |t|
    t.integer  "movie_id"
    t.string   "img_url"
    t.text     "feed_text"
    t.datetime "time"
    t.string   "tweet_id"
    t.string   "user_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "facebook_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.date     "birthday"
    t.string   "email"
  end

end
