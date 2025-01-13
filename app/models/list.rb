class List < ApplicationRecord
    belongs_to :user
    has_many :tasks, dependent: :destroy
    validates :title, presence: true, length: { minimum: 1, maximum: 30 }
    attribute :category, :string, default: ""
    validates :category, inclusion: { in: [ "Pessoal", "Trabalho", "Escola", "" ] }
end
