require_relative './utils/macos_codesign.rb'

class Gitea < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "1.19.0"

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
             when "linux-386" then "f85fca601bf18666b0f4d30598539c1d05298ab677f85f3bd7db2d9908ef4b98"   # binary
             when "linux-amd64" then "063b271588ea556fc738c7e67f3a9605484d69f20bc44b2dbf5decedd9d4d4f5"
             when "linux-arm64" then "db938a4ffa1e0e54d636f6da2b55bb37a3f8970a87a4ead76dd526846ec8222b" # binary
             when "darwin-10.12-amd64" then "8d54f31ea5afed852c093e4c8200b3145987ecf5696aa928034c0792faa5e767"
             when "darwin-10.12-arm64" then "ddc9977d7d801c1d27b7edc8214e5014c2e6f1b5e1cfc36aae20064dda3550a5"
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
