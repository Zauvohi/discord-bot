class Utilities

  def self.underscore(string)
    if (string.respond_to?(:join))
      string.join("_").downcase
    else
      string.split.join("_").downcase
    end
  end

  def self.random_element(elements_array)
    lenght = elements_array.size
    elements_array[rand(0 .. lenght - 1)]
  end


  def self.find_raid_name(raid_alias, raid_info)
    actual_name = ""

    if raid_info.has_key?(raid_alias)
      actual_name = raid_alias
    else
      raid_info.each do |k, v|
        if v['aliases'].include?(raid_alias)
          actual_name = k
        end
      end
    end

    actual_name
  end
end
