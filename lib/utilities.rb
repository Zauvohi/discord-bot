class Utilities
  def self.generate_id(raid_name)
    number = rand(0 .. 999)
    raid_name[0 .. 1].upcase + number.to_s.rjust(3, '0')
  end

  def self.random_pic(pic_array)
    pics_lenght = pic_array.size
    return pic_array[rand(0 .. pics_lenght)]
  end
end
