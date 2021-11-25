class Product < ApplicationRecord

  #save
  before_save :validate_product
  after_save :send_notification
  after_save :push_notificacion, if: :discount?

  validates :title, presence: {message: "Es necesario definir un valor para el titulo"}
  validates :code, presence: {message: "Es necesario definir un valor para el codigo"}
  validates :code, uniqueness: {message: "El codigo: %{value} ya se encuentra en uso"}

  # validates :price, length: { minimum: 3, maximum: 10 }
  validates :price, length: { in: 3..10, message: "El precio se encuentra fera de rango (Min: 3, Max:10)" }, if: :has_price? 
    
  def has_price?
    !self.price.nil? && self.price > 0
  end

  def discount?
    self.total < 5
  end
  
  def total
    self.price / 100
  end

  private 
  def push_notificacion
    puts "\n\n\n >>>> Un nuevo producto en descuento ya se encuentra disponible #{self.title}!"
  end

  def validate_product
    puts "\n\n\n >>>> Un nuevo producto sera añadido a almacen!"
  end

  def send_notification
    puts "\n\n\n\n >>> Un nuevo producto fue añadido a almacen:  #{self.title} - #{self.total} USD"
  end
end

