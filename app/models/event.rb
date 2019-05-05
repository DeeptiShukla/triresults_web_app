class Event
  include Mongoid::Document
  field :o, as: :order, type: Integer
  field :n, as: :name, type: String
  field :d, as: :distance, type: Float
  field :u, as: :units, type: String

  embedded_in :parent, polymorphic: true, touch: true

  validates_presence_of :order, :name

  def meters
    return nil if d.nil? or u.nil?
    case u
    when "meters" then d
    when "miles" then d*1609.344
    when "kilometers" then d*1000
    when "yards" then d*0.9144
    end
  end

  def miles
    return nil if d.nil? or u.nil?
    case u
    when "miles" then d
    when "meters" then d*0.000621371
    when "kilometers" then d*0.621371
    when "yards" then d*0.000568182
    end
  end
end
