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
end
