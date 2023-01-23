require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.18.3"

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
             when "linux-386" then "a11491fbbda899af4f54fc3ba22e6ea172633c6097223c6f83b42711021bcb5f"   # binary
             when "linux-amd64" then "60d0f6e16ea7831a5f3acc7edf05ca7832403c8c53fd27876c4dbcc4059e1cd2"
             when "linux-arm64" then "e22ccdd9c34aa8a272baa3b864d933a39d3496a78d040417f412b2cab0b3fb63" # binary
             when "darwin-10.12-amd64" then "d23df79b81249d87dc34b92830b10916af26edc7145c8400964f41ea3b3c1c9a"
             when "darwin-10.12-arm64" then "4f8034c2d6f2af8f2b59046470390cfd0c6cd48a63c6a01a7903f01e755b1ee9"
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
