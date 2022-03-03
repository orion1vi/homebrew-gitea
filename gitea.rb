require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.3"

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
             when "linux-386" then "9a643ffa5ac38e81bdc49fdd8016229e6ca2b9387e1d2d767f5d4a7baded0592"   # binary
             when "linux-amd64" then "d684950b757d90fc8c4d16d530ee30714524b6a24dd7a17558209b2de1d7672e"
             when "linux-arm64" then "0d527eca60f8b5151ed626c76e0665c985f8644b84e0a4beeac5d79e44a49cfb" # binary
             when "darwin-10.12-amd64" then "a793ad486832e7655f9576fd9f9db77ac8d6d9e8dd2bd5534d23924db2c786f8"
             when "darwin-10.12-arm64" then "3e4d5d73dad20aec3785d8391867420dda2bdf461bd444859e369bc46f746332"
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
