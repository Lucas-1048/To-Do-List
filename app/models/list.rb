class List < ApplicationRecord
    has_many :tasks, dependent: :destroy
    validates :title, presence: true, length: { minimum: 1, maximum: 50 }
    attribute :category, :string, default: ""
    validates :category, inclusion: { in: [ "Pessoal", "Trabalho", "Escola", "" ] }
end
