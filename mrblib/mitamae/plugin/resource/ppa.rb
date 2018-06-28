module ::MItamae
  module Plugin
    module Resource
      class Ppa < ::MItamae::Resource::Base
        define_attribute :action, default: :add
        define_attribute :repo, type: String, default_name: true

        self.available_actions = [:add, :remove]
      end
    end
  end
end
