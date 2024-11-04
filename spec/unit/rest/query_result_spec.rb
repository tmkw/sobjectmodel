module SObjectModel::Rest
  RSpec.describe QueryResult do
    let(:raw_record) { single_sobject_hash }
    let(:prepared_record) { single_sobject_hash_without_attributes }
    let(:api_response) { %|{"totalSize": 1, "done": true, "records": [#{JSON.dump(raw_record)}]}| }
    let(:query_result) { QueryResult.new(api_response) }

    describe '#to_records' do
      before do
        allow(query_result).to receive(:prepare_record).with(raw_record).and_return(prepared_record)
      end

      it "converts API's raw record data into model-ready record data" do
        expect(query_result.to_records).to include prepared_record
        expect(query_result).to have_received :prepare_record
      end
    end

    describe '#prepare_record' do
      it 'eliminates key "attributes" from a record (Hash object)' do
        expect(query_result.__send__(:prepare_record, single_sobject_hash)).to eq({"Id" => "0015j00001dsDuhAAE", "Name" => "Aethna Home Products"})
      end

      it 'can treat a record including child-parent relationship' do
        expect(query_result.__send__(:prepare_record, hash_including_child_parent_relation))
        .to eq({
          "Id"   => "0035j00001RW3xbAAD",
          "Name" => "Akin Kristen",
          "Account" => { "Name" => "Aethna Home Products" }
        })
      end

      it 'can treat a record including parent-children relationship' do
        expect(query_result.__send__(:prepare_record, hash_including_parent_children_relation))
        .to eq({
          "Id"   => "0015j00001dsDuhAAE",
          "Name" => "Aethna Home Products",
          "Contacts" => [
            { "Name" => "Akin Kristen" },
            { "Name" => "Hoge Foobaz"  },
          ]
        })
      end

      it 'can treat a record with mixed relationships' do
        expect(query_result.__send__(:prepare_record, hash_including_mixed_relations))
        .to eq({
          "Id"   => "0015j00001dsDuhAAE",
          "Name" => "Hoge BazBar",
          "Account" => { "Name" => "Aethna Home Products" },
          "Contacts" => [
            { "Name" => "Akin Kristen", "Foo" => { "Name" => "Foo 001" }},
            { "Name" => "Hoge Foobaz",  "Foo" => { "Name" => "Foo 002" }},
          ]
        })
      end
    end

    def single_sobject_hash
      {
        "attributes" => {
          "type" => "Account",
          "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
        },
        "Id" => "0015j00001dsDuhAAE",
        "Name" => "Aethna Home Products"
      }
    end

    def single_sobject_hash_without_attributes
      {
        "Id" => "0015j00001dsDuhAAE",
        "Name" => "Aethna Home Products"
      }
    end

    def hash_including_child_parent_relation
      {
        "attributes" => {
          "type" => "Contact",
          "url" => "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
        },
        "Id" => "0035j00001RW3xbAAD",
        "Name" => "Akin Kristen",
        "Account" => {
          "attributes" => {
            "type" => "Account",
            "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
          },
          "Name" => "Aethna Home Products"
        }
      }
    end

    def hash_including_child_parent_relation_in_bulk_mode
      {
        "Id" => "0035j00001RW3xbAAD",
        "Name" => "Akin Kristen",
        "Account.Name" => "Aethna Home Products",
      }
    end

    def hash_including_parent_children_relation 
      {
        "attributes" => {
          "type" => "Account",
          "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
        },
        "Id" => "0015j00001dsDuhAAE",
        "Name" => "Aethna Home Products",
        "Contacts" => {
          "totalSize" => 1,
          "done" => true,
          "records" => [
            {
              "attributes" => {
                "type" => "Contact",
                "url" => "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
              },
              "Name" => "Akin Kristen"
            },
            {
              "attributes" => {
                "type" => "Contact",
                "url" => "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
              },
              "Name" => "Hoge Foobaz"
            }
          ]
        }
      }
    end

    def hash_including_mixed_relations 
      {
        "attributes" => {
          "type" => "Hoge__c",
          "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
        },
        "Id" => "0015j00001dsDuhAAE",
        "Name" => "Hoge BazBar",
        "Account" => {
          "attributes" => {
            "type" => "Account",
            "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
          },
          "Name" => "Aethna Home Products"
        },
        "Contacts" => {
          "totalSize" => 1,
          "done" => true,
          "records" => [
            {
              "attributes" => {
                "type" => "Contact",
                "url" => "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
              },
              "Name" => "Akin Kristen",
              "Foo" => {
                "attributes" => {
                  "type" => "Foo",
                  "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
                },
                "Name" => "Foo 001"
              }
            },
            {
              "attributes" => {
                "type" => "Contact",
                "url" => "/services/data/v61.0/sobjects/Contact/0035j00001RW3xbAAD"
              },
              "Name" => "Hoge Foobaz",
              "Foo" => {
                "attributes" => {
                  "type" => "Foo",
                  "url" => "/services/data/v61.0/sobjects/Account/0015j00001dsDuhAAE"
                },
                "Name" => "Foo 002"
              }
            }
          ]
        }
      }
    end
  end
end
