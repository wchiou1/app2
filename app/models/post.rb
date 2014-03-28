class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
  length: { minimum: 5 }
  
  require "rubygems"
  require "json"
  
  after_validation :chickenator
  
  @@global_string=""
  
  private
  def chickenator

    parsed = JSON.parse(self.title)

    parsed.each do |chicken, meat|
      if meat.class == Array
        @@global_string+=chicken+"\n"
        read_array(meat,0)
      else
        @@global_string+=chicken+":"+meat.to_s+"\n"
      end
    end
	self.title=@@global_string
  end
  # JSON Parsing example
  def read_object(object,indent)
    tempstr=""
    for i in 0..indent
      tempstr+="/^/"
    end
    object.each do |type,element|
      if element.class == Array
        @@global_string+=tempstr+type+"\n"
        read_array(element,indent+1)
      else
        @@global_string+=tempstr+type+":"+element.to_s+"\n"
      end
    end
  end

  def read_array(array,indent)
    tempstr=""
    for i in 0..indent
      tempstr+="/^/"
    end
    array.each do |element|
      if element.class == Hash
        read_object(element,indent)
      else
        @@global_string+=tempstr+element+"\n"
      end
    end
  end
end
