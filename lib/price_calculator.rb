class PriceCalculator

  def self.prices_for(movie_price, zip_code)
    unless zip_code.blank?
      tax_rate = TaxRateService.rate_for(zip_code)
      calculate_prices_for(movie_price, tax_rate)
    end
  end

  private

  def self.round_up_to_whole_number(taxed_price)
    BigDecimal.new(taxed_price.to_s).round(0, BigDecimal::ROUND_CEILING)
  end

  def self.round_to_two_decimal_places(number)
    BigDecimal.new(number.to_s).round(2, BigDecimal::ROUND_CEILING)
  end

  def self.calculate_prices_for(movie_price, tax_rate)
    original_taxed_price = movie_price * (1 + tax_rate)

    rounded_total = round_up_to_whole_number(original_taxed_price)
    new_price = round_to_two_decimal_places(rounded_total/(1 + tax_rate))
    new_tax = round_to_two_decimal_places(rounded_total - new_price)

    {:total => rounded_total, :price => new_price, :tax => new_tax}
  end
end
