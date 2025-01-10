class Task < ApplicationRecord
    belongs_to :list
    validates :description, presence: true, length: { minimum: 1, maximum: 50 }
    validates :checked, inclusion: { in: [ true, false ] }
end
