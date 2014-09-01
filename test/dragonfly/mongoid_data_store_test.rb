require 'test_helper'
require 'dragonfly/mongoid_data_store'
require 'dragonfly/serializer'

describe Dragonfly::MongoidDataStore do

  include Dragonfly::Serializer

  # ---------------------------------------------------------------------

  let(:app) { Dragonfly.app }
  let(:content) { Dragonfly::Content.new(app, "Foo Bar!") }
  let(:data_store) { Dragonfly::MongoidDataStore.new }

  # ---------------------------------------------------------------------

  describe '#write' do
    it "stores the data in the database" do
      uid = data_store.write(content)
      response = Mongoid::GridFS.get(uid)
      response.data.must_equal content.data
    end

    it 'stores default mime type' do
      uid = data_store.write(content)
      response = Mongoid::GridFS.get(uid)
      response.content_type.must_equal 'application/octet-stream'
    end

    it 'stores supplied mime type' do
      uid = data_store.write(content, content_type: 'text/plain')
      response = Mongoid::GridFS.get(uid)
      response.content_type.must_equal 'text/plain'
    end

    it 'stores additional meta data' do
      uid = data_store.write(content, meta: { my_meta: 'something' })
      response = Mongoid::GridFS.get(uid)
      marshal_b64_decode(response.meta)[:my_meta].must_equal 'something'
    end
  end

  # ---------------------------------------------------------------------

  describe '#read' do
    let(:meta) { { my_meta: 'my meta' } }

    before do
      stored_content = Mongoid::GridFS.put(content.file, content_type: 'text/plain', meta: marshal_b64_encode(meta))
      @result = data_store.read(stored_content.id)
    end

    it 'retrieves the file' do
      @result.first.must_equal content.data
    end

    it 'retrieves meta data' do
      @result.last.must_equal meta
    end

    it 'raises DataNotFound when file does not exist' do
      proc { data_store.read(BSON::ObjectId.new) }.must_raise Dragonfly::MongoidDataStore::DataNotFound
    end
  end

  # ---------------------------------------------------------------------

  # describe '#destroy' do

  #   it "should destroy the file in the database" do
  #     uid = data_store.write(content)
  #     data_store.destroy(uid)
  #     data_store.should_not_contain uid
  #   end

  # end

  # ---------------------------------------------------------------------

end