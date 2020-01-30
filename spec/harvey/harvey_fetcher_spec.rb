describe Harvey::HarveyProjectFetcher do
  let(:fetcher) { described_class.new() }

  describe "get_sending_users_id" do
    it "returns sending time entry last week person" do
      Timecop.freeze("2017-03-07") do
        expect(fetcher.get_sending_users_id.first).to include("id" => 1782959)
        expect(fetcher.get_sending_users_id.size).to eql(1)
      end
    end
  end
end
