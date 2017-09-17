class Batch < ApplicationRecord
  has_many :tests
  belongs_to :test_method
  accepts_nested_attributes_for :tests, :allow_destroy => true

  after_create :update_batched_status

  private

  def Batch.available_methods
    available = Array.new
    Test.select(:test_method_id).distinct.where(batched: false).map do |method|
      available << [TestMethod.find_by(id: method.test_method_id).name, method.test_method_id]
    end
    available
  end

  def update_batched_status
    tests.update_all(batched: true)
  end

end
