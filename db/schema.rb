# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 33) do

  create_table "block_patterns", :force => true do |t|
    t.string "name_of_pattern"
    t.string "block_url"
  end

  create_table "colors", :force => true do |t|
    t.string "name"
    t.string "color_group"
    t.string "value"
  end

  create_table "colors_listings", :id => false, :force => true do |t|
    t.integer "listing_id"
    t.integer "color_id"
  end

  create_table "exchanges", :force => true do |t|
    t.string   "status"
    t.decimal  "cost",         :precision => 8, :scale => 2
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "provider_id",                                :null => false
    t.integer  "recipient_id",                               :null => false
    t.string   "comments"
    t.boolean  "funds_xfr"
    t.integer  "listing_id"
  end

  create_table "exchanges_listings", :id => false, :force => true do |t|
    t.integer "listing_id"
    t.integer "exchange_id"
  end

  create_table "fabrics", :force => true do |t|
    t.string "fabric_type"
  end

  create_table "fabrics_listings", :id => false, :force => true do |t|
    t.integer "listing_id"
    t.integer "fabric_id"
  end

  create_table "listing_images", :force => true do |t|
    t.integer  "listing_id"
    t.string   "original_filename"
    t.string   "name"
    t.string   "content_type"
    t.binary   "data",              :limit => 16777215
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "listings", :force => true do |t|
    t.integer  "user_id",                                            :null => false
    t.string   "type"
    t.string   "listing_type"
    t.string   "status"
    t.string   "image_url"
    t.string   "description"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.float    "length"
    t.float    "width"
    t.decimal  "cost_per_yard",        :precision => 8, :scale => 2
    t.boolean  "treated"
    t.string   "treatment_method"
    t.string   "manufacturer"
    t.string   "fabric_line_name"
    t.string   "fabric_designer"
    t.integer  "number"
    t.string   "block_pattern_name"
    t.boolean  "complete"
    t.boolean  "kit_pattern_included"
    t.string   "kit_magazine_name"
    t.datetime "kit_magazine_issue"
    t.float    "finished_length"
    t.float    "finished_width"
    t.string   "magazine_name"
    t.string   "magazine_month"
    t.integer  "magazine_year"
    t.string   "color_list"
    t.string   "fabric_type"
    t.string   "pattern"
    t.string   "theme"
    t.decimal  "cost_of_exchange",     :precision => 8, :scale => 2
    t.datetime "magazine_issue"
  end

  create_table "listings_patterns", :id => false, :force => true do |t|
    t.integer "listing_id"
    t.integer "pattern_id"
  end

  create_table "listings_themes", :id => false, :force => true do |t|
    t.integer "listing_id"
    t.integer "theme_id"
  end

  create_table "patterns", :force => true do |t|
    t.string "pattern_type"
  end

  create_table "ratings", :force => true do |t|
    t.integer "rating"
    t.integer "rateable_id",   :null => false
    t.string  "rateable_type", :null => false
  end

  add_index "ratings", ["rateable_id", "rating"], :name => "index_ratings_on_rateable_id_and_rating"

  create_table "themes", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal_code"
    t.string   "phone"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "num_requests_filled"
    t.integer  "num_request_made"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "password"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "login"
    t.string   "password_reset_code",       :limit => 40
  end

end
