# frozen_string_literal: true

require 'spec_helper'

describe 'phased_updates' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:file_phased) { '/etc/apt/apt.conf.d/99phased-updates' }

      let :params do
        {
          allow_phased_packages: true
        }
      end

      it { is_expected.to compile.with_all_deps }

      it do
        is_expected.to create_file('/etc/apt/apt.conf.d/99phased').
          with_owner('root').
          with_group('root').
          with_content(
            %r{Update-Manager::Always-Include-Phased-Updates;}
          ).with_content(
            %r{APT::Get::Always-Include-Phased-Updates;}
          )
      end

      it { is_expected.to create_file(file_phased).with_owner('root').with_group('root') }

      it do
        is_expected.to create_file(file_phased).with(
          owner: 'root',
          group: 'root',
        ).
        with_content(
          %r{Update-Manager::Always-Include-Phased-Updates;}
        ).with_content(
          %r{APT::Get::Always-Include-Phased-Updates;}
        )
      end
    end
  end
end
