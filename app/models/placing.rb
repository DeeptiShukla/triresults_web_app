class Placing
  attr_accessor :name, :place

  def initialize(name, place)
    @name = name
    @place = place
  end

  #creates a DB-form of the instance
  def mongoize
    {:name => @name, :place => @place}
  end

  #creates an instance of the class from the DB-form of the data
  def self.demongoize(object)
    return nil if object.nil?
    Placing.new(object[:name], object[:place])
  end

  #takes in all forms of the object and produces a DB-friendly form
  def self.mongoize(object)
    case object
    when Placing then object.mongoize
    when Hash then Placing.new(object[:name], object[:place]).mongoize
    else object
    end
  end

  #used by criteria to convert object to DB-friendly form
  def self.evolve(object)
    case object
    when Placing then object.mongoize
    else object
    end
  end
end