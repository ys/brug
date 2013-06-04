class Gathering < ActiveRecord::Base
  extend FriendlyId
  KINDS = %w[burger beer conference hacking presentations]

  has_many :participations
  has_many :members, through: :participations
  belongs_to :owner, class_name: 'Member'

  scope :future, where("start_at > '#{Time.now.beginning_of_day}'").order('start_at ASC')

  validates_presence_of :name, :location, :start_at, :description, :kind

  friendly_id :name, use: :slugged

  def participation
    case members.count
    when 0
      "No one is attending yet"
    else
      "#{pluralize(members.count, 'person')} attending"
    end
  end
end
