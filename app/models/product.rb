class Product < ApplicationRecord

  #save
  before_save :validate_product
  after_save :send_notification
  after_save :push_notificacion, if: :discount?

  #precio < 5
  
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
