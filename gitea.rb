require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.16.2"

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
             when "linux-386" then "7265cc1fc023e64138be681f0886edd9b0d74b345ff753ae5ce11321e22aee9c"   # binary
             when "linux-amd64" then "d33675605fa6fc7574ca31c0f690210670ee26eaacdcf28a50a96133117bb812"
             when "linux-arm64" then "ac8c12c1f7fa82ecf15674dab74728f27a7d5604f529dc62a40ebdfbf816983a" # binary
             when "darwin-10.12-amd64" then "7f896eb5c5d1a9f787e530c36ad2e3bc04ebe60d3e571b8afcd5c72d7a557917"
             when "darwin-10.12-arm64" then "1cf80e083018c22106b85aa862c2a0c3c4b27448f8308885471d6b2e959118cb"
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
