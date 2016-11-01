require 'dragonfly/mongoid_data_store/version'
require 'dragonfly'
require 'mongoid-grid_fs'

Dragonfly::App.register_datastore(:mongoid){ Dragonfly::MongoidDataStore }

module Dragonfly
  class MongoidDataStore
    class DataNotFound < StandardError; end

    OBJECT_ID = BSON::ObjectId

    def write temp_object, opts={}
      content_type = opts[:content_type] || opts[:mime_type] || 'application/octet-stream'
      meta = temp_object.meta
      meta = meta.merge(opts[:meta]) if opts[:meta].present?

      temp_object.file do |f|
        grid_file = Mongoid::GridFS.put(f, content_type: content_type, meta: marshal_b64_encode(meta))
        grid_file.id.to_s
      end
    end

    def read uid
      grid_file = Mongoid::GridFS.get(uid)

      meta = {}
      meta = marshal_b64_decode(grid_file.meta) if grid_file.respond_to?(:meta)
      meta.merge!(stored_at: grid_file.upload_date) if grid_file.respond_to?(:upload_date)

      [ grid_file.data, meta ]

    rescue Mongoid::Errors::DocumentNotFound => e
      raise DataNotFound, "#{e} - #{uid}"
    end

    def destroy uid
      Mongoid::GridFs.delete(uid)
    end

    private # =============================================================

    def marshal_b64_encode object
      Dragonfly::Serializer.b64_encode(Marshal.dump(object))
    end

    def marshal_b64_decode object
      Dragonfly::Serializer.marshal_b64_decode(object)
    end
  end
end
