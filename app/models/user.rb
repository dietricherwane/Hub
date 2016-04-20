class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable#, :confirmable

  # Relationships
  belongs_to :profile
  has_many :ecommerces
  belongs_to :country
  belongs_to :pos_account_type
  has_many :paymoney_wallet_logs
  belongs_to :compensation_mode
  has_many :pos_cashouts


  # Accessible fields
  attr_accessible :firstname, :lastname, :country_id, :email, :address, :phone_number, :mobile_number, :profile_id, :published, :password, :password_confirmation, :pos_account_type_id, :company, :rib, :activities_description, :certified_agent_id, :created_on_paymoney_wallet, :identification_token, :bank_code, :wicket_code, :account_number, :paymoney_password, :paymoney_token, :sub_certified_agent_id, :paymoney_account_number, :wari_sub_certified_agent_id, :compensation_mode_id, :can_cashout_to_rib

  # Renaming attributes into more friendly text
  HUMANIZED_ATTRIBUTES = {
    id: "",
    firstname: "Nom",
    lastname: "Prénom",
    country_id: "Pays",
    company: "Raison sociale",
    email: "Email",
    address: "Adresse",
    pos_account_type_id: "Type de compte POS",
    phone_number: "Numéro de téléphone fixe",
    mobile_number: "Numéro de téléphone mobile",
    password_confirmation: "Confirmation de mot de passe",
    rib: "Clé rib",
    bank_code: "Code banque",
    wicket_code: "Code guichet",
    account_number: "Numéro de compte",
    paymoney_account_number: "Numéro de compte paymoney",
    activities_description: "Description des activités",
    created_at: "Compte créé le",
    certified_agent_id: "Id agent agréé",
    compensation_mode_id: "Mode de compensation"
  }

  def self.human_attribute_name(attr, option = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  # Validations
  validates :firstname, :lastname, :country_id, :address, :mobile_number, presence: true
  validates :firstname, :lastname, length: {maximum: 100}
  validates :phone_number, :mobile_number, length: {minimum: 8, maximum: 16, allow_blank: true}
  #validates :rib, length: {is: 2}
  #validates :bank_code, :wicket_code, length: {is: 5}
  #validates :account_number, length: {is: 12}
  validates :company, length: {minimum: 3, allow_blank: true}
  validates :phone_number, :mobile_number, numericality: {allow_blank: true}
  validate :rib_mandatory_for_merchants, :compensation_mode_mandatory_for_merchants, :bank_code_mandatory_for_merchants, :wicket_code_mandatory_for_merchants, :account_number_mandatory_for_merchants

  # Custom functions
  def admin?
    return profile.shortcut == "ADMIN"
  end

  def merchant?
    return profile.shortcut == "MER"
  end

  def posm?
    return profile.shortcut == "POSM"
  end

  def profile_shortcut
    return profile.shortcut
  end

  def full_name
    return "[ #{lastname} #{firstname} ]"
  end

  def has_ecommerce
    return !ecommerces.empty?
  end

  def rib_mandatory_for_merchants
    if (PosAccountType.find_by_id(pos_account_type_id).name rescue "") == "POS marchand" && rib.blank? && (rib.length != 2) && (compensation_mode.description rescue "") == 'Par virement automatique'
      errors.add(:rib, "ne peut pas être vide et doit être sur 2 caractères")
    end
  end

  def compensation_mode_mandatory_for_merchants
    if (pos_account_type.name rescue "") == "POS marchand" && compensation_mode_id.blank?
      errors.add(:compensation_mode_id, "ne peut pas être vide")
    end
  end

  def bank_code_mandatory_for_merchants
    if (PosAccountType.find_by_id(pos_account_type_id).name rescue "") == "POS marchand" && bank_code.blank? && (bank_code.length != 5) && (compensation_mode.description rescue "") == 'Par virement automatique'
      errors.add(:bank_code, "ne peut pas être vide et doit être sur 5 caractères")
    end
  end

  def wicket_code_mandatory_for_merchants
    if (PosAccountType.find_by_id(pos_account_type_id).name rescue "") == "POS marchand" && wicket_code.blank? && (wicket_code.length != 5) && (compensation_mode.description rescue "") == 'Par virement automatique'
      errors.add(:wicket_code, "ne peut pas être vide et doit être sur 5 caractères")
    end
  end

  def account_number_mandatory_for_merchants
    if (PosAccountType.find_by_id(pos_account_type_id).name rescue "") == "POS marchand" && account_number.blank? && (account_number.length != 12) && (compensation_mode.description rescue "") == 'Par virement automatique'
      errors.add(:account_number, "ne peut pas être vide et doit être sur 12 caractères")
    end
  end

  def company_mandatory_for_merchants
    if (PosAccountType.find_by_id(pos_account_type_id).name rescue "") == "POS marchand" && company.blank?
      errors.add(:company, "ne peut pas être vide")
    end
  end

  # Callbacks
  before_save :format_fields
  before_update :format_fields

  private
  def format_fields
    self.firstname = StringUtils.every_first_letter_uppercase(self.firstname)
    self.lastname = StringUtils.every_first_letter_uppercase(self.lastname)
  end
end
