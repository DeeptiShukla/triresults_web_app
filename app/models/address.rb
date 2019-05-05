class Address
  attr_accessor :city, :state, :location

  def initialize(city, state, location)
    @city = city
    @state = state
    @location = Point.new(location[:coordinates][0], location[:coordinates][1]) if location != nil
  end

  #creates a DB-form of the instance
  def mongoize
    output = {}
    output[:city] = @city if @city
    output[:state] = @state if @state
    output[:loc] = {:type=>"Point", :coordinates=>[@location.longitude, @location.latitude]} if @location
    return output
  end

  #creates an instance of the class from the DB-form of the data
  def self.demongoize(object)
    case object
      when nil? then nil
      when Address then object
      when Hash then Address.new(object[:city], object[:state], object[:loc])
      else object
    end
  end

  #takes in all forms of the object and produces a DB-friendly form
  def self.mongoize(object)
    case object
    when Address then object.mongoize
    when Hash then Address.new(object[:city], object[:state], object[:loc]).mongoize
    else object
    end
  end

  #used by criteria to convert object to DB-friendly form
  def self.evolve(object)
    case object
    when Address then object.mongoize
    else object
    end
  end
end
