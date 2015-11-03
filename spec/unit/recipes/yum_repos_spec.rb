#
# Cookbook Name:: setup
# Spec:: default
#
# The MIT License (MIT)
#
# Copyright (c) 2015 J. Morgan Lieberthal
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'spec_helper'

RSpec.describe 'setup::yum_repos' do
  let(:chef_run) { ChefSpec::SoloRunner.new(opts).converge(described_recipe) }

  %w(7.0 7.1.1503).each do |version|
    context "on centos v#{version}" do
      let(:opts) { { platform: 'centos', version: version } }
      include_examples 'converges successfully'

      describe 'the local yum repos' do
        %w(base updates extras centosplus fasttrack).each do |repo|
          it "adds the yum repository #{repo}" do
            expect(chef_run).to create_yum_repository(repo).with(
              baseurl: "http://mirrors.jmorgan.org/centos/7/#{repo}/x86_64"
            )
          end
        end
      end
    end
  end
end
