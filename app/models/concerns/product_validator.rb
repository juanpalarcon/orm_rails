class ProductValidator < ActiveModel::Validator

  def validate(record)
    self.validate_stock(record)
  end

  def validate_stock(record)
    if record.stock < 0
      record.errors.add(:stock, "El stock no puede ser una valor negativo")
    end

  end


  
end