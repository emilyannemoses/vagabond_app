class User < ActiveRecord::Base
  has_many :posts
  has_secure_password

  validates :avatar,
              presence: {message: ": Enter a link to a photo"}

VALID_NAME_REGEX = /\A[a-zA-Z0-9 ]*\z/
  validates :first_name,
              presence: true,
              format:   { with: VALID_NAME_REGEX },
              length:   { maximum: 255 }

  validates :last_name,
              presence: true,
              format:   { with: VALID_NAME_REGEX },
              length:   { maximum: 255 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
              presence:   true,
              format:     { with: VALID_EMAIL_REGEX },
              uniqueness: true,
              length:     { maximum: 255 }

    def self.confirm(params)
        @user = User.find_by({email: params[:email]})
        @user.try(:authenticate, params[:password])
    end
    extend FriendlyId
    friendly_id :myslug, use: :slugged

    def myslug
      ["#{first_name}-#{last_name}",
        ["#{first_name}-#{last_name}",:current_city]
      ]
    end
end
