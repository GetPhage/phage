namespace :scan_diff do
  desc "Fix inactive status"
  task :inactive => [:environment] do
    ScanDiff.where(status: 'remove').each do |item|
      item.status = 'change'
      item.extra["active"] = false
      item.save
    end
  end

  desc "Fix duplicate inactives"
  task :dups => [:environment] do
    last_was_inactive = false
    ScanDiff.where(status: 'change').each do |item|
      if item.extra["active"]
        item.delete unless last_was_inactive
        last_was_inactive = false
      else
        item.delete if last_was_inactive
        last_was_inactive = true
      end
    end
  end
end
