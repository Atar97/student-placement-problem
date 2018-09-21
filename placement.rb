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

  def self.students(num, classes)
    result = []
    Faker::LordOfTheRings.unique.clear
    num.times do
      result << Student.new(
        name: Faker::LordOfTheRings.unique.character,
        student_id: rand(1000),
        course_choices: classes.shuffle
      )
    end
    result
  end

  def self.seed_with_color_classes(course_size)
    courses = Placement.color_classes(course_size)
    Placement.new(Placement.students(16, courses), courses)
  end

  attr_reader :students, :courses, :choice_count

  def initialize(students = nil, courses = nil)
    @students = students
    @choice_count = 0
    @courses = courses
  end

  def place_students
    @students.each do |student|
      place_student(student)
    end
    all_students_placed?
  end

  def place_student(student)
    i = 0
    until student.placed?
      raise "Student Not Placed" if i == 4
      course = student[i]
      course.add_student(student) unless course.full?
      i += 1
    end
    @choice_count += i
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
      student.each_with_index do |course_choice, i|
        result[course_choice.name][i] += 1
      end
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

  def all_students_placed?
    @students.all? {|student| student.placed?}
  end

end
