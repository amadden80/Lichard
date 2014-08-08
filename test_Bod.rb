require 'test/unit'
require_relative 'lib/Bod'

class Resource < Bod
end

class Test_Bod < Test::Unit::TestCase
  def setup

  end

  def test_insert_new_record
    num_records = Resource.all.count
    body = 'new record '+ rand(0..1000).to_s
    resource = Resource.new({body: body})
    resource.save
    assert(Resource.all.last.body, 'Last record is the new record')
    assert(Resource.all.count == (num_records+1), 'Number of records increased by one')
  end

  def test_updateing_a_record
    resource = Resource.all.last
    old_body = resource.body
    new_body = 'new body '+ rand(0..1000).to_s
    resource.body = new_body
    resource.save
    resource = Resource.all.last
    assert(old_body!=new_body, 'New and old body do not match')
    assert(old_body!=resource.body, 'Body has changed')
    assert(new_body==resource.body, 'Body is the new_body')
  end

end
