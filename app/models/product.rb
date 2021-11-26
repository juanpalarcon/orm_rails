class Product < ApplicationRecord

  #save
  before_create :validate_product
  after_create :send_notification
  after_create :push_notificacion, if: :discount?
  after_update :send_notification_update
  after_destroy :send_notification_destroy_product
  before_update :code_notification_changed, if: :code_changed?

  validates :title, presence: {message: "Es necesario definir un valor para el titulo"}
  validates :code, presence: {message: "Es necesario definir un valor para el codigo"}
  validates :code, uniqueness: {message: "El codigo: %{value} ya se encuentra en uso"}
  validates :price, length: { in: 3..10, message: "El precio se encuentra fera de rango (Min: 3, Max:10)" }, if: :has_price? 
  validates_with ProductValidator
  validate :code_validate
    
  scope :available, -> (min=1) { where("stock >= ?", min) }
  scope :order_price_desc, -> { order("price DESC") }
  scope :available_and_order_price_desc, ->  { available.order_price_desc }


  def has_price?
    !self.price.nil? && self.price > 0
  end

  def discount?
    self.total < 5 
  end
  
  def total
    self.price / 100
  end

  def self.top_5_available
    self.available_and_order_price_desc.limit(5).select(:title, :code)
  end

  private 

  def code_validate
    if self.code.nil? || self.code.length < 3
      self.errors.add(:code, "El codigo debe posear por lo menos 3 caracteres")
    end
  end

  def push_notificacion
    puts "\n\n\n >>>> Un nuevo producto en descuento ya se encuentra disponible #{self.title}!"
  end

  def validate_product
    puts "\n\n\n >>>> Un nuevo producto sera añadido a almacen!"
  end

  def send_notification
    puts "\n\n\n\n >>> Un nuevo producto fue añadido a almacen:  #{self.title} - #{self.total} USD"
  end

  def send_notification_update
    puts "\n\n\n\n >>> se actualizo un producto #{self.title}"
  end

  def send_notification_destroy_product
    puts  "\n\n\n\n >>> se elimino un producto #{self.title}"
  end

  def code_notification_changed
    puts  "\n\n\n\n >>> Se actualizo el codigo de un producto #{self.title}-- #{self.code}"
  end
end

