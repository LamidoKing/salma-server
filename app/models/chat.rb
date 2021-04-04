class Chat < ApplicationRecord
  belongs_to :help
  belongs_to :user

  validates :message, presence: true

  # after_create :increment_fulfilment
  
  # private 
  #   def increment_fulfilment
  #     help = self.help;
  #     help.fulfilment_count = help.fulfilment_count + 1

  #   end
end
