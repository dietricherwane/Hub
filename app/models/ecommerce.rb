class Ecommerce < ActiveRecord::Base
  # Accessible fields
  attr_accessible :name, :url, :description, :bank_id, :rib, :pdt_url, :ipn_url, :order_already_paid_url, :qualified, :qualified_by, :qualified_at, :unqualified_by, :unqualified_at, :user_id, :logo, :qualification_email_sent, :created_in_back_office

  # Scope
  default_scope {order("created_at ASC")}

  # Paperclip config
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "160x160>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  # Relationships
  belongs_to :bank
  belongs_to :user

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    logo: "Le logo",
    logo_content_type: "Le type de fichier",
    name: "La raison sociale",
    url: "Le lien du site web",
    description: "Description",
    bank_id: "La banque",
    pdt_url: "URL de transfert des données de paiement (PDT)",
    ipn_url: "URL de notification instantanée de paiement (IPN)",
    order_already_paid_url: "URL de transfert des articles déjà payés",
    rib: "RIB",
    qualified: "Qualifié",
    qualified_by: "Qualifié par",
    qualified_at: "Qualifié à",
    unqualified_by: "Désactivé par",
    unqualified_at: "Désactivé à",
    user_id: "Le propriétaire",
    created_at: "Soumise le"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :logo, :name, :url, :description, :pdt_url, :ipn_url, :bank_id, :rib, :user_id, presence: true
  validates :name, length: {minimum: 3, maximum: 100}
  validates :rib, length: {is: 24}
  validates :url, :pdt_url, :ipn_url, :order_already_paid_url, length: {maximum: 150, allow_blank: true}
  validates :url, :pdt_url, :ipn_url, :order_already_paid_url, format: {with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, multiline: true, allow_blank: true}
  validates :url, uniqueness: true
end
