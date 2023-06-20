# == Schema Information
#
# Table name: oadmrights
#
#  id                   :bigint           not null, primary key
#  oadm_id              :bigint
#  oadmright_controller :string
#  oadmright_action     :string
#  oadmright_note       :string
#  oadmright_tf         :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require "test_helper"

class OadmrightTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
