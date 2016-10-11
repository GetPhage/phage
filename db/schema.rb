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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161011172850) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: :cascade do |t|
    t.macaddr  "mac_address",                null: false
    t.inet     "ipv4",                                    array: true
    t.inet     "ipv6",                                    array: true
    t.string   "kind",                       null: false
    t.datetime "last_seen",                  null: false
    t.jsonb    "extra",       default: {},   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "name",                                    array: true
    t.boolean  "active",      default: true, null: false
    t.index ["extra"], name: "index_devices_on_extra", using: :gin
    t.index ["ipv4"], name: "index_devices_on_ipv4", using: :btree
    t.index ["ipv6"], name: "index_devices_on_ipv6", using: :btree
    t.index ["kind"], name: "index_devices_on_kind", using: :btree
    t.index ["mac_address"], name: "index_devices_on_mac_address", using: :btree
  end

  create_table "networks", force: :cascade do |t|
    t.string   "device_name",  null: false
    t.string   "string",       null: false
    t.integer  "device_type",  null: false
    t.string   "my_ipv4",      null: false
    t.string   "my_ipv6"
    t.string   "mac_address",  null: false
    t.string   "my_wifi_ssid"
    t.string   "netmask"
    t.string   "default_gw"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "product_categories", force: :cascade do |t|
    t.string   "name"
    t.boolean  "mobile"
    t.integer  "product_category_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["mobile"], name: "index_product_categories_on_mobile", using: :btree
    t.index ["name"], name: "index_product_categories_on_name", using: :btree
    t.index ["product_category_id"], name: "index_product_categories_on_product_category_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "samples", force: :cascade do |t|
    t.integer  "device_id",       null: false
    t.string   "mac_address",     null: false
    t.string   "ipv4",                         array: true
    t.string   "ipv6",                         array: true
    t.integer  "signal_strength"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["device_id"], name: "index_samples_on_device_id", using: :btree
    t.index ["ipv4"], name: "index_samples_on_ipv4", using: :btree
    t.index ["ipv6"], name: "index_samples_on_ipv6", using: :btree
    t.index ["mac_address"], name: "index_samples_on_mac_address", using: :btree
    t.index ["signal_strength"], name: "index_samples_on_signal_strength", using: :btree
  end

  create_table "scan_diffs", force: :cascade do |t|
    t.integer  "scan_id"
    t.integer  "device_id"
    t.string   "kind",                    null: false
    t.integer  "status",                  null: false
    t.jsonb    "extra",      default: {}, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["device_id"], name: "index_scan_diffs_on_device_id", using: :btree
    t.index ["extra"], name: "index_scan_diffs_on_extra", using: :gin
    t.index ["kind"], name: "index_scan_diffs_on_kind", using: :btree
    t.index ["scan_id"], name: "index_scan_diffs_on_scan_id", using: :btree
    t.index ["status"], name: "index_scan_diffs_on_status", using: :btree
  end

  create_table "scans", force: :cascade do |t|
    t.string   "scan_type",               null: false
    t.datetime "start",                   null: false
    t.datetime "end",                     null: false
    t.string   "notes",      default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["scan_type"], name: "index_scans_on_scan_type", using: :btree
    t.index ["start"], name: "index_scans_on_start", using: :btree
  end

  create_table "software_blacklists", force: :cascade do |t|
    t.string   "name",                    null: false
    t.string   "version",                 null: false
    t.string   "reason",     default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["name"], name: "index_software_blacklists_on_name", using: :btree
    t.index ["reason"], name: "index_software_blacklists_on_reason", using: :btree
  end

  add_foreign_key "product_categories", "product_categories"
  add_foreign_key "scan_diffs", "devices"
  add_foreign_key "scan_diffs", "scans"
end
