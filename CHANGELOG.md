## Known Issue
### exec_query
SELECT clause missing Id causes model class to force insert a record, not update
```
irb(main):006> rows = SObjectModel.connection.exec_query "SELECT Name FROM Account LIMIT 1", model_class: Account
=>
[#<Account:0x0000724bada70970
...
irb(main):007> rows.first
=>
#<Account:0x0000724bada70970
 @Name="Express Logistics and Transport2",
 @current_attributes={:Name=>"Express Logistics and Transport2"},
 @original_attributes={:Name=>"Express Logistics and Transport2"},
 @updated_attributes={:Name=>nil}>

 => rows.first.save  #=> this does NEW RECORD INSERT, not Update because its Id is nil
 ```

### Child relationship in SELECT clause
child relationship that doesn't specify Id  in SELECT clause causes model class to force insert a record, not update
```
 irb(main):016> acc = Account.select(:Name, '(SELECT Name FROM Contacts)').where(Id: Contact.where.not(AccountId: nil).pluck(:AccountId)).take
=>
#<Account:0x0000724bae18f4b8
...
irb(main):017> acc
=>
#<Account:0x0000724bae18f4b8
 @Contacts=
  [#<Contact:0x0000724bacf411a8 @Name="Gonzalez Rose", @current_attributes={:Name=>"Gonzalez Rose"}, @original_attributes={:Name=>"Gonzalez Rose"}, @updated_attributes={:Name=>nil}>,
   #<Contact:0x0000724bae18f468 @Name="Forbes Sean", @current_attributes={:Name=>"Forbes Sean"}, @original_attributes={:Name=>"Forbes Sean"}, @updated_attributes={:Name=>nil}>],
 @Id="0015j00001U2XvEAAV",
 @Name="Edge Communications",
 @current_attributes={:Name=>"Edge Communications"},
 @original_attributes={:Name=>"Edge Communications", :Id=>"0015j00001U2XvEAAV"},
 @updated_attributes={:Name=>nil}>

irb(main):018> acc.Contacts.first.save #=> this does NEW RECORD INSERT, not Update because its Id is nil
 ```

## 0.1.4 - 2024-11-18
- FIX: Exception message of rest client was wrong
- NEW: SObject.generated_classes to identify classes that have benn already created

## 0.1.3 - 2024-11-04
- New: now rest client supports [describe global](https://developer.salesforce.com/docs/atlas.ja-jp.api_rest.meta/api_rest/resources_describeGlobal.htm)

## 0.1.2 - 2024-11-04
- CHANGE: Yamori changes the name to SObjectModel

## 0.1.1 - 2024-11-04
- FIX: select clause without Id causes to force inserting record, instead of update
- FIX: unable to set a field null for update
- MISC: small enhancement to Schema class

## 0.1.0 - 2024-10-19
the first minor release
