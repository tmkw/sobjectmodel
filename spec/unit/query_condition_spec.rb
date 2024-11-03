require 'yamori/query_condition'
require_relative '../support/shared_examples/query_condition_examples'

RSpec.describe 'Yamori::QueryMethods::QueryCondition' do
  QueryContditionTestClass = Struct.new(:a, :b)

  let(:klass) { QueryContditionTestClass }
  let(:field_names) { [:Id, :a, :b] }
  let(:connection) { double('Some kind of Connection') }
  let(:query_condition) { Yamori::QueryMethods::QueryCondition.new(connection, klass.name, field_names) }

  describe '#all' do
    it_should_behave_like 'QueryCondition#all' do
      let(:connection) { instance_double('Yamori::SfCommandConnection') }
    end
  end

  describe '#pluck' do
    it_should_behave_like 'QueryCondition#pluck' do
      let(:connection) { instance_double('Yamori::SfCommandConnection') }
    end
  end

  describe '#count' do
    it_should_behave_like 'QueryCondition#count' do
      let(:connection) { instance_double('Yamori::SfCommandConnection') }
    end
  end

  describe '#min' do
    it_should_behave_like 'QueryCondition#min' do
      let(:connection) { instance_double('Yamori::SfCommandConnection') }
    end
  end

  describe '#max' do
    it_should_behave_like 'QueryCondition#max' do
      let(:connection) { instance_double('Yamori::SfCommandConnection') }
    end
  end

  describe '#take' do
    let(:row1) { QueryContditionTestClass.new(a: 'abc', b: 'def') }
    let(:row2) { QueryContditionTestClass.new(a: 'uvw', b: 'xyz') }
    let(:rows) { [row1, row2] }

    before do
      allow(query_condition).to receive(:limit).with(1).and_return(query_condition)
      allow(query_condition).to receive(:all).and_return(rows)
    end

    it "returns a values of paticular field" do
      expect(query_condition.take).to eq row1
      expect(query_condition).to have_received :limit
      expect(query_condition).to have_received :all
    end
  end

  describe '#where' do
    example 'Hash Style' do
      expect(query_condition.where(Name: 'Hoge Fuga')).to be query_condition
      expect(query_condition.conditions).to contain_exactly("Name = 'Hoge Fuga'")
    end

    example 'Hash Style (2)' do
      expect(query_condition.where(Name: 'Hoge Fuga', Age: 32)).to be query_condition
      expect(query_condition.conditions).to contain_exactly("Name = 'Hoge Fuga' AND Age = 32")
    end

    example 'Raw SOQL Style' do
      expect(query_condition.where("Name = 'Hoge Fuga' AND Age = 32")).to be query_condition
      expect(query_condition.conditions).to contain_exactly("Name = 'Hoge Fuga' AND Age = 32")
    end

    example 'Ternary Style' do
      expect(query_condition.where(:Name, :Like, '%Hoge%')).to be query_condition
      expect(query_condition.conditions).to contain_exactly("Name Like '%Hoge%'")
    end

    it 'stacks conditions' do
      query_condition
        .where(Name: 'Hoge Fuga', Age: 32)
        .where("Name = 'Hoge Fuga' AND Age = 32")
        .where(:Name, :Like, '%Hoge%')

      expect(query_condition.conditions).to contain_exactly(
        "Name = 'Hoge Fuga' AND Age = 32",
        "Name = 'Hoge Fuga' AND Age = 32",
        "Name Like '%Hoge%'"
      )
    end

    context 'empty input' do
      it 'just returns itself' do
        expect(query_condition.where()).to be query_condition
        expect(query_condition.where({})).to be query_condition
        expect(query_condition.where('')).to be query_condition
        expect(query_condition.conditions.size).to be 0
      end
    end

    context 'invalid input' do
      it 'just returns itself' do
        expect(query_condition.where(100)).to be query_condition
        expect(query_condition.conditions.size).to be 0
      end
    end

    context 'with nil' do
      it 'translates it to null' do
        expect(query_condition.where(Name: nil, Age: [10, 11, nil])).to be query_condition
        expect(query_condition.conditions).to contain_exactly("Name = null AND Age IN (10, 11, null)")
      end
      example 'in ternary style' do
        expect(query_condition.where(:Name, :"=", nil).where(:Age, :IN, [10, 11, nil])).to be query_condition
        expect(query_condition.conditions).to contain_exactly("Name = null", "Age IN (10, 11, null)")
      end
    end
  end

  describe '#not' do
    example 'Hash Style' do
      expect(query_condition.not(Name: 'Hoge Fuga')).to be query_condition
      expect(query_condition.conditions).to contain_exactly("(NOT(Name = 'Hoge Fuga'))")
    end

    example 'Hash Style (2)' do
      expect(query_condition.not(Name: 'Hoge Fuga', Age: 32)).to be query_condition
      expect(query_condition.conditions).to contain_exactly("(NOT(Name = 'Hoge Fuga' AND Age = 32))")
    end

    example 'Raw SOQL Style' do
      expect(query_condition.not("Name = 'Hoge Fuga' AND Age = 32")).to be query_condition
      expect(query_condition.conditions).to contain_exactly("(NOT(Name = 'Hoge Fuga' AND Age = 32))")
    end

    example 'Ternary Style' do
      expect(query_condition.not(:Name, :Like, '%Hoge%')).to be query_condition
      expect(query_condition.conditions).to contain_exactly("(NOT(Name Like '%Hoge%'))")
    end

    it 'stacks conditions' do
      query_condition
        .not(Name: 'Hoge Fuga', Age: 32)
        .not("Name = 'Hoge Fuga' AND Age = 32")
        .not(:Name, :Like, '%Hoge%')

      expect(query_condition.conditions).to contain_exactly(
        "(NOT(Name = 'Hoge Fuga' AND Age = 32))",
        "(NOT(Name = 'Hoge Fuga' AND Age = 32))",
        "(NOT(Name Like '%Hoge%'))"
      )
    end
  end

  describe '#select' do
    example 'set a field' do
      expect(query_condition.select(:Name)).to be query_condition
      expect(query_condition.fields).to contain_exactly(:Name)
    end

    example 'set fields' do
      expect(query_condition.select(:Name, :Age, :Phone)).to be query_condition
      expect(query_condition.fields).to contain_exactly(:Name, :Age, :Phone)
    end

    context 'no input' do
      it 'just returns itself' do
        expect(query_condition.select()).to be query_condition
        expect(query_condition.fields).to eq []
      end
    end
  end

  describe '#limit' do
    it 'sets record number limit' do
      expect(query_condition.limit(5)).to be query_condition
      expect(query_condition.limit_num).to be 5
    end
  end

  describe '#order' do
    example 'setting a record order key' do
      expect(query_condition.order(:Name)).to be query_condition
      expect(query_condition.row_order).to eq [:Name]
    end

    example 'setting a record order key' do
      expect(query_condition.order(:Name, :Age)).to be query_condition
      expect(query_condition.row_order).to eq [:Name, :Age]
    end

    example 'no input' do
      expect(query_condition.order).to be query_condition
      expect(query_condition.row_order).to be nil
    end
  end

  describe '#to_soql' do
    it 'constructs a soql' do
      query_condition
        .where(Name: 'John Smith', Age: 34)
        .not(Name: 'Ben White', Age: 18)
        .where(Phone: '090-xxxx-xxxx')
        .not(Phone: '080-xxxx-xxxx')
        .where(Country: ['Japan', 'USA', 'China'])
        .not(Country: ['India', 'Thai', 'Russia'])
        .where("ContactId IN ('a','b')")
        .not("ContactId IN ('c','d')")
        .where(:GroupName, :LIKE, '%abc%')
        .not(:GroupName, :LIKE, '%xyz%')
        .where(:LastModifiedDate, :>=, :"LAST_N_DAYS:90")
        .not(:LastModifiedDate, :>=, :YESTERDAY)
        .select(:Id, :Name, :"Account.Name", "(SELECT Name FROM Accounts)")
        .limit(30)
        .order(:Country, :Name)
      expect(query_condition.to_soql).to eq "SELECT Id, Name, Account.Name, (SELECT Name FROM Accounts) FROM QueryContditionTestClass WHERE Name = 'John Smith' AND Age = 34 AND (NOT(Name = 'Ben White' AND Age = 18)) AND Phone = '090-xxxx-xxxx' AND (NOT(Phone = '080-xxxx-xxxx')) AND Country IN ('Japan', 'USA', 'China') AND (NOT(Country IN ('India', 'Thai', 'Russia'))) AND ContactId IN ('a','b') AND (NOT(ContactId IN ('c','d'))) AND GroupName LIKE '%abc%' AND (NOT(GroupName LIKE '%xyz%')) AND LastModifiedDate >= LAST_N_DAYS:90 AND (NOT(LastModifiedDate >= YESTERDAY)) ORDER BY Country, Name LIMIT 30"
    end

    context 'with no where condtions' do
      it 'constructs a minimum soql' do
        expect(query_condition.select(:a, :b, :Id).to_soql).to eq "SELECT a, b, Id FROM QueryContditionTestClass"
      end
    end

    context 'when there is no select clause' do
      it 'adds all fields in select clause' do
        expect(query_condition.to_soql).to eq "SELECT Id, a, b FROM QueryContditionTestClass"
      end
    end

    context "when there isn't Id in select clause" do
      it 'adds Id fiel automatically' do
        expect(query_condition.select(:b).to_soql).to eq "SELECT b, Id FROM QueryContditionTestClass"
      end
    end
  end
end
