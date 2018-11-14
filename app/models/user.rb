class User < ApplicationRecord
  has_many :routines
  has_many :exercises, through: :routines
  has_many :user_badges
  has_many :badges, through: :user_badges

  validates_length_of :password, :username, :minimum => 6
  has_secure_password


  def todays_reps(exercise_id) #sums up all reps for today for passed in exercise
    today = DateTime.now
    pushup_routines = self.routines.select {|r| r.exercise_id == exercise_id} #creates array of all routines that match exercise
    pushup_routines_week = pushup_routines.select do |r|
      r_create_time = r.created_at.in_time_zone("Eastern Time (US & Canada)")
      r_create_time.year == today.year &&
      r_create_time.month == today.month &&
      r_create_time.day == today.day
    end
    daily_reps = 0
    pushup_routines_week.each {|r| daily_reps += r.reps}
    daily_reps
  end

  def lifetime_reps(exercise_id) #sums up lifetime reps for passed in exercise
    pushup_routines = self.routines.select {|r| r.exercise_id == exercise_id}
    total_reps = 0
    pushup_routines.each {|r| total_reps += r.reps}
    total_reps
  end

  def weekly_reps(exercise_id) #sums up reps for passed in exercise performed in the past 7 days
    today = DateTime.now
    pushup_routines = self.routines.select {|r| r.exercise_id == exercise_id} #creates array of all routines that match exercise
    pushup_routines_week = pushup_routines.select {|r| r.created_at > (today - 7)}
    weekly_reps = 0
    pushup_routines_week.each {|r| weekly_reps += r.reps}
    weekly_reps
  end


  def instantiate_badges #will create a user_badge instance for all existing badges, all locked
    Badge.all.each do |badge|
      UserBadge.create(user_id: self.id, badge_id: badge.id, unlocked: false)
    end
  end

  def badges_earned #returns array of all instances of user_badge that are unlocked
    self.user_badges.select {|b| b.unlocked == true}
  end

  def badges_locked #returns array of all instances of user_badge that are unlocked
    self.user_badges.select {|b| b.unlocked == false}
  end

end
