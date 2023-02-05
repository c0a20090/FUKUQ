class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags, dependent: :destroy
  belongs_to :user
  has_one_attached :image
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [400, 400]
  end
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title,   presence: true, length: { maximum: 25 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "有効な画像形式でなければなりません" },
                      size:         { less_than: 5.megabytes,
                                      message:   "5MB未満である必要があります" }
end
