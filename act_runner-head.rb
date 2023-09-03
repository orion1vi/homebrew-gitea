require_relative './utils/macos_codesign.rb'

class ActRunnerHead < Formula
  desc "A runner for Gitea based on act"
  homepage "https://gitea.com/gitea/act_runner"
  version "main"
  license "MIT"

  os = OS.mac? ? "darwin" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "act_runner: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "act_runner-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/act_runner/#{version}/#{@@filename}"
  @@url += ".xz"
  @@using = nil
  depends_on "xz"

  @@sha256 = %x[ curl -sL #{@@url}.sha256 ].split.first

  sha256 @@sha256
  url @@url,
      using: @@using

  conflicts_with "act_runner", because: "both install act_runner binaries"
  def install
    if stable.using.blank?
      filename = ActRunnerHead.class_variable_get("@@filename")
    else
      filename = downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "act_runner"
  end

  test do
    system "#{bin}/act_runner", "--version"
  end
end
