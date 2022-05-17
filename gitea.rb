require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.8"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/gitea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin-10.12" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "cbede0875766aead7945547c3ff0f6bffa93b6490dcea222ed0c56d1ed7db38d"   # binary
             when "linux-amd64" then "20fa86d4036b7fc30bc727c4aee2becfb986a29600d7aeeb73e9ce8234185b13"
             when "linux-arm64" then "7c04bea7a6c8241569f7f3e20a2732d9e5695defab4010178ac4a496c98024d9" # binary
             when "darwin-10.12-amd64" then "b681a789c43c176e7502e0de1fea07c2b4f695110fc7bc3cb09dce6097c56928"
             when "darwin-10.12-arm64" then "53822405fd9967ea2ff480b12a839a85f11e35aa44b53848e7f3b908c9723a3b"
             else
               raise "gitea: Unsupported system #{os}-#{arch}"
             end

  sha256 @@sha256
  url @@url,
      using: @@using

  conflicts_with "gitea-head", because: "both install gitea binaries"
  def install
    if stable.using.blank?
      filename = Gitea.class_variable_get("@@filename")
    else
      filename =  downloader.cached_location
    end
    apply_ad_hoc_signature(filename)
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
