require 'rails_helper'

describe Parking, type: :model do
  it { is_expected.to validate_presence_of(:plate) }
  it { is_expected.to validate_length_of(:plate).is_equal_to(8) }
  it { is_expected.to allow_value('ABC-1234').for(:plate) }
  it { is_expected.not_to allow_value('Invalid').for(:plate) }
  it { is_expected.not_to allow_value('123-ABCD').for(:plate) }
  it { is_expected.to validate_inclusion_of(:paid).in_array([ true, false ]) }
  it { is_expected.to validate_inclusion_of(:left).in_array([ true, false ]) }
end
