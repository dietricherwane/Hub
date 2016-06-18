class Ecommerce < ActiveRecord::Base
  # Accessible fields
  attr_accessible :name, :url, :description, :bank_id, :rib, :bank_code, :wicket_code, :account_number, :pdt_url, :ipn_url, :order_already_paid_url, :qualified, :qualified_by, :qualified_at, :unqualified_by, :unqualified_at, :user_id, :logo, :qualification_email_sent, :created_in_back_office, :service_token, :operation_token, :token, :requalified_by, :requalified_at, :published, :created_on_paymoney_wallet, :paymoney_account_number, :paymoney_password, :paymoney_token, :paymoney_creation_request, :paymoney_creation_response, :ecommerce_profile_id
  # Scope
  default_scope {order("created_at ASC")}

  # Paperclip config
  has_attached_file :logo, :styles => { :medium => "300x300>", :thumb => "160x160>", :hub => "200x200" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

  # Relationships
  belongs_to :bank
  belongs_to :user
  has_many :available_wallets
  has_many :wallets, through: :available_wallets
  belongs_to :ecommerce_profile


  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    logo: "Le logo",
    logo_content_type: "Le type de fichier",
    firstname: "Le nom",
    lastname: "Le prénom",
    name: "La raison sociale",
    url: "Le lien du site web",
    description: "Description",
    bank_id: "La banque",
    pdt_url: "URL de transfert des données de paiement (PDT)",
    ipn_url: "URL de notification instantanée de paiement (IPN)",
    order_already_paid_url: "URL de transfert des articles déjà payés",
    rib: "Clé rib",
    bank_code: "Code banque",
    wicket_code: "Code guichet",
    account_number: "Numéro de compte",
    qualified: "Qualifié",
    qualified_by: "Qualifié par",
    qualified_at: "Qualifié le",
    unqualified_by: "Désactivé par",
    unqualified_at: "Désactivé le",
    user_id: "Le propriétaire",
    created_at: "Soumise le",
    service_token: "Token du service",
    operation_token: "Token de l'opération",
    ecommerce_profile_id: 'Type de ecommerce',
    paymoney_account_number: "Numéro de compte paymoney",
    paymoney_password: "Mot de passe du compte paymoney",
    paymoney_token: "Token du compte paymoney"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :logo, :name, :url, :description, :pdt_url, :ipn_url, :user_id, presence: true
  validates :name, length: {minimum: 3, maximum: 100}
  #validates :rib, length: {is: 24}
  validates :url, :pdt_url, :ipn_url, :order_already_paid_url, length: {maximum: 150, allow_blank: true}
  #validates :url, :pdt_url, :ipn_url, :order_already_paid_url, format: {with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, multiline: true, allow_blank: true}
  validates :url, uniqueness: true
  validate :rib_mandatory, :bank_code_mandatory, :wicket_code_mandatory, :account_number_mandatory

  def rib_mandatory
    if rib.blank? || (rib.length != 2)
      errors.add(:rib, "ne peut pas être vide et doit être sur 2 caractères")
    end
  end

  def bank_code_mandatory
    if bank_code.blank? || (bank_code.length != 5)
      errors.add(:bank_code, "ne peut pas être vide et doit être sur 5 caractères")
    end
  end

  def wicket_code_mandatory
    if wicket_code.blank? || (wicket_code.length != 5)
      errors.add(:wicket_code, "ne peut pas être vide et doit être sur 5 caractères")
    end
  end

  def account_number_mandatory
    if account_number.blank? || (account_number.length != 12)
      errors.add(:account_number, "ne peut pas être vide et doit être sur 12 caractères")
    end
  end
end
