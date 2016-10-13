namespace :names do
  task :cleanup => [:environment] do
    Device.all.each do |dev|
      dev.name = dev.name.select { |name| name != '' }
      dev.name.uniq!
      dev.save
    end

    ScanDiff.all.each do |sd|
      if sd.extra["name"] && sd.extra["name"] == ''
        sd.delete
      end
    end
  end
end
