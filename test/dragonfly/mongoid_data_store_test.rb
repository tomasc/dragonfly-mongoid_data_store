require 'test_helper'
require 'dragonfly/mongoid_data_store'
require 'dragonfly/serializer'

describe Dragonfly::MongoidDataStore do
  include Dragonfly::Serializer

  let(:app) { Dragonfly.app }
  let(:content) { Dragonfly::Content.new(app, "Foo Bar!") }
  let(:data_store) { Dragonfly::MongoidDataStore.new }
  let(:meta) { { my_meta: 'my meta' } }

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
      uid = data_store.write(content, meta: meta)
      response = Mongoid::GridFS.get(uid)
      marshal_b64_decode(response.meta)[:my_meta].must_equal meta[:my_meta]
    end
  end

  describe '#read' do
    before do
      stored_content = Mongoid::GridFS.put(content.file, content_type: 'text/plain', meta: b64_encode(Marshal.dump(meta)))
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

  describe '#destroy' do
    before do
      @stored_content = Mongoid::GridFS.put(content.file)
    end

    it 'destroys data in the database' do
      res = data_store.destroy(@stored_content.id)
      res.must_equal true
      Mongoid::GridFS.find(_id: @stored_content.id).must_be_nil
    end
  end
end
