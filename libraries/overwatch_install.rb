module OverwatchCookbook
  class OverwatchInstall < ChefCompat::Resource

    resource_name :overwatch_install

    property :token, String, required: true

    property :version, String, default: '0.2-6'
    property :checksum, String, default: '39788d65681a1f931d19178ff60b20984baf012c81f324d638bfbaa74c5f988d'

    property :libnetfilter_queue_version, String, default: '1.0.0'
    property :libnetfilter_queue_checksum, String, default: '5215104241759505718f811f457729c21949a1872631fb2c0076a93fc00c0628'

    action :create do

      # Install dependencies

      %w{linux-headers-generic libnfnetlink-dev libmnl-dev}.each do |pkg|
        package pkg
      end

      if node['platform_version'].to_i == 12

        # Install libnetfilter_queue on Ubuntu 12

        nfq_pkg = "libnetfilter_queue-#{libnetfilter_queue_version}"

        remote_file "#{Chef::Config[:file_cache_path]}/#{nfq_pkg}.tar.bz2" do
          source "http://www.netfilter.org/projects/libnetfilter_queue/files/#{nfq_pkg}.tar.bz2"
          checksum libnetfilter_queue_checksum
          action :create_if_missing
        end

        bash "install-#{nfq_pkg}" do
          cwd Chef::Config[:file_cache_path]
          code <<-EOH
            tar -xjf #{nfq_pkg}.tar.bz2
            (cd #{nfq_pkg} && ./configure --prefix=/usr && make && make install)
          EOH
          not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/#{nfq_pkg}") }
        end
      end

      # Download and install Overwatch package

      pkg_path = "#{Chef::Config[:file_cache_path]}/overwatchd-0.2-1_amd64.deb"
      pkg_url = "http://packages.overwatchsec.com/ubuntu/overwatchd-#{version}_amd64.deb"

      remote_file pkg_path do
        source pkg_url
        checksum new_resource.checksum
      end

      dpkg_package 'overwatch' do
        source pkg_path
      end

      bash 'register-with-overwatch' do
        code <<-EOS
          sudo overwatchd --register --token #{token} --name #{new_resource.name} \
            && sudo touch /var/lib/overwatch/.registered
        EOS
        not_if { ::File.exists?('/var/lib/overwatch/.registered') }
      end

      service 'overwatchd' do
        action [:enable, :start]
      end
    end
  end
end
