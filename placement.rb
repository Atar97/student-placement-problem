require 'byebug'
require 'faker'
require_relative 'course'
require_relative 'student'

class Placement

  def self.color_classes(num)
    Student::CHOICES.map {|color| Course.new(color, num)}
  end

  def self.courses(num)
    result = []
    num.times do
      result << Course.new(
      Faker::LordOfTheRings.location,
      rand(10..20)
    )
    end
    result
  end

  def self.students(num)
    result = []
    Faker::LordOfTheRings.unique.clear
    num.times do
      result << Student.new(
        name: Faker::LordOfTheRings.unique.character,
        student_id: rand(1000)
      )
    end
    result
  end

  def self.seed_with_color_classes
    Placement.new(Placement.students(16), Placement.colors(6))
  end

  attr_reader :students, :courses

  def initialize(students = nil, courses = nil)
    @students = students
    @choice_count = 0
    @courses = courses
  end

  def place_students
    
  end

  def to_s
    students = "Students: #{@students.map {|stu| stu.to_s}}"
    courses = "Courses: #{@courses.map {|clas| clas.to_s}}"
    "#{students} \n #{courses}"
  end

  # collect data on which courses were most popular

  def popularities
    result = {}
    @courses.each do |cl|
      result[cl.name] = Hash.new(0)
    end
    @students.each do |student|
      student.each_with_index {|choice, i| result[choice][i] += 1}
    end
    result
  end

  def parse_popularities
    pops = popularities
    str = ""
    pops.each do |course_name, count_hash|
      str += "#{course_name}: \n"
      count_hash.each do |place, number|
        str += "#{number} students picked this at place #{place + 1}\n"
      end
    end
    str
  end

end
