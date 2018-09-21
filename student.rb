require 'byebug'
require_relative 'course'

class Student
  attr_reader :choices, :choice_rank, :name, :sutdent_id

  include Enumerable

  def each(&block)
    @choices.each {|choice| block.call(choice)}
  end

  CHOICES = ['blue','green','red','yellow']

  def initialize(options = {})
    @choices = options[:choices] || CHOICES.shuffle
    @choice_rank = options[:choice_rank] || 0
    @name = options[:name]
    @student_id = options[:student_id]
  end

  def [](index)
    byebug
    @choices[index]
  end

  def []=(index, value)
    @choices[index] = value
  end

  def to_s
    @name
  end

  def get_placed(class_choice)
    @choice_rank = @choices.index(class_choice)
  end

end
