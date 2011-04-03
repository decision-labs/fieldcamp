class EventAddressValidator < ActiveModel::Validator
  def validate(object)
    if object.geom.blank?
      object.errors[:address] << I18n.t('activerecord.errors.models.event.attributes.address')
    end
  end
end

