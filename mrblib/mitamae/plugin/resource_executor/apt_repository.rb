# frozen_string_literal: true

module ::MItamae
  module Plugin
    module ResourceExecutor
      class AptRepository < ::MItamae::ResourceExecutor::Base
        UrlMissingError = Class.new(StandardError)

        def apply
          if desired.exists && !current.exists
            receive_key(desired.gpg_key, desired.keyserver) if desired.gpg_key
            add_repository!
          end

          remove_repository! unless desired.exists
        end

        private

        def pre_action
          raise UrlMissingError, 'Missing url parameter' unless attributes.url

          required = ['software-properties-common']
          required << 'gpg' if attributes.gpg_key

          required.each do |p|
            run_specinfra(:install_package, p) unless \
              run_specinfra(:check_package_is_installed, p)
          end
        end

        def set_current_attributes(current, _action)
          current.exists = run_specinfra(:check_ppa_is_enabled, attributes.url) if is_ppa?
          current.exists = repository_exists? unless is_ppa?
        end

        def set_desired_attributes(desired, action)
          desired.ppa = is_ppa?
          desired.url = attributes.url
          desired.gpg_key = attributes.gpg_key if attributes.gpg_key
          desired.keyserver = attributes.keyserver if attributes.keyserver

          if desired.ppa
            desired.url = 'ppa:' + desired.url unless has_ppa_prefix?(desired.url)
          end

          case action
          when :add
            desired.exists = true
          when :remove
            desired.exists = false
          end
        end

        def add_repository!
          run_command("apt-add-repository -y \'#{desired.url}\'") if desired.ppa
          unless desired.ppa
            proc do
              ::File.open(repo_filename(desired.url), 'w') do |file|
                file.write(desired.url)
              end
              update_cache
            end.call
          end
        end

        def remove_repository!
          run_command("apt-add-repository -y -r \'#{desired.url}\'") if desired.ppa
          run_specinfra(:remove_file, repo_filename(desired.url)) unless desired.ppa
        end

        def repo_filename(url)
          location, distribution, component = url.match(
            /https?:\/\/([^\s]*).{1}([^\s]*).{1}([^\s]*)/
          )
                                                 .captures.map { |part| part.gsub(/[\.\/]/, '_') }

          "/etc/apt/sources.list.d/#{location}_#{distribution}_#{component}.list"
        end

        def has_ppa_prefix?(url)
          url.slice(0..3) == 'ppa:'
        end

        def receive_key(key, server)
          run_command("curl -SsL #{key} | apt-key add -") if is_http_url?(key)
          run_command("apt-key adv --keyserver #{server} --recv-key #{key}") unless is_http_url?(key)
        end

        def is_ppa?
          has_ppa_prefix?(attributes.url) || attributes.ppa
        end

        def is_http_url?(http_url)
          /^https?:\/\// =~ http_url
        end

        def repository_exists?
          run_command("grep -o \'#{attributes.url.shellescape}\' /etc/apt/sources.list.d/*.list", error: false).exit_status == 0
        end

        def update_cache
          run_command('apt update -qq')
        end
      end
    end
  end
end
