class Utilities
  def self.generate_id(raid_name)
    number = rand(0 .. 999)
    raid_name[0 .. 1].upcase + number.to_s.rjust(3, '0')
  end
end
