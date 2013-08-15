class CloudBook < ActiveRecord::Base
    validates :predef_name, presence: true
    validates :predef_cloud_name, presence: true
  attr_accessible :users_id, :predef_name, :name, :predef_cloud_name, :deps_scm, :deps_war, :domain_name, :cloud_books_history_attributes
  
  belongs_to :user, :foreign_key  => 'users_id'
  
  has_many :cloud_books_histories, :foreign_key => 'book_id'  
  accepts_nested_attributes_for :cloud_books_histories , :update_only => true

end
