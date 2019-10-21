class Hero < ActiveRecord::Base
  has_many :journeys
  has_many :challenges, through: :journeys
  after_initialize :init

  # Why does the intialize method below not work?
  def init
    self.story ||= "A battle hardened veteran."
    self.experience ||= 1
    self.health ||= 100
    self.power ||= 20
    self.save
  end
end