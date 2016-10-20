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

ActiveRecord::Schema.define(version: 20161020165847) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cves", force: :cascade do |t|
    t.string   "name"
    t.string   "seq"
    t.string   "status"
    t.string   "desc"
    t.string   "refs"
    t.string   "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["desc"], name: "index_cves_on_desc", using: :btree
    t.index ["name"], name: "index_cves_on_name", using: :btree
    t.index ["seq"], name: "index_cves_on_seq", using: :btree
  end

  create_table "devices", force: :cascade do |t|
    t.macaddr  "mac_address",                      null: false
    t.inet     "ipv4",                                          array: true
    t.inet     "ipv6",                                          array: true
    t.string   "kind",                             null: false
    t.datetime "last_seen",                        null: false
    t.jsonb    "extra",             default: {},   null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "name",                                          array: true
    t.boolean  "active",            default: true, null: false
    t.integer  "oui_id"
    t.string   "firmware_version"
    t.integer  "product_id"
    t.string   "serial_number"
    t.string   "model_number"
    t.string   "model_shortname"
    t.string   "upc"
    t.string   "model_description"
    t.integer  "udpv4",             default: [],                array: true
    t.integer  "tcpv4",             default: [],                array: true
    t.integer  "udpv6",             default: [],                array: true
    t.integer  "tcpv6",             default: [],                array: true
    t.index ["extra"], name: "index_devices_on_extra", using: :gin
    t.index ["firmware_version"], name: "index_devices_on_firmware_version", using: :btree
    t.index ["ipv4"], name: "index_devices_on_ipv4", using: :btree
    t.index ["ipv6"], name: "index_devices_on_ipv6", using: :btree
    t.index ["kind"], name: "index_devices_on_kind", using: :btree
    t.index ["mac_address"], name: "index_devices_on_mac_address", using: :btree
    t.index ["model_description"], name: "index_devices_on_model_description", using: :btree
    t.index ["oui_id"], name: "index_devices_on_oui_id", using: :btree
    t.index ["product_id"], name: "index_devices_on_product_id", using: :btree
    t.index ["tcpv4"], name: "index_devices_on_tcpv4", using: :gin
    t.index ["tcpv6"], name: "index_devices_on_tcpv6", using: :gin
    t.index ["udpv4"], name: "index_devices_on_udpv4", using: :gin
    t.index ["udpv6"], name: "index_devices_on_udpv6", using: :gin
    t.index ["upc"], name: "index_devices_on_upc", using: :btree
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string   "name"
    t.string   "web"
    t.string   "support_url"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name"], name: "index_manufacturers_on_name", using: :btree
  end

  create_table "mdns", force: :cascade do |t|
    t.string   "hostname"
    t.string   "service"
    t.string   "protocol"
    t.integer  "device_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "txt",                     null: false
    t.inet     "ipv4",       default: [],              array: true
    t.inet     "ipv6",       default: [],              array: true
    t.integer  "port",                    null: false
    t.jsonb    "extra",      default: {}, null: false
    t.index ["device_id"], name: "index_mdns_on_device_id", using: :btree
    t.index ["extra"], name: "index_mdns_on_extra", using: :gin
    t.index ["hostname"], name: "index_mdns_on_hostname", using: :btree
    t.index ["ipv4"], name: "index_mdns_on_ipv4", using: :gin
    t.index ["ipv6"], name: "index_mdns_on_ipv6", using: :gin
    t.index ["port"], name: "index_mdns_on_port", using: :btree
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

  create_table "ouis", force: :cascade do |t|
    t.string   "prefix",       limit: 6, null: false
    t.string   "manufacturer",           null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["manufacturer"], name: "index_ouis_on_manufacturer", using: :btree
    t.index ["prefix"], name: "index_ouis_on_prefix", using: :btree
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
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "manufacturer_id"
    t.string   "name",            null: false
    t.index ["manufacturer_id"], name: "index_products_on_manufacturer_id", using: :btree
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

  create_table "services", force: :cascade do |t|
    t.string   "name",                     null: false
    t.integer  "port_number",              null: false
    t.string   "protocol",    default: "", null: false
    t.string   "description", default: "", null: false
    t.string   "reference",   default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["name"], name: "index_services_on_name", using: :btree
    t.index ["port_number"], name: "index_services_on_port_number", using: :btree
    t.index ["protocol"], name: "index_services_on_protocol", using: :btree
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

  create_table "upnps", force: :cascade do |t|
    t.integer  "device_id"
    t.string   "st"
    t.string   "usn"
    t.string   "location"
    t.string   "cache_control"
    t.string   "server"
    t.string   "ext"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["cache_control"], name: "index_upnps_on_cache_control", using: :btree
    t.index ["device_id"], name: "index_upnps_on_device_id", using: :btree
    t.index ["ext"], name: "index_upnps_on_ext", using: :btree
    t.index ["location"], name: "index_upnps_on_location", using: :btree
    t.index ["server"], name: "index_upnps_on_server", using: :btree
    t.index ["st"], name: "index_upnps_on_st", using: :btree
    t.index ["usn"], name: "index_upnps_on_usn", using: :btree
  end

  add_foreign_key "devices", "ouis"
  add_foreign_key "devices", "products"
  add_foreign_key "mdns", "devices"
  add_foreign_key "product_categories", "product_categories"
  add_foreign_key "products", "manufacturers"
  add_foreign_key "scan_diffs", "devices"
  add_foreign_key "scan_diffs", "scans"
  add_foreign_key "upnps", "devices"
end
