class Help < ApplicationRecord
  belongs_to :user  
  belongs_to :category
  has_many :chats

  scope :active, -> { where(status: 0).order(created_at: :desc).includes(:user, :category) }
  scope :by_coordinates, ->(leftLong, rightLong, topLat, bottomLat) { where('long between ? and ? and lat between ? and ?', leftLong.to_f, rightLong.to_f, bottomLat.to_f, topLat.to_f)}
  after_save :mark_as_fulfilled

  validates :title, presence: true, length: {minimum: 6}
  validates :description, presence: true, length: {minimum: 20}
  validates :long, presence: true, numericality: true
  validates :lat, presence: true, numericality: true
  # validates :category_id, presence: true, format: {with: /\A[1-9]+\Z/}
  # validates :user_id, presence: true, format: {with: /\A[1-9]+\Z/}
  private
    def mark_as_fulfilled
      if ((self.fulfilment_count == 5) && (self.status == false))
        self.status = true
        if self.save
          StatusChannel.broadcast_to self, {status: true}
          @helps = Help.active
          ActionCable.server.broadcast("help_list_channel", {helps: @helps.as_json(include: {:user => {except: :password_digest}, :category => {only: [:name, :color]}})})
        end
      end
    end
end