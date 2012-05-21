require 'spec_helper'

describe Api::V1 do
  describe "GET /api/commodities/:id" do
    let!(:commodity)    { create(:commodity) }

    before {
      get "/api/commodities/#{commodity.id}"
    }

    subject { JSON.parse(response.body) }

    it 'returns a particular commodity' do
      subject.at_json_path("_id").should == commodity.id.to_s
    end
  end
end
