require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.20.4"
  license "MIT"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.com/gitea/#{version}/#{@@filename}"
  @@using = :nounzip

  if os == "darwin-10.12" || arch == "amd64"
    @@url += ".xz"
    @@using = nil
    depends_on "xz"
  end

  @@sha256 = case "#{os}-#{arch}"
             when "linux-386" then "ad38dba630a3598488ad46d74283f826b68905168f1830b2142c398074ed79d0"   # binary
             when "linux-amd64" then "66e64dfe991fb02c1a6f141eb4245be5de3d790e85df03d3659935dfdb070e39"
             when "linux-arm64" then "95f8e1b29f1402b4af5e12ed6d2da6fad35ae8c99f413e7afbf265aeb85eb6d7" # binary
             when "darwin-10.12-amd64" then "b814918cfb7efe5c41a03712d047ef7fdd2113fdd4cce3b1a0c46994923bf84a"
             when "darwin-10.12-arm64" then "941991b7edad8dd5026e843f611000d5a3032c0024272896c0bd6b13507b6fee"
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
