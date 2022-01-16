require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.15.10"

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
             when "linux-386" then "566504a7e5e3563d85aadeed2fedf8e5409b0996d567de85d7442b6c2f8363ad"   # binary
             when "linux-amd64" then "fb713e9db8d16972d571d11d58f9503c21ce1955632de542a3647277b6317700"
             when "linux-arm64" then "7c839f7e19e6a394eebba197831c62a413a9725f34b6bff9d48dc63f4ef0b35c" # binary
             when "darwin-10.12-amd64" then "1f667cd0ee1c75aebe7e6fc7b218464351a5e4a9a655793baca84b30e4f13f4f"
             when "darwin-10.12-arm64" then "cd9e5c1252e5fc0b714bddd4b58c8ce66fe6ebb224266c96112cfc864c9c9a69"
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
