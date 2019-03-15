# frozen_string_literal: true

module ::MItamae
  module Plugin
    module Resource
      class AptRepository < ::MItamae::Resource::Base
        define_attribute :action, default: :add
        define_attribute :url, type: String, default_name: true
        define_attribute :ppa, type: [TrueClass, FalseClass], default: false
        define_attribute :gpg_key, type: String
        define_attribute :keyserver, type: String, default: 'keyserver.ubuntu.com'

        self.available_actions = %i[add remove]
      end
    end
  end
end
