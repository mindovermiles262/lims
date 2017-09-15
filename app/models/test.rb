class Test < ApplicationRecord
  belongs_to :sample
  belongs_to :test_method
  has_one :batch

  def Test.methods_not_batched
    select(:test_method_id).distinct.where(batched: false)
  end
  
  def Test.available_for_batching(*method_id)
    if method_id.present?
      where(batched: false, :test_method_id => method_id)
    else
      where(batched: false)
    end
  end
end
