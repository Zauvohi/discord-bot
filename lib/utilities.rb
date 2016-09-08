class Utilities

  def self.underscore(string)
    if (string.class === Array.new)
      string.join("_").downcase
    else
      string.split.join("_").downcase
    end
  end

  def self.random_pic(pic_array)
    pics_lenght = pic_array.size
    return pic_array[rand(0 .. pics_lenght - 1)]
  end
end
