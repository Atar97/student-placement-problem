require_relative 'student'
require 'byebug'

class Course
  attr_reader :name, :size, :students

  include Enumerable
  
  def each(&block)
    @students.each {|stu| block.call(stu)}
  end

  def initialize(name, size = nil, students = [])
    @students = students
    @size = size || rand(10..20)
    @name = name
  end

  def full?
    @students.length >= size
  end

  def add_student
    @students << student
  end

  def to_s
    "#{@name}, size: #{@size}"
  end

end
