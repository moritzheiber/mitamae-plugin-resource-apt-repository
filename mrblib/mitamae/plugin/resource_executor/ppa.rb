module ::MItamae
  module Plugin
    module ResourceExecutor
      class Ppa < ::MItamae::ResourceExecutor::Base
        PpaRepoMissingError = Class.new(StandardError)

        def apply
          add_ppa! if desired.exists && !current.exists
          remove_ppa! unless desired.exists
        end

        private

        def pre_action
          raise PpaRepoMissingError, 'Missing repository paramter' unless attributes.repo

          required = 'software-properties-common'
          run_specinfra(:install_package, required) unless \
            run_specinfra(:check_package_is_installed, 'software-properties-common')
        end

        def set_current_attributes(current, action)
          current.exists = run_specinfra(:check_ppa_is_enabled, ppa)
        end

        def set_desired_attributes(desired, action)
          case action
          when :add
            desired.exists = true
          when :remove
            desired.exists = false
          end
        end

        def add_ppa!
          run_command("apt-add-repository -y #{ppa}")
        end

        def remove_ppa!
          run_command("apt-add-repository -y -r #{ppa}")
        end

        def ppa
          repo = attributes.repo
          repo = 'ppa:' + repo unless repo.slice(0..3) == 'ppa:'
          repo
        end
      end
    end
  end
end
