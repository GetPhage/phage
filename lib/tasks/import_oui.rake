require 'import_oui'

namespace :oui do
  task :import => [:environment] do
    oui = OUI.new "./oui.txt"
    oui.each do |item|
      Oui.find_or_create_by item
    end
  end
end
