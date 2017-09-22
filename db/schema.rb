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

ActiveRecord::Schema.define(version: 20170919164627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "cves", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "seq"
    t.string "status"
    t.string "desc"
    t.string "refs"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["desc"], name: "index_cves_on_desc"
    t.index ["name"], name: "index_cves_on_name"
    t.index ["seq"], name: "index_cves_on_seq"
  end

  create_table "dashboards", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", id: :serial, force: :cascade do |t|
    t.macaddr "mac_address", null: false
    t.inet "ipv4", array: true
    t.inet "ipv6", array: true
    t.string "kind", null: false
    t.datetime "last_seen", null: false
    t.jsonb "extra", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", default: [], null: false, array: true
    t.boolean "active", default: true, null: false
    t.integer "oui_id"
    t.string "firmware_version"
    t.integer "product_id"
    t.string "serial_number"
    t.string "model_number"
    t.string "model_shortname"
    t.string "upc"
    t.string "model_description"
    t.integer "udpv4", default: [], array: true
    t.integer "tcpv4", default: [], array: true
    t.integer "udpv6", default: [], array: true
    t.integer "tcpv6", default: [], array: true
    t.integer "network_id"
    t.boolean "is_mobile", default: false, null: false
    t.boolean "is_thing", default: false, null: false
    t.string "given_name", default: "", null: false
    t.index ["extra"], name: "index_devices_on_extra", using: :gin
    t.index ["firmware_version"], name: "index_devices_on_firmware_version"
    t.index ["given_name"], name: "index_devices_on_given_name"
    t.index ["ipv4"], name: "index_devices_on_ipv4"
    t.index ["ipv6"], name: "index_devices_on_ipv6"
    t.index ["is_mobile"], name: "index_devices_on_is_mobile"
    t.index ["is_thing"], name: "index_devices_on_is_thing"
    t.index ["kind"], name: "index_devices_on_kind"
    t.index ["mac_address"], name: "index_devices_on_mac_address"
    t.index ["model_description"], name: "index_devices_on_model_description"
    t.index ["network_id"], name: "index_devices_on_network_id"
    t.index ["oui_id"], name: "index_devices_on_oui_id"
    t.index ["product_id"], name: "index_devices_on_product_id"
    t.index ["tcpv4"], name: "index_devices_on_tcpv4", using: :gin
    t.index ["tcpv6"], name: "index_devices_on_tcpv6", using: :gin
    t.index ["udpv4"], name: "index_devices_on_udpv4", using: :gin
    t.index ["udpv6"], name: "index_devices_on_udpv6", using: :gin
    t.index ["upc"], name: "index_devices_on_upc"
  end

  create_table "flows", id: :serial, force: :cascade do |t|
    t.integer "device_id"
    t.macaddr "mac_address", null: false
    t.inet "src_ip", default: "0.0.0.0", null: false
    t.inet "dst_ip", default: "0.0.0.0", null: false
    t.integer "src_port", default: 0, null: false
    t.integer "dst_port", default: 0, null: false
    t.string "hostname", default: "", null: false
    t.integer "duration", default: 0, null: false
    t.bigint "bytes_sent", default: 0, null: false
    t.bigint "bytes_received", default: 0, null: false
    t.index ["bytes_received"], name: "index_flows_on_bytes_received"
    t.index ["device_id"], name: "index_flows_on_device_id"
    t.index ["dst_ip"], name: "index_flows_on_dst_ip"
    t.index ["dst_port"], name: "index_flows_on_dst_port"
    t.index ["duration"], name: "index_flows_on_duration"
    t.index ["hostname"], name: "index_flows_on_hostname"
    t.index ["src_ip"], name: "index_flows_on_src_ip"
    t.index ["src_port"], name: "index_flows_on_src_port"
  end

  create_table "histories", id: :serial, force: :cascade do |t|
    t.string "message", default: "", null: false
    t.integer "scan_diff_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message"], name: "index_histories_on_message"
    t.index ["scan_diff_id"], name: "index_histories_on_scan_diff_id"
    t.index ["user_id"], name: "index_histories_on_user_id"
  end

  create_table "manufacturers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "web"
    t.string "support_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_manufacturers_on_name"
  end

  create_table "mdns", id: :serial, force: :cascade do |t|
    t.string "hostname"
    t.string "service"
    t.string "protocol"
    t.integer "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "txt", null: false
    t.inet "ipv4", default: [], array: true
    t.inet "ipv6", default: [], array: true
    t.integer "port", null: false
    t.jsonb "extra", default: {}, null: false
    t.index ["device_id"], name: "index_mdns_on_device_id"
    t.index ["extra"], name: "index_mdns_on_extra", using: :gin
    t.index ["hostname"], name: "index_mdns_on_hostname"
    t.index ["ipv4"], name: "index_mdns_on_ipv4", using: :gin
    t.index ["ipv6"], name: "index_mdns_on_ipv6", using: :gin
    t.index ["port"], name: "index_mdns_on_port"
  end

  create_table "networks", id: :serial, force: :cascade do |t|
    t.string "device_name", null: false
    t.string "string", null: false
    t.integer "device_type", null: false
    t.string "my_ipv4", null: false
    t.string "my_ipv6"
    t.string "mac_address", null: false
    t.string "my_wifi_ssid"
    t.string "netmask"
    t.string "default_gw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_networks_on_user_id"
  end

  create_table "ouis", id: :serial, force: :cascade do |t|
    t.string "prefix", limit: 6, null: false
    t.string "manufacturer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manufacturer"], name: "index_ouis_on_manufacturer"
    t.index ["prefix"], name: "index_ouis_on_prefix"
  end

  create_table "partial_flows", id: :serial, force: :cascade do |t|
    t.integer "device_id"
    t.macaddr "mac_address", null: false
    t.inet "src_ip", default: "0.0.0.0", null: false
    t.inet "dst_ip", default: "0.0.0.0", null: false
    t.integer "src_port", default: 0, null: false
    t.integer "dst_port", default: 0, null: false
    t.string "hostname", default: "", null: false
    t.bigint "src_seq", default: 0, null: false
    t.bigint "src_ack", default: 0, null: false
    t.boolean "is_syn", default: false, null: false
    t.boolean "is_fin", default: false, null: false
    t.boolean "is_rst", default: false, null: false
    t.datetime "timestamp", null: false
    t.index ["device_id"], name: "index_partial_flows_on_device_id"
    t.index ["is_fin", "src_ip", "dst_ip", "src_port", "dst_port", "timestamp"], name: "partial_flow_fin_hosts_index"
    t.index ["is_fin"], name: "index_partial_flows_on_is_fin"
    t.index ["is_syn", "src_ip", "dst_ip", "src_port", "dst_port", "timestamp"], name: "partial_flow_syn_hosts_index"
    t.index ["is_syn"], name: "index_partial_flows_on_is_syn"
    t.index ["src_ip", "dst_ip", "src_port", "dst_port"], name: "partial_flow_index"
  end

  create_table "product_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "mobile"
    t.integer "product_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mobile"], name: "index_product_categories_on_mobile"
    t.index ["name"], name: "index_product_categories_on_name"
    t.index ["product_category_id"], name: "index_product_categories_on_product_category_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "manufacturer_id"
    t.string "name", null: false
    t.index ["manufacturer_id"], name: "index_products_on_manufacturer_id"
  end

  create_table "samples", id: :serial, force: :cascade do |t|
    t.integer "device_id", null: false
    t.string "mac_address", null: false
    t.string "ipv4", array: true
    t.string "ipv6", array: true
    t.integer "signal_strength"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_samples_on_device_id"
    t.index ["ipv4"], name: "index_samples_on_ipv4"
    t.index ["ipv6"], name: "index_samples_on_ipv6"
    t.index ["mac_address"], name: "index_samples_on_mac_address"
    t.index ["signal_strength"], name: "index_samples_on_signal_strength"
  end

  create_table "scan_diffs", id: :serial, force: :cascade do |t|
    t.integer "scan_id"
    t.integer "device_id"
    t.string "kind", null: false
    t.integer "status", null: false
    t.jsonb "extra", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_scan_diffs_on_device_id"
    t.index ["extra"], name: "index_scan_diffs_on_extra", using: :gin
    t.index ["kind"], name: "index_scan_diffs_on_kind"
    t.index ["scan_id"], name: "index_scan_diffs_on_scan_id"
    t.index ["status"], name: "index_scan_diffs_on_status"
  end

  create_table "scans", id: :serial, force: :cascade do |t|
    t.string "scan_type", null: false
    t.datetime "start", null: false
    t.datetime "end", null: false
    t.string "notes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "network_id"
    t.index ["network_id"], name: "index_scans_on_network_id"
    t.index ["scan_type"], name: "index_scans_on_scan_type"
    t.index ["start"], name: "index_scans_on_start"
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "port_number", null: false
    t.string "protocol", default: "", null: false
    t.string "description", default: "", null: false
    t.string "reference", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_services_on_name"
    t.index ["port_number"], name: "index_services_on_port_number"
    t.index ["protocol"], name: "index_services_on_protocol"
  end

  create_table "software_blacklists", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "version", null: false
    t.string "reason", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_software_blacklists_on_name"
    t.index ["reason"], name: "index_software_blacklists_on_reason"
  end

  create_table "upnps", id: :serial, force: :cascade do |t|
    t.integer "device_id"
    t.string "st"
    t.string "usn"
    t.string "location"
    t.string "cache_control"
    t.string "server"
    t.string "ext"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cache_control"], name: "index_upnps_on_cache_control"
    t.index ["device_id"], name: "index_upnps_on_device_id"
    t.index ["ext"], name: "index_upnps_on_ext"
    t.index ["location"], name: "index_upnps_on_location"
    t.index ["server"], name: "index_upnps_on_server"
    t.index ["st"], name: "index_upnps_on_st"
    t.index ["usn"], name: "index_upnps_on_usn"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "devices", "networks"
  add_foreign_key "devices", "ouis"
  add_foreign_key "devices", "products"
  add_foreign_key "histories", "scan_diffs"
  add_foreign_key "histories", "users"
  add_foreign_key "mdns", "devices"
  add_foreign_key "networks", "users"
  add_foreign_key "product_categories", "product_categories"
  add_foreign_key "products", "manufacturers"
  add_foreign_key "scan_diffs", "devices"
  add_foreign_key "scan_diffs", "scans"
  add_foreign_key "scans", "networks"
  add_foreign_key "upnps", "devices"
end
