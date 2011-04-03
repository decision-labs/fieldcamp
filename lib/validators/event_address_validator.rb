class EventAddressValidator < ActiveModel::Validator
  def validate(object)
    Rails.logger.info '='*30
    Rails.logger.info object.inspect
    Rails.logger.info '='*30
    if object.geom.blank?
      object.errors[:base] << I18n.t('activerecord.errors.models.event.attributes.address')
    end
  end
end

