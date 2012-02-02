namespace :db do
  desc "populate the locations.child_location_ids"
  task :populate_child_location_ids => :environment do
    Location.all(:select => [:id, :name, :parent_id, :child_location_ids]).each do |loc|
      loc.update_attribute(:child_location_ids, "")
      puts "processing #{loc.id} - #{loc.name}"
      populate_children(loc, loc.children.select(:id))
      loc.update_attribute(:child_location_ids, loc.child_location_ids.gsub(/^\|/, ''))
    end
  end

  def populate_children(loc, children)
    return if children.blank?
    loc.child_location_ids += '|'+children.collect(&:id).join('|')
    loc.save!
    children.each do |ch|
      puts "  >> processing #{loc.name} - #{ch.id}"
      populate_children(loc, ch.children.select(:id))
    end
  end
end